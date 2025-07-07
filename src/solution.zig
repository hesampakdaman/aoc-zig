const std = @import("std");

pub const Solution = struct {
    p1: []const u8,
    p2: []const u8,
    duration_ns: u64,

    pub fn init(part1: []const u8, part2: []const u8, duration_ns: u64) @This() {
        return Solution{
            .p1 = part1,
            .p2 = part2,
            .duration_ns = duration_ns,
        };
    }

    pub fn print(self: Solution) void {
        const ms = @as(f64, @floatFromInt(self.duration_ns)) / 1_000_000.0;
        std.debug.print("Part 1: {s}\nPart 2: {s}\nTime: {d} ms\n", .{ self.p1, self.p2, ms });
    }
};
