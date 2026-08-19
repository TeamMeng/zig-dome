const std = @import("std");

const MyError = error{
    ValueTooSmall,
    ValueTooLarge,
};

fn checkValue(v: i32) MyError!i32 {
    if (v < 0) return MyError.ValueTooSmall;
    if (v > 100) return MyError.ValueTooLarge;
    return v;
}

test "error" {
    const result = try checkValue(42);
    std.debug.print("checked value: {d}\n", .{result});

    const fallback = checkValue(999) catch |err| blk: {
        std.debug.print("caught error: {}\n", .{err});
        break :blk 0;
    };

    std.debug.print("fallback value: {d}\n", .{fallback});
}
