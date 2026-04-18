# yoga.zig

A [Zig](https://ziglang.org) package for [Yoga](https://www.yogalayout.dev/) (_A portable layout engine targeting web standards_).

## Usage

Requires Zig 0.16.0.

```sh
zig fetch --save git+https://github.com/sobeston/yoga.zig.git#3.2.1
```

```zig
const yoga_dep = b.dependency("yoga_cpp", .{
    .target = target,
    .optimize = optimize,
});
const yoga_lib = yoga_dep.artifact("yogacore");
root.linkLibrary(yoga_lib);
```
