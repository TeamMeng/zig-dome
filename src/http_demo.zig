const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const address = try std.Io.net.IpAddress.parseIp4("127.0.0.1", 8080);

    var listener = try address.listen(init.io, .{ .reuse_address = true });
    defer listener.deinit(init.io);

    std.debug.print("Server listening on http://127.0.0.1:8080\n", .{});

    while (true) {
        const connection = listener.accept(init.io) catch |err| {
            std.debug.print("Accept error: {}\n", .{err});
            continue;
        };
        defer connection.close(init.io);

        handleRequest(init.io, connection) catch |err| {
            std.debug.print("Request error: {}\n", .{err});
        };
    }
}

fn handleRequest(io: std.Io, stream: std.Io.net.Stream) !void {
    var recv_buffer: [4096]u8 = undefined;
    var send_buffer: [4096]u8 = undefined;

    var reader = stream.reader(io, &recv_buffer);
    var writer = stream.writer(io, &send_buffer);
    var server = std.http.Server.init(&reader.interface, &writer.interface);

    var request = try server.receiveHead();
    try request.respond("Hello World\n", .{ .extra_headers = &.{
        .{ .name = "content-type", .value = "text/plain" },
    } });
}
