const std = @import("std");
const utils = @import("utils.zig");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const parsed = try BoxDim.parse(allocator, input);
    defer allocator.free(parsed);

    const tick = try std.time.Instant.now();
    const p1 = part1(parsed);
    const p2 = part2(parsed);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});

    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(dims: []const BoxDim) u64 {
    var paper: u64 = 0;
    for (dims) |dim| {
        const area = 2 * (dim.min * dim.mid + dim.mid * dim.max + dim.max * dim.min);
        const slack = dim.min * dim.mid;
        paper += area + slack;
    }
    return paper;
}

fn part2(input: []const BoxDim) u64 {
    var ribbon: u64 = 0;
    for (input) |box| {
        const cubic = box.mid * box.min * box.max;

        const perimiter = 2 * (box.mid + box.min);

        ribbon += cubic + perimiter;
    }
    return ribbon;
}

const BoxDim = struct {
    min: u64,
    mid: u64,
    max: u64,

    fn parse(allocator: std.mem.Allocator, input: []const u8) ![]BoxDim {
        var buf: [5000]u64 = undefined;
        const read = utils.parseNumbers(&buf, input);
        const numbers = buf[0..read];

        var boxes = try allocator.alloc(BoxDim, numbers.len / 3);
        var it = std.mem.window(u64, numbers, 3, 3);
        var idx: usize = 0;

        while (it.next()) |chunk| {
            var dims: [3]u64 = undefined;
            std.mem.copyForwards(u64, &dims, chunk);
            std.mem.sort(u64, &dims, {}, std.sort.asc(u64));

            boxes[idx] = BoxDim{
                .min = dims[0],
                .mid = dims[1],
                .max = dims[2],
            };

            idx += 1;
        }
        return boxes;
    }
};

test "part1" {
    const dims = [_]BoxDim{BoxDim{ .min = 2, .mid = 3, .max = 4 }};
    try std.testing.expectEqual(58, part1(&dims));
}

test "part2" {
    const dims = [_]BoxDim{BoxDim{ .min = 2, .mid = 3, .max = 4 }};
    try std.testing.expectEqual(34, part2(&dims));
}
