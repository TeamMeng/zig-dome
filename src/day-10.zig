const std = @import("std");

test "arrayList" {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var list: std.ArrayList(u8) = .empty;
    defer list.deinit(allocator);

    try list.append(allocator, 1);
    try list.appendSlice(allocator, &[_]u8{ 2, 3, 4 });
    try list.insert(allocator, 0, 0);

    for (list.items, 0..) |item, i| {
        std.debug.print("index {}: {}\n", .{ i, item });
    }

    const owned = try list.toOwnedSlice(allocator);
    defer allocator.free(owned);

    try std.testing.expectEqualSlices(u8, &[_]u8{ 0, 1, 2, 3, 4 }, owned);
}

test "hashMap" {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var map = std.AutoHashMap(u32, []const u8).init(allocator);
    defer map.deinit();

    try map.put(1, "one");
    try map.put(2, "two");

    if (map.get(1)) |value| {
        std.debug.print("find: {s}\n", .{value});
    }

    try map.putNoClobber(3, "three");

    var it = map.iterator();
    while (it.next()) |entry| {
        std.debug.print("{} => {s}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}

test "mem" {
    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var buffer: [5]u8 = undefined;
    const slice = buffer[0..];

    @memcpy(slice, "hello");

    if (std.mem.eql(u8, slice, "hello")) {
        std.debug.print("mem eql\n", .{});
    }

    const ptr = try std.mem.Allocator.dupe(allocator, u8, "duplicate");
    std.debug.print("{s}\n", .{ptr});

    defer allocator.free(ptr);
}

// test "io" {
//     var buffer: [1024]u8 = undefined;
//
//     var stdin = std.Io.File.stdin().reader(std.testing.io, &buffer);
//     const line = try stdin.interface.takeDelimiterExclusive('\n');
//
//     std.debug.print("{s}\n", .{line});
// }

// test "net" {
//     const io = std.testing.io;
//
//     const address = std.Io.net.IpAddress.parse("127.0.0.1", 8080) catch unreachable;
//     var server = try address.listen(io, .{ .reuse_address = true });
//     defer server.deinit(io);
//
//     while (true) {
//         const stream = try server.accept(io);
//         defer stream.close(io);
//
//         var in_buf: [1024]u8 = undefined;
//         var reader = stream.reader(io, &in_buf);
//         _ = reader.interface.takeDelimiterExclusive('\n') catch {};
//
//         var out_buf: [1024]u8 = undefined;
//         var writer = stream.writer(io, &out_buf);
//         try writer.interface.writeAll("HTTP/1.1 200 OK\r\nContent-Length: 15\r\nConnection: close\r\n\r\nHello from Zig!");
//         try writer.interface.flush();
//     }
// }
