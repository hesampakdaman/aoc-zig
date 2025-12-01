const std = @import("std");

const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    var set = Set.init(allocator);
    try set.ensureTotalCapacity(@intCast(input.len));

    const p1 = try part1(&set, input);
    set.clearRetainingCapacity();
    const p2 = try part2(&set, input);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

const Empty = struct {};
const Set = std.AutoHashMap([2]i32, Empty);

fn part1(set: *Set, directions: []const u8) !usize {
    var houses: usize = 0;
    var pos: [2]i32 = .{ 0, 0 };

    for (directions) |dir| {
        if (set.get(pos) == null) {
            houses += 1;
            try set.put(pos, Empty{});
        }
        advance(&pos, dir);
    }
    return houses;
}

fn part2(set: *Set, directions: []const u8) !usize {
    var houses: usize = 0;
    var santa: [2]i32 = .{ 0, 0 };
    var robot: [2]i32 = .{ 0, 0 };

    var it = std.mem.window(u8, directions, 2, 2);
    while (it.next()) |chunk| {
        if (set.get(santa) == null) {
            houses += 1;
            try set.put(santa, Empty{});
        }
        if (set.get(robot) == null) {
            houses += 1;
            try set.put(robot, Empty{});
        }
        advance(&santa, chunk[0]);
        advance(&robot, chunk[1]);
    }
    return houses;
}

inline fn advance(pos: *[2]i32, dir: u8) void {
    switch (dir) {
        '>' => pos[0] += 1,
        '<' => pos[0] -= 1,
        '^' => pos[1] += 1,
        else => pos[1] -= 1,
    }
}
