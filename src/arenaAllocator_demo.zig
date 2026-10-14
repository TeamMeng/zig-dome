const std = @import("std");

test "arena allocator" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const data = try allocator.alloc(u8, 100);

    @memset(data, 0);
}
