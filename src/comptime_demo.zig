const std = @import("std");

fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

test "max" {
    const x = max(i32, 1, 2);
    std.debug.print("x = {}\n", .{x});
}
