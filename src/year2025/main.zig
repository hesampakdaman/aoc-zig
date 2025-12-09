const std = @import("std");
const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");
const day04 = @import("day04.zig");
const day05 = @import("day05.zig");
const day06 = @import("day06.zig");
const day07 = @import("day07.zig");
const day08 = @import("day08.zig");

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
        3 => {
            const sol = try day03.solve(allocator, input);
            sol.print();
        },
        4 => {
            const sol = try day04.solve(allocator, input);
            sol.print();
        },
        5 => {
            const sol = try day05.solve(allocator, input);
            sol.print();
        },
        6 => {
            const sol = try day06.solve(allocator, input);
            sol.print();
        },
        7 => {
            const sol = try day07.solve(allocator, input);
            sol.print();
        },
        8 => {
            const sol = try day08.solve(allocator, input);
            sol.print();
        },
        else => std.debug.print("Unknown day for 2015: {}\n", .{day}),
    }
}

test {
    std.testing.refAllDecls(@This());
}
