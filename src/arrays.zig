const std = @import("std");
const expect = @import("std").testing.expect;
const expectEqual = @import("std").testing.expectEqual;
const assert = @import("std").debug.assert;
const mem = @import("std").mem;

const message = [_]u8{ 'h', 'e', 'l', 'l', 'o' };

const alt_message: [5]u8 = .{ 'h', 'e', 'l', 'l', 'o' };

comptime {
    assert(mem.eql(u8, &alt_message, &message));
}

const same_message = "hello";

comptime {
    assert(mem.eql(u8, &message, same_message));
}

test "iterate over an array" {
    var sum: usize = 0;
    for (message) |bytes| {
        sum += bytes;
    }
    try expect(sum == 'h' + 'e' + 'l' * 2 + 'o');
}

var some_integers: [100]i32 = undefined;

test "modify an array" {
    for (&some_integers, 0..) |*item, i| {
        item.* = @intCast(i);
    }
    try expect(some_integers[10] == 10);
    try expect(some_integers[99] == 99);
}

const part_one = [_]i32{ 1, 2, 3, 4 };
const part_two = [_]i32{ 5, 6, 7, 8 };
const all_of_it = part_one ++ part_two;
comptime {
    assert(mem.eql(i32, &all_of_it, &[_]i32{ 1, 2, 3, 4, 5, 6, 7, 8 }));
}

const hello = "hello";
const world = "world";
const hello_world = hello ++ " " ++ world;
comptime {
    assert(mem.eql(u8, hello_world, "hello world"));
}

const patten = "ab" ** 3;
comptime {
    assert(mem.eql(u8, patten, "ababab"));
}

const all_zero = [_]u16{0} ** 10;
comptime {
    assert(all_zero.len == 10);
    assert(all_zero[5] == 0);
}

const Point = struct {
    x: i32,
    y: i32,
};

var fancy_array = init: {
    var initial_value: [10]Point = undefined;
    for (&initial_value, 0..) |*pt, i| {
        pt.* = Point{
            .x = @intCast(i),
            .y = @intCast(i * 2),
        };
    }
    break :init initial_value;
};

test "compile-time array initialization" {
    try expect(fancy_array[4].x == 4);
    try expect(fancy_array[4].y == 8);
}

fn makePoint(x: i32) Point {
    return Point{
        .x = x,
        .y = x * 2,
    };
}

var more_points = [_]Point{makePoint(3)} ** 10;
test "array initialization with function calls" {
    try expect(more_points[4].x == 3);
    try expect(more_points[4].y == 6);
    try expect(more_points.len == 10);
}

const mat4x5 = [4][5]f32{
    [_]f32{ 1.0, 0.0, 0.0, 0.0, 0.0 },
    [_]f32{ 0.0, 1.0, 0.0, 1.0, 0.0 },
    [_]f32{ 0.0, 0.0, 1.0, 0.0, 0.0 },
    [_]f32{ 0.0, 0.0, 0.0, 1.0, 9.9 },
};

test "multidimensional arrays" {
    try expectEqual(mat4x5[1], [_]f32{ 0.0, 1.0, 0.0, 1.0, 0.0 });

    try expect(mat4x5[3][4] == 9.9);

    for (mat4x5, 0..) |row, row_index| {
        for (row, 0..) |cell, colum_index| {
            if (row_index == colum_index) {
                try expect(cell == 1.0);
            }
        }
    }

    const all_size: [4][5]f32 = .{.{0} ** 5} ** 4;
    try expect(all_size[0][0] == 0);
}

test "0-terminated sentinel array" {
    const array = [_:0]u8{ 1, 2, 3, 4 };

    try expect(@TypeOf(array) == [4:0]u8);
    try expect(array.len == 4);
    try expect(array[4] == 0);
}

fn swizzleRgbaToBgra(rgba: [4]u8) [4]u8 {
    const r, const g, const b, const a = rgba;
    return .{ b, g, r, a };
}

test "a" {
    const pos = [_]i32{ 1, 2 };
    const x, const y = pos;
    std.debug.print("x = {}, y = {}\n", .{ x, y });

    const orange: [4]u8 = .{ 255, 165, 0, 255 };
    std.debug.print("{any}\n", .{swizzleRgbaToBgra(orange)});
}
