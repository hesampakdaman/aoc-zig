const std = @import("std");
const day01 = @import("day01.zig");

pub fn run(allocator: std.mem.Allocator, day: u8, input: []const u8) !void {
    switch (day) {
        1 => {
            const result = try day01.solve(allocator, input);
            std.debug.print("2015 Day 1:\n{s}\n", .{result});
        },
        else => std.debug.print("Unknown day for 2015: {}\n", .{day}),
    }
}

test {
    _ = day01;
    std.testing.refAllDecls(@This());
}
