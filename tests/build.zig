const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const yoga_dep = b.dependency("yoga", .{
        .target = target,
        .optimize = optimize,
    });

    const yogacore = yoga_dep.artifact("yogacore");

    const include_tree = yogacore.getEmittedIncludeTree();
    const yoga_h = b.addTranslateC(.{
        .target = target,
        .optimize = optimize,
        .root_source_file = include_tree.path(b, "yoga/Yoga.h"),
    });
    yoga_h.addIncludePath(include_tree);

    const test_module = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
    test_module.linkLibrary(yogacore);

    const yoga_h_zig = yoga_h.addModule("yoga");
    test_module.addImport("yoga", yoga_h_zig);

    const unit_tests = b.addTest(.{
        .root_module = test_module,
    });

    const test_step = b.step("test", "Run unit tests");
    const run_unit_tests = b.addRunArtifact(unit_tests);
    test_step.dependOn(&run_unit_tests.step);

    b.default_step = test_step;
}
