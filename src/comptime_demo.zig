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
