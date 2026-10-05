# vendor/

Third-party code vendored into this repo because upstream does not build on the
pinned Zig version yet.

## `mcp/`

- **Upstream**: [`muhammad-fiaz/mcp.zig`](https://github.com/muhammad-fiaz/mcp.zig) `0.0.5`
  (commit `25b2ac418c5a62c48144eece0cb8b25ae0b45886`), MIT-style LICENSE kept at
  `vendor/mcp/LICENSE`.
- **Patch**: one hunk in `build.zig`. Upstream writes

  ```zig
  if (b.args) |args| run_artifact.addArgs(args);
  ```

  and `std.Build.args` was removed in Zig 0.17, so the build script fails before
  anything is compiled. The vendored copy replaces it with

  ```zig
  if (@hasDecl(@TypeOf(run_artifact.*), "addPassthruArgs")) {
      run_artifact.addPassthruArgs();
  } else if (@hasField(@TypeOf(b.*), "args")) {
      if (b.args) |args| run_artifact.addArgs(args);
  }
  ```

  which is a no-op on 0.17 (the run step only exists for the package's own
  examples, not for us).
- **Why not a normal `url` + `hash` dependency?** Zig would fetch the unpatched
  upstream copy. A `.path` dependency keeps the build deterministic.
- **Why not 0.0.6?** Its dependency chain — `httpx.zig 0.2.x` → `loaders` →
  `tint`, and `httpx.zig` → `treesitter` — all use the removed `b.args` in their
  build scripts, so the build fails while configuring those packages.

### Removing it

When upstream mcp.zig (and everything it depends on) supports Zig 0.17:

1. `rm -rf vendor/mcp`
2. in `build.zig.zon`, replace the `.mcp = .{ .path = "vendor/mcp" }` entry with
   a normal `url` + `hash` pin to the new version
   (`zig fetch --save git+https://github.com/muhammad-fiaz/mcp.zig#<commit>`)
3. check `src/mcp_demo.zig` against the new API
4. drop the `vendor` exclusion from `.github/workflows/build.yml` and
   `.pre-commit-config.yaml`, and this file

The vendored tree is intentionally **not** run with `zig fmt` (0.17's formatter
would rewrite 4 of its files, e.g. `@intFromEnum` → `@backingInt`), so it stays
diffable against upstream. It is excluded from the lint step for that reason.
