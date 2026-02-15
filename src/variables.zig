const std = @import("std");
const expect = std.testing.expect;
const assert = std.debug.assert;

const x: i32 = add(12, 24);
var y: i32 = add(10, x);

threadlocal var t: i32 = 1234;

const S = struct {
    var x: i32 = 1234;
};

fn foo() i32 {
    S.x += 1;
    return S.x;
}

fn add(a: i32, b: i32) i32 {
    return a + b;
}

fn testTls() void {
    assert(t == 1234);
    t += 1;
    assert(t == 1235);
}

test "test_container_level_variables" {
    try expect(x == 36);
    try expect(y == 46);
}

test "test_namespaced_container_level_variable" {
    try expect(foo() == 1235);
    try expect(foo() == 1236);
}

test "thread local storage" {
    const thread1 = try std.Thread.spawn(.{}, testTls, .{});
    const thread2 = try std.Thread.spawn(.{}, testTls, .{});
    testTls();
    thread1.join();
    thread2.join();
}

test "comptime vars" {
    var a: i32 = 1;
    comptime var b: i32 = 1;

    a += 1;
    b += 1;

    try expect(a == 2);
    try expect(b == 2);

    if (b != 2) {
        @compileError("wrong y value");
    }
}
