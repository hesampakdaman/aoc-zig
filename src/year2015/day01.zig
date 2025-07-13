const std = @import("std");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const p1 = part1(input);
    const p2 = part2(input);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});

    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(input: []const u8) i32 {
    var floor: i32 = 0;
    for (input) |char| {
        floor += nextFloor(char);
    }
    return floor;
}

fn part2(input: []const u8) usize {
    var floor: i32 = 0;
    for (1.., input) |basement_idx, char| {
        if (floor == -1) return basement_idx;
        floor += nextFloor(char);
    }
    return 0;
}

inline fn nextFloor(paren: u8) i32 {
    // '(' == 40 and ')' == 41.
    const asciiValue: i32 = @intCast(paren);
    // '(' => 81 - 2*40 = 1.
    // ')' => 81 - 2*41 = -1.
    return 81 - 2 * asciiValue;
}

test "part1" {
    try std.testing.expectEqual(0, part1("()()"));
    try std.testing.expectEqual(3, part1("))((((("));
    try std.testing.expectEqual(-3, part1(")())())"));
}

test "part2" {
    try std.testing.expectEqual(1, part2(")"));
    try std.testing.expectEqual(5, part2("()())"));
}
