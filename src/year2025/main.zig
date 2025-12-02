const std = @import("std");
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");

pub fn run(allocator: std.mem.Allocator, day: u8, input: []const u8) !void {
    switch (day) {
        1 => {
            const sol = try day01.solve(allocator, input);
            sol.print();
        },
        2 => {
            const sol = try day02.solve(allocator, input);
            sol.print();
        },
        else => std.debug.print("Unknown day for 2015: {}\n", .{day}),
    }
}

test {
    std.testing.refAllDecls(@This());
}
