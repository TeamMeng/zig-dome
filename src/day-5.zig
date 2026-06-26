const std = @import("std");

test "if" {
    const age: u8 = 25;
    const status = if (age < 18) "未成年" else "成年";

    std.debug.print("you are {s}\n", .{status});

    const level = if (age < 13) "儿童" else if (age < 18) "青少年" else "成年";
    std.debug.print("level: {s}\n", .{level});
}

test "switch" {
    const grade: u8 = 85;
    const result = switch (grade / 10) {
        9...10 => "优秀",
        8 => "良好",
        6...7 => "及格",
        0...5 => "不及格",
        else => unreachable,
    };
    std.debug.print("score level: {s}\n", .{result});
}

test "while" {
    const arr = [_]u32{ 1, 3, 5, 7, 9 };
    const target: u32 = 5;

    const found = blk: {
        var i: usize = 0;
        while (i < arr.len) : (i += 1) {
            if (arr[i] == target) break :blk true;
        }
        break :blk false;
    };

    try std.testing.expectEqual(found, true);
}

test "for" {
    const arr = [_]u8{ 'Z', 'i', 'g' };

    for (arr, 0..) |char, index| {
        std.debug.print("{c} at {d}\n", .{ char, index });
    }
}

test "work" {
    const arr = [_]u32{ 1, 5, 7, 8, 9 };

    const found: ?u32 = blk: {
        var i: usize = 0;
        while (i < arr.len) : (i += 1) {
            if (arr[i] % 2 == 0) break :blk arr[i];
        }
        break :blk null;
    };

    if (found) |value| {
        std.debug.print("value: {}\n", .{value});
    }
}
