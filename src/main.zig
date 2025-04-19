const std = @import("std");

pub fn main() !void {
    var interger: i16 = 666;
    const ptr = &interger;
    ptr.* = ptr.* + 1;

    // 667
    std.debug.print("{}\n", .{interger});

    const array = [_]i32{ 1, 2, 3, 4 };
    const arr_ptr: [*]const i32 = &array;
    // 1
    std.debug.print("The first value is {}\n", .{arr_ptr[0]});

    var p_array: [5]u8 = "Hello".*;

    const array_pointer = &p_array;
    try std.testing.expect(array_pointer.len == 5);

    const slice: []u8 = p_array[1..3];
    try std.testing.expect(slice.len == 2);
}
