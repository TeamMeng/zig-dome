const std = @import("std");

pub fn main() !void {}

test "while" {
    var idx: i32 = 0;
    var i: i32 = 0;
    while (idx < 100) : (idx += 1) {
        i += idx;
    }
    std.debug.print("i: {}\n", .{i});
}

test "for" {
    var i: i32 = 0;
    for (0..100) |val| {
        i += @intCast(val);
    }
    std.debug.print("i: {}\n", .{i});
}
