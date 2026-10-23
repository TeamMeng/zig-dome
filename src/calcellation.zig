const std = @import("std");

test "calcellation" {
    const io = std.testing.io;

    std.debug.print("start work\n", .{});

    var task = io.async(work, .{io});
    defer _ = task.cancel(io) catch {};

    try io.sleep(.fromMilliseconds(100), .awake);

    std.debug.print("asking...\n", .{});

    task.cancel(io) catch |err| {
        if (err == error.Canceled) {
            std.debug.print("is cancel\n", .{});
            return;
        }

        return err;
    };

    std.debug.print("finished\n", .{});
}

fn work(io: std.Io) !void {
    std.debug.print("task working...\n", .{});

    try io.sleep(.fromSeconds(30), .awake);

    std.debug.print("task finished\n", .{});
}
