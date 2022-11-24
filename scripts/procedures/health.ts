import { types as T, healthUtil } from "../deps.ts";

export const health: T.ExpectedExports.health = {
  // deno-lint-ignore require-await
  async "web-ui"(effects, duration) {
    return healthUtil.checkWebUrl("http://cups.embassy")(effects, duration).catch(healthUtil.catchError(effects))
  },
};
