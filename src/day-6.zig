const std = @import("std");

fn greet() void {
    std.debug.print("Hello, Zig\n", .{});
}

fn add1(a: u32, b: u32) u32 {
    return a + b;
}

test "fn" {
    greet();
    const sum = add1(10, 20);
    std.debug.print("10 + 10 = {}\n", .{sum});
}

const Vec = struct {
    x: f32,
    y: f32,

    pub fn length(self: Vec) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }

    pub fn add(self: Vec, other: Vec) Vec {
        return Vec{ .x = self.x + other.x, .y = self.y + other.y };
    }
};

test "vec" {
    const v1 = Vec{ .x = 3, .y = 4 };
    const v2 = Vec{ .x = 1, .y = 2 };
    const v3 = v1.add(v2);
    std.debug.print("length = {}\n", .{v3.length()});
}

fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn mul(a: i32, b: i32) i32 {
    return a * b;
}

fn apply(op: fn (i32, i32) i32, x: i32, y: i32) i32 {
    return op(x, y);
}

test "apply" {
    const result1 = apply(add, 5, 6);
    const result2 = apply(mul, 5, 6);
    std.debug.print("apply add: {}, mul:{}\n", .{ result1, result2 });
}
