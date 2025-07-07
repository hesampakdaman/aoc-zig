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
    var ans: i32 = 0;
    for (input) |char| {
        if (char == '(') {
            ans += 1;
        } else if (char == ')') {
            ans -= 1;
        }
    }
    return ans;
}

fn part2(input: []const u8) usize {
    var ans: i32 = 0;
    for (input, 1..) |char, position| {
        if (char == '(') {
            ans += 1;
        } else if (char == ')') {
            ans -= 1;
        }
        if (ans == -1) {
            return position;
        }
    }
    return 0;
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
