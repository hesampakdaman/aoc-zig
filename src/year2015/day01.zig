const std = @import("std");

pub fn solve(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    const p1 = part1(input);
    const p2 = part2(input);

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});

    return std.fmt.allocPrint(allocator, "  {s}\n  {s}\n", .{ p1_str, p2_str });
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
