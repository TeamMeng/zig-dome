const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    std.debug.print("all {d} args\n", .{args.len});

    for (args, 0..) |arg, index| {
        std.debug.print("arg {d}: {s}\n", .{ index, arg });
    }
}
