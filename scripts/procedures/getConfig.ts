import { compat } from "../deps.ts";

export const getConfig = compat.getConfig({
  "password": {
    "type": "string",
    "nullable": false,
    "name": "Password",
    "description": "The password for connecting to the server.",
    "default": {
      "charset": "a-k,m-z,2-9",
      "len": 20
    },
    "pattern": "^[^\\n\"]*$",
    "pattern-description": "Must not contain newline or quote characters.",
    "masked": true,
    "copyable": true
  },
  "address-private-key": {
    "name": "Tor Private Key",
    "description": "Private key from which your cups address was derived",
    "type": "pointer",
    "subtype": "package",
    "package-id": "cups",
    "target": "tor-key",
    "interface": "main"
  }
})
