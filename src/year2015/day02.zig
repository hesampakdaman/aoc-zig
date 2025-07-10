const std = @import("std");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const parsed = try GiftBox.parseMany(allocator, input);
    defer allocator.free(parsed);

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

fn part1(dims: []const GiftBox) u32 {
    var paper: u32 = 0;
    for (dims) |dim| {
        const area = (2 * dim.length * dim.width) + (2 * dim.width * dim.height) + (2 * dim.height * dim.length);
        const slack = @min(dim.length * dim.width, @min(dim.width * dim.height, dim.height * dim.length));
        paper += area + slack;
    }
    return paper;
}

test "part1" {
    const dims = [_]GiftBox{GiftBox{ .length = 2, .width = 3, .height = 4 }};
    try std.testing.expectEqual(58, part1(&dims));
}

fn part2(input: []const GiftBox) u32 {
    var ribbon: u32 = 0;
    for (input) |box| {
        const cubic = box.width * box.length * box.height;

        const min = @min(box.width, box.length, box.height);
        const max = @max(box.width, box.length, box.height);
        const mid = box.width + box.length + box.height - (max + min);
        const perimiter = 2 * (mid + min);

        ribbon += cubic + perimiter;
    }
    return ribbon;
}

test "part2" {
    const dims = [_]GiftBox{GiftBox{ .length = 2, .width = 3, .height = 4 }};
    try std.testing.expectEqual(34, part2(&dims));
}

const GiftBox = struct {
    length: u32,
    width: u32,
    height: u32,

    fn parseMany(allocator: std.mem.Allocator, input: []const u8) ![]GiftBox {
        var dims = std.ArrayList(GiftBox).init(allocator);
        defer dims.deinit();

        var lines = std.mem.splitSequence(u8, input, "\n");
        while (lines.next()) |line| {
            if (line.len == 0) continue;
            try dims.append(try GiftBox.parseLine(line));
        }
        return try dims.toOwnedSlice();
    }

    fn parseLine(line: []const u8) !GiftBox {
        var it = std.mem.splitSequence(u8, line, "x");
        const l = std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10) catch return error.InvalidInput;
        const w = std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10) catch return error.InvalidInput;
        const h = std.fmt.parseInt(u32, it.next() orelse return error.InvalidInput, 10) catch return error.InvalidInput;
        return GiftBox{ .length = l, .width = w, .height = h };
    }
};
