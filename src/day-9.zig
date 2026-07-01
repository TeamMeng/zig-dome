const std = @import("std");

const c = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
});

const stdio = @cImport(@cInclude("stdio.h"));

pub fn main() void {
    _ = c.printf("Hello from C: %d\n", @as(c_int, 42));

    const ptr = c.malloc(100) orelse return;

    const bytes: [*]u8 = @ptrCast(ptr);
    bytes[0] = 42;
    bytes[99] = 100;

    _ = stdio.printf("ptr value: %d - %d\n", bytes[0], bytes[99]);
    defer c.free(ptr);
}
