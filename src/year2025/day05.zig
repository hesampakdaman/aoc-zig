const std = @import("std");
const Solution = @import("../solution.zig").Solution;
const ArrayList = std.ArrayList;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const data = try parse(allocator, input);

    const p1 = part1(data.range, data.ingridients);
    const p2 = try part2(allocator, data.range);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(ranges: []Range, ingridients: []usize) usize {
    var fresh: usize = 0;
    for (ingridients) |ingridient| {
        for (ranges) |range| {
            if (range.start <= ingridient and ingridient <= range.end) {
                fresh += 1;
                break;
            }
        }
    }
    return fresh;
}

fn part2(allocator: std.mem.Allocator, ranges: []Range) !usize {
    var fresh: usize = 0;

    var covered = try allocator.alloc(bool, ranges.len);
    @memset(covered, false);

    for (0..ranges.len) |i| {
        if (covered[i]) continue;
        if (i + 1 < ranges.len and encapsulated(ranges[i], ranges[i + 1 ..])) {
            covered[i] = true;
            continue;
        }

        const a = ranges[i];
        for (i + 1..ranges.len) |j| {
            if (covered[j]) continue;

            var b = &ranges[j];
            if (a.fullyCovers(b.*)) {
                covered[j] = true;
            } else if (a.leftOverlap(b.*)) {
                b.start = a.end + 1;
                if (b.start > b.end) covered[j] = true;
            } else if (a.rightOverlap(b.*)) {
                b.end = a.start - 1;
                if (b.end < b.start) covered[j] = true;
            }
        }
        fresh += a.size();
    }
    return fresh;
}

const Range = struct {
    start: usize,
    end: usize,

    pub fn size(self: Range) usize {
        return self.end - self.start + 1;
    }

    pub fn fullyCovers(self: Range, other: Range) bool {
        return (self.start <= other.start and other.end <= self.end);
    }

    pub fn leftOverlap(self: Range, b: Range) bool {
        return self.end >= b.start and self.end <= b.end;
    }

    pub fn rightOverlap(self: Range, b: Range) bool {
        return self.start >= b.start and self.start <= b.end;
    }
};

fn encapsulated(a: Range, ranges: []Range) bool {
    for (ranges) |b| {
        if (b.fullyCovers(a)) return true;
    }
    return false;
}

fn parse(allocator: std.mem.Allocator, input: []const u8) !struct { range: []Range, ingridients: []usize } {
    var n_ranges: usize = 0;
    var i: usize = 0;
    while (true) : (i += 1) {
        if (input[i] == '\n') n_ranges += 1;
        if (input[i] == '\n' and input[i + 1] == '\n') break;
    }

    var ranges = try allocator.alloc(Range, n_ranges);
    var it = std.mem.splitScalar(u8, input, '\n');
    i = 0;
    while (it.next()) |line| : (i += 1) {
        if (std.mem.eql(u8, line, "")) break;
        const hyphen = std.mem.indexOf(u8, line, "-") orelse return error.InputError;
        const start = try std.fmt.parseInt(usize, line[0..hyphen], 10);
        const end = try std.fmt.parseInt(usize, line[hyphen + 1 ..], 10);
        ranges[i] = .{ .start = start, .end = end };
    }

    const n_blank_lines = 1;
    const n_ingridients: usize = std.mem.count(u8, input, "\n") - (n_ranges + n_blank_lines);
    var ingridients = try allocator.alloc(usize, n_ingridients);
    i = 0;
    while (it.next()) |line| : (i += 1) {
        if (std.mem.eql(u8, line, "")) continue;
        ingridients[i] = try std.fmt.parseInt(usize, line, 10);
    }

    return .{ .range = ranges, .ingridients = ingridients };
}
