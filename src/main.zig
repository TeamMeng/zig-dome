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

const RequestContext = struct {
    app: *App,
};

const App = struct {
    io: std.Io,
    db: *pg.Pool,

    fn getUser(self: *App, req: *httpz.Request) !User {
        const user_id = req.param("id").?;

        var row = try self.db.row(
            "select name from \"user\" where id = $1",
            .{user_id},
        ) orelse {
            return error.NotFound;
        };
        defer row.deinit() catch {};

        const name = try row.get([]u8, 0);
        return User{
            .id = user_id,
            .name = name,
        };
    }

    pub fn notFound(_: *App, req: *httpz.Request, res: *httpz.Response) !void {
        std.log.info("404 {} {s}", .{ req.method, req.url.path });
        res.status = 404;
        res.body = "Not Found";
    }

    pub fn dispatch(
        self: *App,
        action: httpz.Action(*RequestContext),
        req: *httpz.Request,
        res: *httpz.Response,
    ) !void {
        var start = std.Io.Timestamp.now(self.io, .awake);

        defer {
            const elapsed_us = start
                .untilNow(self.io, .awake)
                .toMicroseconds();

            std.log.info("{} {s} {d}us", .{
                req.method,
                req.url.path,
                elapsed_us,
            });
        }

        var ctx = RequestContext{ .app = self };

        try action(&ctx, req, res);
    }
};

fn getUser(ctx: *RequestContext, req: *httpz.Request, res: *httpz.Response) !void {
    const user = try ctx.app.getUser(req);

    try res.json(.{user}, .{});
}
