const std = @import("std");

fn divid(a: f32, b: f32) !f32 {
    if (b == 0) return error.DivisionByZero;
    return a / b;
}

fn safeDivide() !f32 {
    return try divid(10, 0);
}

fn printValue(value: anytype) void {
    std.debug.print("value = {}\n", .{value});
}

test "divid" {
    var result = divid(10, 2) catch |err| {
        std.debug.print("err: {}\n", .{err});
        return;
    };

    std.debug.print("res: {}\n", .{result});

    result = safeDivide() catch |err| {
        printValue(err);
        return;
    };

    std.debug.print("safeDivide : {}\n", .{result});
}

fn sliceReverse(comptime T: type, slice: []T) void {
    var l: usize = 0;
    var r: usize = slice.len - 1;

    while (l < r) {
        const tmp = slice[l];
        slice[l] = slice[r];
        slice[r] = tmp;
        l += 1;
        r -= 1;
    }
}

test "sliceReverse" {
    var arr = [5]i32{ 1, 3, 5, 7, 9 };
    sliceReverse(i32, arr[0..]);
    for (arr) |value| {
        std.debug.print("{} ", .{value});
    }

    std.debug.print("\n", .{});

    var arr2 = [5]f64{ 1.0, 3.0, 5.0, 7.0, 9.0 };
    sliceReverse(f64, arr2[0..]);
    for (arr2) |value| {
        std.debug.print("{} ", .{value});
    }
    std.debug.print("\n", .{});
}
