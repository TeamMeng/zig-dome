const std = @import("std");

test "*const [N]T to []const T" {
    const x1: []const u8 = "hello";
    const x2: []const u8 = &[5]u8{ 'h', 'e', 'l', 'l', 'o' };
    try std.testing.expectEqualStrings(x1, x2);

    const y: []const f32 = &[2]f32{ 1.2, 3.4 };
    try std.testing.expectEqual(1.2, y[0]);
}

test "*const [N]T to E![]const T" {
    const x1: anyerror![]const u8 = "hello";
    const x2: anyerror![]const u8 = &[5]u8{ 'h', 'e', 'l', 'l', 111 };

    try std.testing.expectEqualStrings(try x1, try x2);

    const y: anyerror![]const f32 = &[2]f32{ 1.2, 3.4 };
    try std.testing.expectEqual(1.2, (try y)[0]);
}
