# zig-dome

A collection of Zig language feature demos and learning exercises, organized by topic.

## Topics

| Module | Description |
|--------|-------------|
| [`variables`](src/variables.zig) | Container-level variables, thread-local storage, comptime variables |
| [`integers`](src/integers.zig) | Float special values (inf, nan), strict vs optimized float mode |
| [`arrays`](src/integers.zig) | Array declarations, comptime initialization, concatenation, repetition |
| [`pointer`](src/pointer.zig) | Pointer basics, slices, casting, comptime pointers, `@intFromPtr` / `@ptrFromInt` |
| [`vector`](src/vector.zig) | SIMD vectors, vector ↔ array ↔ slice conversion, destructuring |

## Getting Started

### Prerequisites

- [Zig](https://ziglang.org/) `0.14.0` or later

### Run Tests

```bash
zig build test
```

### Format Check

```bash
zig fmt --check .
```

### Format

```bash
zig fmt .
```

## Project Structure

```
zig-dome/
├── .github/workflows/build.yml   # CI: test + lint on push
├── build.zig                      # Build configuration
├── build.zig.zon                  # Package manifest
└── src/
    ├── main.zig                   # Entry point (empty)
    ├── root.zig                   # Module re-exports
    ├── arrays.zig                 # Array demos & tests
    ├── integers.zig               # Integer / float demos & tests
    ├── pointer.zig                # Pointer demos & tests
    ├── variables.zig              # Variable demos & tests
    └── vector.zig                 # SIMD vector demos & tests
```

## License

This project is provided as-is for learning purposes.
