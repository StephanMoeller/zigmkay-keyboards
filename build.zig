const std = @import("std");

const microzig = @import("microzig");

const MicroBuild = microzig.MicroBuild(.{
    .rp2xxx = true,
});

pub fn build(b: *std.Build) void {
    const mz_dep = b.dependency("microzig", .{});
    const mb = MicroBuild.init(b, mz_dep) orelse return;

    const target = mb.ports.rp2xxx.boards.raspberrypi.pico.*; //  b.standardTargetOptions(.{});
    const optimize: std.builtin.OptimizeMode = .ReleaseSafe; //b.standardOptimizeOption(.{});

    const zigmkay_dep = b.dependency("zigmkay", .{});
    const zigmkay_mod = zigmkay_dep.module("zigmkay");

    const rollercole_keymap_mod = b.createModule(.{
        .root_source_file = .{
            .src_path = .{ .owner = b, .sub_path = "src/shared_keymap.zig" },
        },
        .imports = &.{.{ .name = "zigmkay", .module = zigmkay_mod }},
    });

    const kb_names = .{"clackychan"};
   
inline for(kb_names) |name| {
    const kb = mb.add_firmware(.{
        .name = name,
        .target = &target,
        .optimize = optimize,
        .root_source_file = b.path(   std.fmt.comptimePrint("src/{s}/main.zig", .{name})  ),
        .imports = &.{
            // TOOD: Move back to normal imports once working
            // .{ .name = "zigmkay", .module = zigmkay_mod },
            .{ .name = "rollercole_shared_keymap", .module = rollercole_keymap_mod },
        },
    });

    kb.add_app_import("zigmkay", zigmkay_mod, .{ .depend_on_microzig = true });
    // We call this twice to demonstrate that the default binary output for
    // RP2040 is UF2, but we can also output other formats easily
    mb.install_firmware(kb, .{});
}
    

        
    
}
