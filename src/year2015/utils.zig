const std = @import("std");

pub fn parseU64(buffer: []u64, input: []const u8) ![]u64 {
    var count: usize = 0;
    var i: usize = 0;

    while (i < input.len) {
        // Skip non-digit characters
        while (i < input.len and (input[i] < '0' or input[i] > '9')) : (i += 1) {}

        if (i >= input.len) break;

        // Found a digit; parse number
        var num: u64 = 0;
        while (i < input.len and input[i] >= '0' and input[i] <= '9') : (i += 1) {
            num = num * 10 + (input[i] - '0');
        }

        if (count < buffer.len) {
            buffer[count] = num;
            count += 1;
        } else {
            return error.OutOfMemory;
        }
    }
    return buffer[0..count];
}
