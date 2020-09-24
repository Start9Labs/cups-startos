ASSETS := $(shell yq r manifest.yaml assets.*.src)
ASSET_PATHS := $(addprefix assets/,$(ASSETS))
VERSION := $(shell yq r manifest.yaml version)
BACKEND_SRC := $(shell find ./cups-messenger -name '*.rs') cups-messenger/Cargo.toml cups-messenger/Cargo.lock
FRONTEND_SRC := $(shell find cups-messenger-ui/ -type d \( -path cups-messenger-ui/www -o -path cups-messenger-ui/node_modules \) -prune -o -name '*' -print)

.DELETE_ON_ERROR:

all: cups.s9pk

clean:
	test ! -f cups.s9pk || rm cups.s9pk
	test ! -f image.tar || rm image.tar
	test ! -f cups-messenger-ui/www || rm -r cups-messenger-ui/www
	test ! -f cups-messenger-ui/node_modules || rm -r cups-messenger-ui/node_modules
	test ! -f cups-messenger/target/armv7-unknown-linux-musleabihf/release/cups || rm cups-messenger/target/armv7-unknown-linux-musleabihf/release/cups
	test ! -f httpd.conf || rm httpd.conf

install: cups.s9pk
	appmgr install cups.s9pk

cups.s9pk: manifest.yaml config_spec.yaml config_rules.yaml image.tar instructions.md $(ASSET_PATHS)
	appmgr -vv pack $(shell pwd) -o cups.s9pk
	appmgr -vv verify cups.s9pk

image.tar: Dockerfile docker_entrypoint.sh cups-messenger/target/armv7-unknown-linux-musleabihf/release/cups manifest.yaml httpd.conf cups-messenger-ui/www
	DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/cups --platform=linux/arm/v7 -o type=docker,dest=image.tar .

cups-messenger-ui/www: $(FRONTEND_SRC) cups-messenger-ui/node_modules
	npm --prefix cups-messenger-ui run build-prod

cups-messenger-ui/node_modules: cups-messenger-ui/package.json cups-messenger-ui/package-lock.json
	npm --prefix cups-messenger-ui install

cups-messenger/target/armv7-unknown-linux-musleabihf/release/cups: $(BACKEND_SRC)
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/cups-messenger:/home/rust/src start9/rust-musl-cross:armv7-musleabihf cargo +beta build --release
	docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/cups-messenger:/home/rust/src start9/rust-musl-cross:armv7-musleabihf musl-strip target/armv7-unknown-linux-musleabihf/release/cups

cups-messenger/Cargo.toml: manifest.yaml
	toml set cups-messenger/Cargo.toml package.version $(VERSION) > cups-messenger/Cargo.toml.tmp
	mv cups-messenger/Cargo.toml.tmp cups-messenger/Cargo.toml

cups-messenger-ui/package.json: manifest.yaml
	jq ".version = \"$(VERSION)\"" cups-messenger-ui/package.json > cups-messenger-ui/package.json.tmp
	mv cups-messenger-ui/package.json.tmp cups-messenger-ui/package.json

httpd.conf: manifest.yaml httpd.conf.template
	tiny-tmpl manifest.yaml < httpd.conf.template > httpd.conf
