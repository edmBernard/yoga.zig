const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("yoga_cpp", .{});

    const yoga_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    const lib = b.addLibrary(.{
        .name = "yogacore",
        .root_module = yoga_mod,
    });

    yoga_mod.addIncludePath(upstream.path(""));

    yoga_mod.addCSourceFiles(.{
        .root = upstream.path(""),
        .files = source_files,
        .flags = &.{
            "-Wall",
            "-Wextra",
            "-Wpedantic",
            "-Wformat",
            "-std=c++20",
        },
    });

    for (includes) |inc| {
        lib.installHeader(upstream.path(inc), inc);
    }

    b.installArtifact(lib);
}

const includes: []const []const u8 = &.{
    "yoga/YGConfig.h",
    "yoga/YGEnums.h",
    "yoga/YGMacros.h",
    "yoga/YGNode.h",
    "yoga/YGNodeLayout.h",
    "yoga/YGNodeStyle.h",
    "yoga/YGPixelGrid.h",
    "yoga/YGValue.h",
    "yoga/Yoga.h",
};

const source_files: []const []const u8 = &.{
    "yoga/YGEnums.cpp",
    "yoga/YGPixelGrid.cpp",
    "yoga/YGConfig.cpp",
    "yoga/YGNode.cpp",
    "yoga/event/event.cpp",
    "yoga/algorithm/CalculateLayout.cpp",
    "yoga/algorithm/PixelGrid.cpp",
    "yoga/algorithm/Cache.cpp",
    "yoga/algorithm/FlexLine.cpp",
    "yoga/algorithm/AbsoluteLayout.cpp",
    "yoga/algorithm/Baseline.cpp",
    "yoga/YGValue.cpp",
    "yoga/YGNodeStyle.cpp",
    "yoga/config/Config.cpp",
    "yoga/node/LayoutResults.cpp",
    "yoga/node/Node.cpp",
    "yoga/YGNodeLayout.cpp",
    "yoga/debug/Log.cpp",
    "yoga/debug/AssertFatal.cpp",
};
