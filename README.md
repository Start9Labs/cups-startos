# Wrapper for Cups Messenger

[Cups Messenger](https://github.com/Start9Labs/cups-messenger) is a peer-to-peer, encrypted instant messaging service with no central servers or trusted third parties. Messages are relayed by and saved on the two communicating servers and nowhere else. This repository creates the `s9pk` package that is installed to run `cups` on [StartOS](https://github.com/Start9Labs/start-os/).

This project is no longer maintained by Start9 and is open to community contributions or takeover. 

## Dependencies

Install the following system dependencies to build this project by following the instructions in the provided links. You can also find detailed steps to setup your environment in the service packaging [documentation](https://github.com/Start9Labs/service-pipeline#development-environment).

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [rust-musl-cross](https://github.com/Start9Labs/rust-musl-cross)
- [yq](https://mikefarah.gitbook.io/yq)
- [jq](https://stedolan.github.io/jq/download)
- [tiny-tmpl](https://github.com/Start9Labs/templating-engine-rs)
- [toml-cli](https://github.com/gnprice/toml-cli)
- [rust](https://rustup.rs)
- [npm](https://www.npmjs.com/get-npm)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/blob/master/backend/install-sdk.sh)
- [make](https://www.gnu.org/software/make/)
- [deno](https://deno.land/#installation)

## Cloning

Clone the project locally. Note the submodule link to the original project(s). 

```
git clone git@github.com:Start9Labs/cups-wrapper.git
cd cups-wrapper
git submodule update --init
```

## Building

To build the `cups` package, run the following command:

```
make
```

## Installing (on embassyOS)

Run the following commands to install:

> :information_source: Change embassy-server-name.local to your Embassy address

```
embassy-cli auth login
# Enter your embassy password
embassy-cli --host https://embassy-server-name.local package install cups.s9pk
```

If you already have your `embassy-cli` config file setup with a default `host`,
you can install simply by running:

```
make install
```

> **Tip:** You can also install the cups.s9pk using **Sideload Service** under
the **Embassy > Settings** section.

### Verify Install

Go to your Embassy Services page, select **Cups Messenger**, configure and start the service. Then, verify its interfaces are accessible.

**Done!** 
