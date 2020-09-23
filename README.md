# Wrapper for Cups Messenger

## Dependencies
- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [rust-musl-cross](https://github.com/Start9Labs/rust-musl-cross)
- [yq](https://mikefarah.gitbook.io/yq)
- [jq](https://stedolan.github.io/jq/download)
- [tiny-tmpl](https://github.com/Start9Labs/templating-engine-rs)
- [toml-cli](https://github.com/gnprice/toml-cli)
- [rust](https://rustup.rs)
- [npm](https://www.npmjs.com/get-npm)
- [appmgr](https://github.com/Start9Labs/appmgr)

## Cloning
```
git clone git@github.com:Start9Labs/cups-wrapper.git
cd cups-wrapper
git submodule update --init
```

## Building
```
make
```

## Installing
```
appmgr install cups.s9pk
```