const std = @import("std");
const utils = @import("utils.zig");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    var buf: [3000]u64 = undefined;
    const boxes = try parse(&buf, input);

    const p1 = part1(boxes);
    const p2 = part2(boxes);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(input: []const u64) u64 {
    var paper: u64 = 0;
    var it = std.mem.window(u64, input, 3, 3);
    while (it.next()) |box| {
        const area = 2 * (box[0] * box[1] + box[0] * box[2] + box[1] * box[2]);
        const slack = box[0] * box[1];
        paper += area + slack;
    }
    return paper;
}

fn part2(input: []const u64) u64 {
    var ribbon: u64 = 0;
    var it = std.mem.window(u64, input, 3, 3);
    while (it.next()) |box| {
        const cubic = box[0] * box[1] * box[2];
        const perimiter = 2 * (box[1] + box[0]);
        ribbon += cubic + perimiter;
    }
    return ribbon;
}

fn parse(buf: []u64, input: []const u8) ![]u64 {
    const read = try utils.parseU64s(buf, input);
    const numbers = buf[0..read];

    var i: usize = 0;
    while (i + 2 < numbers.len) : (i += 3) {
        var chunk = numbers[i .. i + 3];
        const min = @min(chunk[0], chunk[1], chunk[2]);
        const max = @max(chunk[0], chunk[1], chunk[2]);
        const mid = chunk[0] + chunk[1] + chunk[2] - min - max;

        chunk[0] = min;
        chunk[1] = mid;
        chunk[2] = max;
    }
    return numbers;
}
