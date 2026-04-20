const std = @import("std");

test "cli_allocation" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const ptr = try allocator.create(i32);
    ptr.* = 123;
    std.debug.print("ptr: {d}\n", .{ptr.*});
}
