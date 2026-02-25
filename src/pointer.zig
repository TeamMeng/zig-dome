const std = @import("std");
const expect = @import("std").testing.expect;

test "address of syntax" {
    const x: i32 = 1234;
    const x_ptr = &x;

    try expect(x_ptr.* == 1234);
    try expect(@TypeOf(x_ptr) == *const i32);

    var y: i32 = 5678;
    const y_ptr = &y;
    try expect(@TypeOf(y_ptr) == *i32);
    y_ptr.* += 1;
    try expect(y_ptr.* == 5679);
}

test "pointer array access" {
    var array = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const ptr = &array[2];
    try expect(@TypeOf(ptr) == *u8);

    try expect(array[2] == 3);
    ptr.* += 1;
    try expect(array[2] == 4);
}

test "slice syntax" {
    var x: i32 = 1234;
    const x_ptr = &x;

    const x_array_ptr = x_ptr[0..1];
    try expect(@TypeOf(x_array_ptr) == *[1]i32);

    const x_many_ptr: [*]i32 = x_array_ptr;
    try expect(x_many_ptr[0] == 1234);
}

test "test_slice_bounds" {
    var array = [_]u8{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    var start: usize = 2;
    _ = &start;
    const slice = array[start..4];
    try expect(slice.len == 2);

    try expect(array[3] == 4);
    slice[1] += 1;
    try expect(array[3] == 5);
}

test "comptime pointers" {
    comptime {
        var x: i32 = 1;
        const ptr = &x;
        ptr.* += 1;
        x += 1;
        try expect(ptr.* == 3);
    }
}

test "@intFromPtr and @ptrFromInt" {
    const ptr: *i32 = @ptrFromInt(0xdeadbee0);
    const addr = @intFromPtr(ptr);
    try expect(@TypeOf(addr) == usize);
    try expect(addr == 0xdeadbee0);
}

test "pointer casting" {
    const bytes align(@alignOf(u32)) = [_]u8{ 0x12, 0x12, 0x12, 0x12 };
    const u32_ptr: *const u32 = @ptrCast(&bytes);
    try expect(u32_ptr.* == 0x12121212);

    const u32_value = std.mem.bytesAsSlice(u32, bytes[0..])[0];
    try expect(u32_value == 0x12121212);

    try expect(@as(u32, @bitCast(bytes)) == 0x12121212);
}

test "pointer child type" {
    try expect(@typeInfo(*u32).pointer.child == u32);
}
