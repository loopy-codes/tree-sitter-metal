const assert = require("node:assert");
const { test } = require("node:test");

test("can load module", () => {
  const Metal = require(".");
  assert.ok(Metal, "Module should load");
  assert.ok(Metal.language, "Module should export language");
  assert.strictEqual(
    typeof Metal.language,
    "object",
    "Language should be an object",
  );
});
