const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const source_tasks = [_][]const u8{
        "学习 Zig 基础语法",
        "理解 Slice 的生命周期",
        "练习 ArenaAllocator",
    };

    var tasks: [3][]const u8 = undefined;

    for (source_tasks, 0..) |task, i| {
        tasks[i] = try allocator.dupe(u8, task);
    }

    std.debug.print("今日学习任务：\n", .{});

    for (tasks, 0..) |task, i| {
        std.debug.print("{d}. {s}\n", .{ i + 1, task });
    }

    std.debug.print("所有任务处理完毕。\n", .{});
}
