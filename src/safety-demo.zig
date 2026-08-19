const std = @import("std");

test "safety" {
    var a: u8 = 250;
    const b: u8 = 10;

    // a += b; overflow
    a += 1;

    _ = b;

    std.debug.print("result: {d}\n", .{a});
}
