const std = @import("std");

const Point = struct { x: f32, y: f32 };

const p: Point = .{ .x = 0.12, .y = 0.34 };

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{
            .x = x,
            .y = y,
            .z = z,
        };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }
};

test "dot product" {
    const v1 = Vec3.init(1.0, 0.0, 0.0);
    const v2 = Vec3.init(0.0, 1.0, 0.0);

    try std.testing.expectEqual(0.0, Vec3.dot(v1, v2));
}

const Empty = struct {
    pub const PI = 3.14;
};

test "struct namespaced variable" {
    try std.testing.expectEqual(3.14, Empty.PI);
    try std.testing.expectEqual(0, @sizeOf(Empty));

    const dose_nothing: Empty = .{};

    _ = dose_nothing;
}

fn setYBasedOnX(x: *f32, y: f32) void {
    const point: *Point = @fieldParentPtr("x", x);
    point.y = y;
}

test "field parent pointer" {
    var point = Point{
        .x = 0.1234,
        .y = 0.5678,
    };
    setYBasedOnX(&point.x, 0.9);
    try std.testing.expectEqual(0.9, point.y);
}

fn LinkedList(comptime T: type) type {
    return struct {
        pub const Node = struct {
            prev: ?*Node,
            next: ?*Node,
            data: T,
        };

        first: ?*Node,
        last: ?*Node,
        len: usize,
    };
}

test "linked list" {
    try std.testing.expectEqual(LinkedList(i32), LinkedList(i32));

    const list = LinkedList(i32){
        .first = null,
        .last = null,
        .len = 0,
    };
    try std.testing.expectEqual(0, list.len);

    const ListOfInts = LinkedList(i32);
    try std.testing.expectEqual(ListOfInts, LinkedList(i32));

    var node = ListOfInts.Node{
        .prev = null,
        .next = null,
        .data = 1234,
    };
    const list2 = LinkedList(i32){
        .first = &node,
        .last = &node,
        .len = 1,
    };
    try std.testing.expectEqual(1234, list2.first.?.data);
}

const Foo = struct {
    a: i32 = 1234,
    b: i32,
};

test "default struct initialization fields" {
    const x: Foo = .{
        .b = 5,
    };
    if (x.a + x.b != 1239) {
        comptime unreachable;
    }
}

const Threshold = struct {
    minimum: f32 = 0.25,
    maximum: f32 = 0.75,
    const Category = enum { low, medium, high };

    fn category(self: Threshold, value: f32) Category {
        std.debug.assert(self.maximum >= self.minimum);
        if (value < self.minimum) {
            return .low;
        }
        if (value > self.maximum) {
            return .high;
        }

        return .medium;
    }
};

test "threshold and category" {
    var threshold = Threshold{};
    const category = threshold.category(0.90);
    try std.testing.expectEqual(Threshold.Category.high, category);
}
