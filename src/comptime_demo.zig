const std = @import("std");

fn max(comptime T: type, a: T, b: T) T {
    return if (a > b) a else b;
}

test "max" {
    const x = max(i32, 1, 2);
    std.debug.print("x = {}\n", .{x});
}

test "comptime" {
    comptime {
        @setEvalBranchQuota(1_000_000_000);
    }

    const result = heavyComptimeComputation();

    std.debug.print("result: {}\n", .{result});
}

fn heavyComptimeComputation() u64 {
    var sum: u64 = 0;
    var i: u64 = 0;
    while (i < 1_000_000_000) : (i += 1) {
        sum += i * 3 + 7;
    }

    return sum;
}

fn factorial(comptime n: u32) u64 {
    if (n == 0) return 1;
    return n * factorial(n - 1);
}

fn makeArray(comptime T: type, comptime len: usize, value: T) [len]T {
    var result: [len]T = undefined;
    for (&result) |*item| {
        item.* = value;
    }
    return result;
}

test "factorial_and_makeArray" {
    const result = comptime factorial(10);

    std.debug.print("10! = {d}\n", .{result});

    const arr = makeArray(i32, 5, 42);

    std.debug.print("array: {any}\n", .{arr});
}
