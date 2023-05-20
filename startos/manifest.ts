import { setupManifest } from '@start9labs/start-sdk/lib/manifest/setupManifest'

export const manifest = setupManifest({
  id: 'cups',
  title: 'Cups Messenger',
  version: '0.3.9.1',
  releaseNotes: 'Revamped for StartOS 0.4.0',
  license: 'gpl',
  replaces: Array<string>('Signal', 'iMessage'),
  wrapperRepo: 'https://github.com/Start9Labs/cups-startos',
  upstreamRepo: 'https://github.com/Start9Labs/cups-messenger',
  supportSite: 'https://github.com/Start9Labs/cups-startos/issues',
  marketingSite: 'https://github.com/Start9Labs/cups-startos',
  donationUrl: 'https://donate.start9.com/',
  description: {
    short: 'Bare-bones, Tor-based, peer-to-peer, encrypted, private messaging',
    long: 'Cups is a private, self-hosted, peer-to-peer, Tor-based, instant messenger. Unlike other end-to-end encrypted messengers, with Cups there are no trusted third parties.',
  },
  assets: {
    license: 'LICENSE',
    icon: 'assets/icon.png',
    instructions: 'assets/instructions.md',
  },
  volumes: {
    main: 'data',
  },
  containers: {
    main: {
      image: 'main',
      mounts: {
        main: '/root',
      },
    },
  },
  alerts: {
    install: null,
    update: null,
    uninstall: null,
    restore: null,
    start: null,
    stop: null,
  },
  dependencies: {},
})

export type Manifest = typeof manifest
