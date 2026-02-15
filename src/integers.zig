const std = @import("std");
const expect = std.testing.expect;

const big = @as(f64, 1 << 40);

export fn foo_strict(x: f64) f64 {
    return x + big - big;
}

export fn foo_optimized(x: f64) f64 {
    @setFloatMode(.optimized);
    return x + big - big;
}

test "float_special_values" {
    const inf = std.math.inf(f32);
    const negative_inf = -std.math.inf(f64);
    const nan = std.math.nan(f128);

    std.debug.print("inf: {d}, negative_inf: {d}, nan: {d}\n", .{ inf, negative_inf, nan });
}

// Strict 模式：保证「运算顺序」和「IEEE 754 标准」的严格一致，代价是性能和 “反直觉结果”；
// Optimized 模式：允许编译器做数学上等价的优化（如结合律、交换律、常量折叠），代价是运算顺序不再严格对应代码顺序
test "float_mode_exe" {
    const x = 0.001;
    std.debug.print("optimized = {}\n", .{foo_optimized(x)});
    std.debug.print("strict = {}\n", .{foo_strict(x)});
}
