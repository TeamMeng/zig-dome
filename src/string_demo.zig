const std = @import("std");

fn greet(name: []const u8) void {
    std.debug.print("{s}\n", .{name});
}

test "string" {
    const message: []const u8 = "Hello, Zig!";

    std.debug.print("{s}\n", .{message});

    var buffer = [_]u8{ 'H', 'e', 'l', 'l', 'o' };

    var text = &buffer;

    text[0] = 'h';

    std.debug.print("{s}, len: {d}\n", .{ buffer, buffer.len });

    for (buffer) |byte| {
        std.debug.print("{c} ", .{byte});
    }
    std.debug.print("\n", .{});

    greet(&buffer);
}

test "same" {
    const name1 = "Zig";
    const name2 = "Zig";

    const same = std.mem.eql(u8, name1, name2);
    std.debug.print("{}\n", .{same});
}
