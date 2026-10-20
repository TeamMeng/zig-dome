const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    try std.Io.File.stdout().writeStreamingAll(io, "Hello, Zig\n");

    var output_buffer: [1024]u8 = undefined;

    var stdout_writer = std.Io.File.stdout().writer(io, &output_buffer);

    const writer = &stdout_writer.interface;

    try writer.print("Hello {s}\n", .{"Xiao Ming"});
    try writer.print("Your age is {d}\n", .{18});

    try writer.flush();
}
