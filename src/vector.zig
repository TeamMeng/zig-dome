const std = @import("std");
const expectEqual = std.testing.expectEqual;

test "Basic vector usage" {
    const a = @Vector(4, i32){ 1, 2, 3, 4 };
    const b = @Vector(4, i32){ 5, 6, 7, 8 };

    const c = a + b;
    try expectEqual(6, c[0]);
    try expectEqual(8, c[1]);
    try expectEqual(10, c[2]);
    try expectEqual(12, c[3]);
}

test "Conversion between vectors, arrays, and slices" {
    const arr1: [4]f32 = [_]f32{ 1.0, 2.0, 3.0, 4.0 };
    const vec: @Vector(4, f32) = arr1;
    const arr2: [4]f32 = vec;
    try expectEqual(arr1, arr2);

    const vec2: @Vector(2, f32) = arr1[1..3].*;

    const slice: []const f32 = &arr1;
    const offset: u32 = 1;
    _ = &offset;

    const vec3: @Vector(2, f32) = slice[offset..][0..2].*;
    try expectEqual(slice[offset], vec2[0]);
    try expectEqual(slice[offset + 1], vec2[1]);
    try expectEqual(vec2, vec3);
}

fn unpack(x: @Vector(4, f32), y: @Vector(4, f32)) @Vector(4, f32) {
    const a, const c, _, _ = x;
    const b, const d, _, _ = y;

    return .{ a, b, c, d };
}

test "destructuring_vectors" {
    const x: @Vector(4, f32) = .{ 1.0, 2.0, 3.0, 4.0 };
    const y: @Vector(4, f32) = .{ 5.0, 6.0, 7.0, 8.0 };

    const z = unpack(x, y);
    try expectEqual(z[0], x[0]);
    try expectEqual(z[1], y[0]);
    try expectEqual(z[2], x[1]);
    try expectEqual(z[3], y[1]);
}
