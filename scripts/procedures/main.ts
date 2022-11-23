import { types as T } from "../deps.ts";

// deno-lint-ignore require-await
export const main: T.ExpectedExports.main = async (effects) => {
  return effects.runDaemon(
    {
      command: "docker_entrypoint.sh",
      args: [],
    },
  ).wait();
};