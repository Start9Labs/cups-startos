VERSION := $(shell yq e '.version' manifest.yaml)
BACKEND_SRC := $(shell find ./cups-messenger -name '*.rs') cups-messenger/Cargo.toml cups-messenger/Cargo.lock
FRONTEND_SRC := $(shell find cups-messenger-ui/ -type d \( -path cups-messenger-ui/www -o -path cups-messenger-ui/node_modules \) -prune -o -name '*' -print)
S9PK_PATH=$(shell find . -name cups.s9pk -print)
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

install: cups.s9pk
	appmgr install cups.s9pk

cups.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md 
	embassy-sdk pack

verify: cups.s9pk $(S9PK_PATH)
	embassy-sdk verify $(S9PK_PATH)

image.tar: Dockerfile docker_entrypoint.sh cups-messenger/target/aarch64-unknown-linux-musl/release/cups manifest.yaml httpd.conf cups-messenger-ui/www config.sh
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/cups --platform=linux/arm64 -o type=docker,dest=image.tar .

cups-messenger-ui/www: $(FRONTEND_SRC) cups-messenger-ui/node_modules
	npm --prefix cups-messenger-ui run build-prod

cups-messenger-ui/node_modules: cups-messenger-ui/package.json cups-messenger-ui/package-lock.json
	npm --prefix cups-messenger-ui install

cups-messenger/target/aarch64-unknown-linux-musl/release/cups: $(BACKEND_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/cups-messenger:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/cups-messenger:/home/rust/src start9/rust-musl-cross:aarch64-musl musl-strip target/aarch64-unknown-linux-musl/release/cups

cups-messenger/Cargo.toml: manifest.yaml
	toml set cups-messenger/Cargo.toml package.version $(VERSION) > cups-messenger/Cargo.toml.tmp
	mv cups-messenger/Cargo.toml.tmp cups-messenger/Cargo.toml

cups-messenger-ui/package.json: manifest.yaml
	jq ".version = \"$(VERSION)\"" cups-messenger-ui/package.json > cups-messenger-ui/package.json.tmp
	mv cups-messenger-ui/package.json.tmp cups-messenger-ui/package.json

httpd.conf: manifest.yaml httpd.conf.template
	tiny-tmpl manifest.yaml < httpd.conf.template > httpd.conf
