const std = @import("std");
const mcp = @import("mcp");

pub fn main(init: std.process.Init) void {
    run(init.io, init.gpa) catch |err| {
        mcp.reportError(err);
    };
}

fn run(io: std.Io, allocator: std.mem.Allocator) !void {
    // Check for library updates in background (recommended)
    if (mcp.report.checkForUpdates(io, allocator)) |t| t.detach();

    // Create a server
    var server: mcp.Server = .init(allocator, .{
        .name = "hello-server",
        .version = "1.0.0",
    });
    defer server.deinit();

    // Add a simple tool
    try server.addTool(.{
        .name = "hello",
        .description = "Says hello to someone",
        .handler = helloHandler,
    });

    // Run the server (blocks until shutdown)
    try server.run(io, allocator, .stdio);
}

fn helloHandler(
    _: ?*anyopaque,
    _: std.Io,
    allocator: std.mem.Allocator,
    args: ?std.json.Value,
) mcp.tools.ToolError!mcp.tools.ToolResult {
    const name = mcp.tools.getString(args, "name") orelse "World";

    const message = try std.fmt.allocPrint(allocator, "Hello, {s}!", .{name});

    return mcp.tools.textResult(allocator, message);
}
