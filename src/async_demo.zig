const std = @import("std");

test "future" {
    const io = std.testing.io;

    var future = io.async(add, .{ 1, 2 });

    const result = future.await(io);

    std.debug.print("result: {d}\n", .{result});
}

fn add(a: u32, b: u32) u32 {
    return a + b;
}

test "group" {
    const io = std.testing.io;

    const inputs = [_]u32{ 10, 20, 30 };
    const delays = [_]u64{ 300, 100, 200 };

    var results: [3]u32 = undefined;

    var group: std.Io.Group = .init;
    defer group.cancel(io);

    for (inputs, 0..) |input, index| {
        group.async(io, calculate, .{
            io,
            &results[index],
            input,
            delays[index],
        });
    }

    try group.await(io);

    for (results, 0..) |result, index| {
        std.debug.print(
            "task {} result {}\n",
            .{ index, result },
        );
    }
}

fn calculate(io: std.Io, result: *u32, value: u32, delay_ms: u64) !void {
    try io.sleep(
        .fromNanoseconds(delay_ms),
        .awake,
    );

    result.* = value * 2;
}
