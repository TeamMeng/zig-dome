const std = @import("std");

const file_name = "hello.txt";

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;

    try writeFile(io);

    const contents = try readFile(io, allocator);
    defer allocator.free(contents);

    std.debug.print("{s}", .{contents});
}

fn writeFile(io: std.Io) !void {
    const file = try std.Io.Dir.cwd().createFile(
        io,
        file_name,
        .{},
    );
    defer file.close(io);

    try file.writeStreamingAll(io, "Hello, Zig\n");
    try file.writeStreamingAll(io, "This is my first file\n");
}

fn readFile(io: std.Io, allocator: std.mem.Allocator) ![]u8 {
    return try std.Io.Dir.cwd().readFileAlloc(
        io,
        file_name,
        allocator,
        .limited(1024 * 1024),
    );
}
