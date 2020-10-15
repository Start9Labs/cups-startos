# Wrapper for Cups Messenger

This project wraps the [Cups Messenger](https://github.com/Start9Labs/cups-messenger) project for EmbassyOS. Cups is a peer-to-peer, encrypted instant messaging service with no central servers or trusted third parties. Messages are relayed by and saved on the two communicating servers and nowhere else.

## Dependencies

The following system level dependencies need to be installed in order to build this project. Follow each guide to get set up:

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
- [make](https://www.gnu.org/software/make/)

## Cloning

Clone the project locally. Note the submodule link to the original project(s). 

```
git clone git@github.com:Start9Labs/cups-wrapper.git
cd cups-wrapper
git submodule update --init
```

## Building

To build the project, run the following commands:

```
make
```

## Installing (on Embassy)

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.
Run the following command to determine successful install:

```
appmgr install cups.s9pk
```