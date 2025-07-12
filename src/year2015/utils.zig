const std = @import("std");

pub fn parseNumbers(comptime max: usize, input: []const u8) []u32 {
    var numbers: [max]u32 = undefined;
    var count: usize = 0;
    var i: usize = 0;

    while (i < input.len) {
        // Skip non-digit characters
        while (i < input.len and (input[i] < '0' or input[i] > '9')) : (i += 1) {}

        if (i >= input.len) break;

        // Found a digit; parse number
        var num: u32 = 0;
        while (i < input.len and input[i] >= '0' and input[i] <= '9') : (i += 1) {
            num = num * 10 + (input[i] - '0');
        }

        if (count < max) {
            numbers[count] = num;
            count += 1;
        } else {
            @panic("Too many numbers in input string (overflowed fixed array)");
        }
    }

    return numbers[0..count];
}
