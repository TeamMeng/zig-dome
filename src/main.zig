const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var input_buffer: [1024]u8 = undefined;
    var output_buffer: [1024]u8 = undefined;

    var stdin_reader = std.Io.File.stdin().reader(io, &input_buffer);
    var stdout_writer = std.Io.File.stdout().writer(io, &output_buffer);

    const reader = &stdin_reader.interface;
    const writer = &stdout_writer.interface;

    try writer.writeAll("请输入第一个整数:");
    try writer.flush();

    const first_line = try reader.takeDelimiter('\n') orelse {
        try writer.writeAll("没有读取到第一个整数.\n");
        try writer.flush();
        return;
    };

    const first_text = std.mem.trim(u8, first_line, "\r");

    const first_number = std.fmt.parseInt(i64, first_text, 10) catch {
        try writer.writeAll("第一个输入不是有效的整数。\n");
        try writer.flush();
        return;
    };

    try writer.writeAll("请输入第二个整数:");
    try writer.flush();

    const second_line = try reader.takeDelimiter('\n') orelse {
        try writer.writeAll("没有读取到第一个整数.\n");
        try writer.flush();
        return;
    };

    const second_text = std.mem.trim(u8, second_line, "\r");

    const second_number = std.fmt.parseInt(i64, second_text, 10) catch {
        try writer.writeAll("第二个输入不是有效的整数。\n");
        try writer.flush();
        return;
    };

    const result = first_number + second_number;

    try writer.print("result: {d}\n", .{result});
    try writer.flush();
}
