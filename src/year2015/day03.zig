const std = @import("std");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    var x_min: i32 = 1;
    var x_max: i32 = -1;
    var y_min: i32 = 1;
    var y_max: i32 = -1;

    var pos: [2]i32 = .{ 0, 0 };
    for (input) |char| {
        x_min = @min(x_min, pos[0]);
        x_max = @max(x_max, pos[0]);
        y_min = @min(y_min, pos[1]);
        y_max = @max(y_max, pos[1]);
        switch (char) {
            '>' => pos = .{ pos[0] + 1, pos[1] },
            '<' => pos = .{ pos[0] - 1, pos[1] },
            '^' => pos = .{ pos[0], pos[1] + 1 },
            else => pos = .{ pos[0], pos[1] - 1 },
        }
    }
    var set = Set.init(allocator);
    try set.ensureTotalCapacity(10000);
    defer set.deinit();

    const p1 = try part1(&set, input);
    const p2 = 3;

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

fn part1(set: *Set, input: []const u8) !usize {
    var houses: usize = 0;
    var pos: [2]i32 = .{ 0, 0 };

    for (input) |dir| {
        if (set.get(pos) == null) {
            houses += 1;
            try set.put(pos, Empty{});
        }
        switch (dir) {
            '>' => pos = .{ pos[0] + 1, pos[1] },
            '<' => pos = .{ pos[0] - 1, pos[1] },
            '^' => pos = .{ pos[0], pos[1] + 1 },
            'v' => pos = .{ pos[0], pos[1] - 1 },
            else => std.debug.print("Unknown direction: {c}\n", .{dir}),
        }
    }
    return houses;
}
