const std = @import("std");
const flash = @import("zig_flash");
const microzig = @import("microzig");

const MicroBuild = microzig.MicroBuild(.{
    .rp2xxx = true,
});

var string_buffer: [1000]u8 = undefined;
pub fn build(b: *std.Build) void {
    const mb = MicroBuild.init(b, b.dependency("microzig", .{})) orelse return;

    const target = mb.ports.rp2xxx.boards.raspberrypi.pico.*; //  b.standardTargetOptions(.{});
    const optimize: std.builtin.OptimizeMode = .ReleaseSafe; //b.standardOptimizeOption(.{});

    // Options
    const kbname = b.option([]const u8, "kbname", "Target Microsoft Windows") orelse @panic("missing kb");

    const zigmkay_dep = b.dependency("zigmkay", .{});
    const zigmkay_mod = zigmkay_dep.module("zigmkay");

    const rollercole_keymap_mod = b.createModule(.{
        .root_source_file = .{
            .src_path = .{ .owner = b, .sub_path = "src/shared_keymap.zig" },
        },
        .imports = &.{.{ .name = "zigmkay", .module = zigmkay_mod }},
    });

    const kb = mb.add_firmware(.{
        .name = kbname,
        .target = &target,
        .optimize = optimize,
        .root_source_file = b.path(std.fmt.bufPrint(&string_buffer, "src/{s}/main.zig", .{kbname}) catch @panic("error!")),
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

    const flash_dep = b.dependency("zig_flash", .{});
    const flash_exe = flash_dep.artifact("zig_flash");

    _ = flash.addFlashStep(b, flash_exe, .{
        .input_name = std.fmt.bufPrint(&string_buffer, "{s}.uf2", .{kbname}) catch @panic("error!"),
        .mount_point = "F:/",
    });
}
