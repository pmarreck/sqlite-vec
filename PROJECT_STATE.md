# PROJECT_STATE

## What this repo is
Fork of `asg017/sqlite-vec` with Zig build support for static linking into `codescan`.

## What changed
- Added `build.zig` + `build.zig.zon` to build:
  - `sqlite3` (static lib from sqlite amalgamation)
  - `sqlite_vec0` (static lib)
  - `vec0` (shared loadable extension)
- `sqlite-vec.h` is generated at build time from `VERSION` + `sqlite-vec.h.tmpl`.
- Added `flake.nix` to fetch sqlite amalgamation and set build env vars.

## Build
- `nix develop -c zig build`

## Required env
- `SQLITE_VEC_SQLITE_AMALGAMATION_DIR` must point at a directory containing
  `sqlite3.c` and `sqlite3.h` (sqlite amalgamation). The dev shell sets this.

## Outputs
- `zig-out/lib/libsqlite3.a`
- `zig-out/lib/libsqlite_vec0.a`
- `zig-out/lib/libvec0.*` (shared extension for runtime loading)
- `zig-out/include/sqlite-vec.h`

## Notes
- `codescan` consumes this fork as a git dependency and links the static libs;
  it calls `sqlite3_vec_init` directly (no runtime loading).
