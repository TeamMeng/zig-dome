const std = @import("std");

const http_demo = @import("http_demo.zig");

pub fn main(init: std.process.Init) !void {
    try http_demo.main(init);
}

test "while" {
    var idx: i32 = 0;
    var i: i32 = 0;
    while (idx < 100) : (idx += 1) {
        i += idx;
    }
    std.debug.print("i: {}\n", .{i});
}

test "for" {
    var i: i32 = 0;
    for (0..100) |val| {
        i += @intCast(val);
    }
    std.debug.print("i: {}\n", .{i});
}

test "const" {
    const pi: f32 = 3.14159;
    const message = "Hello, zig!";

    std.debug.print("Pi: {d:.5}, message: {s}\n", .{ pi, message });
}

test "var" {
    var count: i32 = 0;
    var score: i32 = 100;

    count += 100;
    score = 95;
    std.debug.print("count: {}, score: {}\n", .{ count, score });
}

test "my_age_and_name" {
    const name = "Meng";
    var age: u8 = 23;

    age += 1;
    std.debug.print("name: {s}, next year age: {d}\n", .{ name, age });
}
