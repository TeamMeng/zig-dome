const std = @import("std");
const Allocator = std.mem.Allocator;

test "cli_allocation" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const ptr = try allocator.create(i32);
    ptr.* = 123;
    std.debug.print("ptr: {d}\n", .{ptr.*});
}

test "using an allocator" {
    var buffer: [100]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    const result = try concat(allocator, "foo", "bar");
    try std.testing.expectEqualStrings("foobar", result);
}

fn concat(allocator: Allocator, a: []const u8, b: []const u8) ![]u8 {
    const result = try allocator.alloc(u8, a.len + b.len);
    @memcpy(result[0..a.len], a);
    @memcpy(result[a.len..], b);
    return result;
}

fn createNumbers(allocator: std.mem.Allocator) ![]u32 {
    const number = try allocator.alloc(u32, 3);

    number[0] = 10;
    number[1] = 20;
    number[2] = 30;

    return number;
}

fn calculateSum(numbers: []const u32) u32 {
    var sum: u32 = 0;

    for (numbers) |value| {
        sum += value;
    }

    return sum;
}

test "allocator array" {
    const allocator = std.testing.allocator;

    const numbers = try createNumbers(allocator);
    defer allocator.free(numbers);

    const sum = calculateSum(numbers);

    std.debug.print("{d}\n", .{sum});

    const ptr = try allocator.create(u32);
    defer allocator.destroy(ptr);

    ptr.* = 100;
    std.debug.print("{d}\n", .{ptr.*});
}
