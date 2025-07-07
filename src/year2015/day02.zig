const std = @import("std");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const p1 = try part1(input);
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

fn part1(input: []const u8) !u32 {
    var wrapping_paper: u32 = 0;
    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var it = std.mem.splitSequence(u8, line, "x");
        const l = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10);
        const w = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10);
        const h = try std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10);

        const area = (2 * l * w) + (2 * w * h) + (2 * h * l);
        const slack = @min(l * w, @min(w * h, h * l));
        wrapping_paper += area + slack;
    }
    return wrapping_paper;
}

test "part1" {
    try std.testing.expectEqual(58, try part1("2x3x4"));
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

test "part2" {}
