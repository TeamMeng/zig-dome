const std = @import("std");

fn printNumbers(numbers: []const i32) void {
    for (numbers) |number| {
        std.debug.print("{} ", .{number});
    }
    std.debug.print("\n", .{});
}

fn sum(numbers: []const i32) i32 {
    var result: i32 = 0;

    for (numbers) |number| {
        result += number;
    }

    return result;
}

fn greet(name: []const u8) void {
    std.debug.print("Hello, {s}\n", .{name});
}

fn changeNumber(numbers: []i32) void {
    for (numbers) |*number| {
        number.* = 1;
    }
}

test "slice print" {
    const numbers1 = [_]i32{ 10, 20, 30 };
    printNumbers(&numbers1);

    var numbers2 = [_]i32{ 10, 20, 30, 40, 50 };
    printNumbers(&numbers2);

    const part = numbers2[1..4];

    for (part) |number| {
        std.debug.print("{} ", .{number});
    }
    std.debug.print(" len: {}\n", .{part.len});

    std.debug.print("numbers1 total: {}\n", .{sum(&numbers1)});
    std.debug.print("numbers2 total: {}\n", .{sum(&numbers2)});

    greet("Zig");

    changeNumber(&numbers2);
    printNumbers(&numbers2);
}
