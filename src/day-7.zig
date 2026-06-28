const std = @import("std");

test "point" {
    var x: u32 = 42;

    // const many_ptr: [*]u32 = &x;

    const single_ptr: *u32 = &x;

    // const opt_ptr: ?*u32 = &x;
    //
    // const c_str: [*c]const u8 = "hello zig";

    std.debug.print("x = {}, through ptr = {d}\n", .{ x, single_ptr.* });

    single_ptr.* += 1;
    std.debug.print("now x = {}\n", .{x});
}

test "array" {
    const arr = [5]u32{ 1, 2, 3, 4, 5 };

    std.debug.print("arr[0] = {}, len = {}\n", .{ arr[0], arr.len });

    var copy = arr;
    copy[0] = 999;
    std.debug.print("original arr[0] = {}\n", .{arr[0]});

    const matrix = [2][3]i32{ .{ 1, 2, 3 }, .{ 4, 5, 6 } };
    for (matrix, 0..) |vec, i| {
        for (vec, 0..) |value, j| {
            std.debug.print("{}-{}:{} ", .{ i, j, value });
        }
        std.debug.print("\n", .{});
    }
}

test "slice" {
    var array = [_]u32{ 1, 2, 3, 4, 5 };

    const slice: []u32 = array[0..];

    std.debug.print("slice len = {}, ptr = {*}\n", .{ slice.len, slice.ptr });

    slice[0] = 999;
    std.debug.print("array[0] now = {}\n", .{array[0]});
}

fn greet(name: []const u8) void {
    std.debug.print("Hello, {s}\n", .{name});
}

test "str" {
    const hello = "Zig is awesome";

    greet(hello);

    greet(hello[0..3]);
}

fn reverseSlice(slice: []u8) void {
    var l: usize = 0;
    var r: usize = slice.len - 1;
    while (l < r) {
        const c: u8 = slice[l];
        slice[l] = slice[r];
        slice[r] = c;
        l += 1;
        r -= 1;
    }
}

test "reverseSlice" {
    var s = "giZ olleH".*;
    const slice = s[0..];

    reverseSlice(slice);
    std.debug.print("{s}\n", .{slice});
}

fn sum(arr: []const i32) i32 {
    var total: i32 = 0;
    for (arr) |value| {
        total += value;
    }
    return total;
}

test "sum" {
    const arr = [_]i32{ 1, 2, 3 };
    std.debug.print("sum: {}\n", .{sum(&arr)});
}
