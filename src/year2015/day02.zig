const std = @import("std");
const utils = @import("utils.zig");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    var boxes: [1000]Box = undefined;
    try Box.parse(&boxes, input);
    const p1 = part1(&boxes);
    const p2 = part2(&boxes);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(dims: []const Box) u64 {
    var paper: u64 = 0;
    for (dims) |dim| {
        const area = 2 * (dim.min * dim.mid + dim.mid * dim.max + dim.max * dim.min);
        const slack = dim.min * dim.mid;
        paper += area + slack;
    }
    return paper;
}

fn part2(input: []const Box) u64 {
    var ribbon: u64 = 0;
    for (input) |box| {
        const cubic = box.mid * box.min * box.max;
        const perimiter = 2 * (box.mid + box.min);
        ribbon += cubic + perimiter;
    }
    return ribbon;
}

const Box = struct {
    min: u64,
    mid: u64,
    max: u64,

    fn parse(boxes: []Box, input: []const u8) !void {
        var buf: [3000]u64 = undefined;
        const read = try utils.parseU64s(&buf, input);
        const numbers = buf[0..read];

        var it = std.mem.window(u64, numbers, 3, 3);
        var i: usize = 0;
        while (it.next()) |chunk| {
            const min = @min(chunk[0], chunk[1], chunk[2]);
            const max = @max(chunk[0], chunk[1], chunk[2]);
            const mid = chunk[0] + chunk[1] + chunk[2] - min - max;
            boxes[i] = .{ .min = min, .mid = mid, .max = max };
            i += 1;
        }
    }
};

test "part1" {
    const dims = [_]Box{Box{ .min = 2, .mid = 3, .max = 4 }};
    try std.testing.expectEqual(58, part1(&dims));
}

test "part2" {
    const dims = [_]Box{Box{ .min = 2, .mid = 3, .max = 4 }};
    try std.testing.expectEqual(34, part2(&dims));
}
