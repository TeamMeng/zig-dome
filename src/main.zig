const std = @import("std");

const http_demo = @import("http_demo.zig");
const httpz = @import("httpz");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var server = try httpz.Server(void).init(init.io, allocator, .{
        .address = .localhost(8080),
    }, {});
    defer {
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/api/user", getUser, .{});

    try server.listen();
}

fn getUser(req: *httpz.Request, res: *httpz.Response) !void {
    _ = req;
    res.status = 200;
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
