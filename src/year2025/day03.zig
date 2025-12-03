const std = @import("std");
const Solution = @import("../solution.zig").Solution;
const ArrayList = std.ArrayList;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const batteries = try parse(allocator, input);

    const p1 = part1(batteries);
    const p2 = part2(batteries);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(input: ArrayList([]const u8)) usize {
    var sum: usize = 0;

    for (input.items) |battery| {
        var first_digit: u8 = '0';
        var second_digit: u8 = '0';
        var first_idx: usize = 0;

        for (0..battery.len - 1) |i| {
            if (first_digit == '9') break;
            if (battery[i] > first_digit) {
                first_digit = battery[i];
                first_idx = i;
            }
        }

        for (battery[first_idx + 1 ..]) |digit| {
            if (digit > second_digit) second_digit = digit;
            if (second_digit == '9') break;
        }

        sum += (first_digit - '0') * 10 + (second_digit - '0');
    }
    return sum;
}

fn part2(input: ArrayList([]const u8)) usize {
    var sum: usize = 0;
    for (input.items) |battery| {
        var total: usize = 0;
        var jolt = findJolt(battery, 0, battery.len - 11);
        total += jolt.digit - '0';
        for (1..12) |i| {
            jolt = findJolt(battery, jolt.at + 1, battery.len - (11 - i));
            total *= 10;
            total += jolt.digit - '0';
        }
        sum += total;
    }
    return sum;
}

const Jolt = struct {
    digit: u8,
    at: usize,
};

fn findJolt(battery: []const u8, from: usize, to: usize) Jolt {
    var digit: u8 = '0';
    var at: usize = 0;

    for (from..to) |i| {
        if (digit == '9') break;
        if (battery[i] > digit) {
            digit = battery[i];
            at = i;
        }
    }

    return Jolt{ .digit = digit, .at = at };
}

fn parse(alloc: std.mem.Allocator, input: []const u8) !ArrayList([]const u8) {
    var result = try ArrayList([]const u8).initCapacity(alloc, 1_000);

    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |line| {
        if (line.len <= 0) continue;
        try result.append(alloc, line);
    }
    return result;
}
