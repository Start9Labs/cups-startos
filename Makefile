PKG_VERSION := $(shell yq e ".version" manifest.yaml)
PKG_ID := $(shell yq e ".id" manifest.yaml)
BACKEND_SRC := $(shell find ./cups-messenger -name '*.rs') cups-messenger/Cargo.toml cups-messenger/Cargo.lock
FRONTEND_SRC := $(shell find cups-messenger-ui/ -type d \( -path cups-messenger-ui/www -o -path cups-messenger-ui/node_modules \) -prune -o -name '*' -print)
PWD=$(shell pwd)

.DELETE_ON_ERROR:

all: verify

clean:
	test ! -f cups.s9pk || rm cups.s9pk
	test ! -f image.tar || rm image.tar
	test ! -f cups-messenger-ui/www || rm -r cups-messenger-ui/www
	test ! -f cups-messenger-ui/node_modules || rm -r cups-messenger-ui/node_modules
	test ! -f cups-messenger/target/aarch64-unknown-linux-musl/release/cups || rm cups-messenger/target/aarch64-unknown-linux-musl/release/cups
	test ! -f httpd.conf || rm httpd.conf
	rm -rf docker-images
	rm -f scripts/*.js

# assumes /etc/embassy/config.yaml exists on local system with `host: "http://embassy-server-name.local"` configured
install: $(PKG_ID).s9pk
	embassy-cli package install $(PKG_ID).s9pk

verify: $(PKG_ID).s9pk
	embassy-sdk verify s9pk $(PKG_ID).s9pk

$(PKG_ID).s9pk: manifest.yaml instructions.md LICENSE icon.png scripts/embassy.js docker-images/aarch64.tar docker-images/x86_64.tar
	if ! [ -z "$(ARCH)" ]; then cp docker-images/$(ARCH).tar image.tar; fi
	embassy-sdk pack

docker-images/aarch64.tar: Dockerfile docker_entrypoint.sh cups-messenger/target/aarch64-unknown-linux-musl/release/cups manifest.yaml httpd.conf cups-messenger-ui/www
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --build-arg ARCH=aarch64 --build-arg PLATFORM=arm64 --platform=linux/arm64/v8 -o type=docker,dest=docker-images/aarch64.tar .

docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh cups-messenger/target/x86_64-unknown-linux-musl/release/cups manifest.yaml httpd.conf cups-messenger-ui/www
	mkdir -p docker-images
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --build-arg ARCH=x86_64 --build-arg PLATFORM=amd64 --platform=linux/amd64 -o type=docker,dest=docker-images/x86_64.tar .

cups-messenger-ui/www: $(FRONTEND_SRC) cups-messenger-ui/node_modules
	npm --prefix cups-messenger-ui run build-prod

cups-messenger-ui/node_modules: cups-messenger-ui/package.json cups-messenger-ui/package-lock.json
	npm --prefix cups-messenger-ui install

cups-messenger/target/aarch64-unknown-linux-musl/release/cups: $(BACKEND_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/cups-messenger:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release

cups-messenger/target/x86_64-unknown-linux-musl/release/cups: $(BACKEND_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/cups-messenger:/home/rust/src start9/rust-musl-cross:x86_64-musl cargo +beta build --release

cups-messenger/Cargo.toml: manifest.yaml
	toml set cups-messenger/Cargo.toml package.version $(PKG_VERSION) > cups-messenger/Cargo.toml.tmp
	mv cups-messenger/Cargo.toml.tmp cups-messenger/Cargo.toml

cups-messenger-ui/package.json: manifest.yaml
	jq ".version = \"$(PKG_VERSION)\"" cups-messenger-ui/package.json > cups-messenger-ui/package.json.tmp
	mv cups-messenger-ui/package.json.tmp cups-messenger-ui/package.json

httpd.conf: manifest.yaml httpd.conf.template
	tiny-tmpl manifest.yaml < httpd.conf.template > httpd.conf

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js