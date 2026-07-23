const std = @import("std");
const httpz = @import("httpz");
const pg = @import("pg");

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    var db = try pg.Pool.init(init.io, allocator, .{
        .connect = .{ .port = 5432, .host = "localhost" },
        .auth = .{
            .username = "postgres",
            .database = "db",
        },
    });
    defer db.deinit();

    var app = App{
        .io = init.io,
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

const User = struct {
    id: []const u8,
    name: []const u8,
};

const App = struct {
    io: std.Io,
    db: *pg.Pool,

    fn getUser(self: *App, req: *httpz.Request) !User {
        const user_id = req.param("id").?;

        var row = try self.db.row("select name from \"user\" where id = $1", .{user_id}) orelse {
            return error.NotFound;
        };
        defer row.deinit() catch {};

        const name = try row.get([]u8, 0);
        return User{
            .id = user_id,
            .name = name,
        };
    }

    pub fn dispatch(
        self: *App,
        action: httpz.Action(*App),
        req: *httpz.Request,
        res: *httpz.Response,
    ) !void {
        var start = std.Io.Timestamp.now(self.io, .awake);

        try action(self, req, res);

        const elapsed_us = start
            .untilNow(self.io, .awake)
            .toMicroseconds();

        std.log.info("{} {s} {d}us", .{
            req.method,
            req.url.path,
            elapsed_us,
        });
    }
};

fn getUser(app: *App, req: *httpz.Request, res: *httpz.Response) !void {
    const user = try app.getUser(req);

    try res.json(.{user}, .{});
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
