const std = @import("std");

test "simple array" {
    var scores = [_]u32{ 80, 90, 95 };

    std.debug.print("scores = {any}\n", .{scores});

    scores[0] = 100;

    std.debug.print("{d}\n", .{scores[0]});

    var total: u32 = 0;
    for (scores) |score| {
        std.debug.print("scors: {d}\n", .{score});
        total += score;
    }

    const average = total / scores.len;
    std.debug.print("total: {d}, average: {d}\n", .{ total, average });
}
