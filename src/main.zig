const std = @import("std");
const httpz = @import("httpz");
const pg = @import("pg");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var db = try pg.Pool.init(init.io, allocator, .{ .connect = .{ .port = 5432, .host = "localhost" }, .auth = .{
        .username = "postgres",
        .database = "db",
    } });
    defer db.deinit();

    var app = App{
        .db = db,
    };

    var server = try httpz.Server(*App).init(init.io, allocator, .{
        .address = .localhost(8080),
    }, &app);
    defer {
        server.stop();
        server.deinit();
    }

    var router = try server.router(.{});
    router.get("/api/user/:id", getUser, .{});

    try server.listen();
}

const App = struct {
    db: *pg.Pool,
};

fn getUser(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    const user_id = req.param("id").?;

    var row = try app.db.row("select name from \"user\" where id = $1", .{user_id}) orelse {
        res.status = 404;
        res.body = "Not Found";
        return;
    };
    defer row.deinit() catch {};

    try res.json(.{
        .id = user_id,
        .name = try row.get([]u8, 0),
    }, .{});
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
