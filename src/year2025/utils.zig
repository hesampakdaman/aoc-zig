const std = @import("std");

pub fn parseU64s(buffer: []u64, input: []const u8) !usize {
    var count: usize = 0;
    var i: usize = 0;

    while (i < input.len) {
        // Skip non-digit characters (x, newline, etc)
        while (i < input.len and (input[i] < '0' or input[i] > '9')) : (i += 1) {}

        if (i >= input.len) break;

        // Parse number
        var num: u64 = 0;
        while (i < input.len and input[i] >= '0' and input[i] <= '9') : (i += 1) {
            num = num * 10 + (input[i] - '0');
        }
        if (count >= buffer.len) return error.OutOfMemory;
        buffer[count] = num;
        count += 1;
    }
    return count;
}
