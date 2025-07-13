const std = @import("std");
const utils = @import("utils.zig");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    var boxes: [3000]BoxDim = undefined;
    const parsed = try BoxDim.parse_fast(&boxes, input);

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

    fn parse_fast(boxes: []BoxDim, input: []const u8) ![]BoxDim {
        var i: usize = 0; // index in input
        var b: usize = 0; // index in boxes

        while (i < input.len) {
            // Parse first number
            var n1: u64 = 0;
            while (i < input.len and input[i] >= '0' and input[i] <= '9') : (i += 1) {
                n1 = n1 * 10 + (input[i] - '0');
            }
            if (i >= input.len or input[i] != 'x') return error.InvalidFormat;
            i += 1; // skip 'x'

            // Parse second number
            var n2: u64 = 0;
            while (i < input.len and input[i] >= '0' and input[i] <= '9') : (i += 1) {
                n2 = n2 * 10 + (input[i] - '0');
            }
            if (i >= input.len or input[i] != 'x') return error.InvalidFormat;
            i += 1; // skip 'x'

            // Parse third number
            var n3: u64 = 0;
            while (i < input.len and input[i] >= '0' and input[i] <= '9') : (i += 1) {
                n3 = n3 * 10 + (input[i] - '0');
            }
            // Next char must be '\n' or end of input
            if (i < input.len and (input[i] != '\n' and input[i] != '\r')) return error.InvalidFormat;
            if (i < input.len and (input[i] == '\n' or input[i] == '\r')) i += 1;

            // Calculate min, mid, max
            const min = @min(n1, @min(n2, n3));
            const max = @max(n1, @max(n2, n3));
            const mid = n1 + n2 + n3 - min - max;

            if (b >= boxes.len) return error.OutOfMemory;
            boxes[b] = BoxDim{ .min = min, .mid = mid, .max = max };
            b += 1;
        }
        return boxes[0..b];
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
