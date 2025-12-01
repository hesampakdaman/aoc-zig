const std = @import("std");
const Solution = @import("../solution.zig").Solution;
const ArrayList = std.ArrayList;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const rotations = parse(allocator, input);
    const p1 = part1(rotations);
    const p2 = part2(rotations);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(input: ArrayList(i32)) i32 {
    var count: i32 = 0;
    var dial: i32 = 50;
    for (input.items) |rotation| {
        dial = @mod(dial + rotation, 100);
        if (dial == 0) count += 1;
    }
    return count;
}

fn part2(input: ArrayList(i32)) i32 {
    var count: i32 = 0;
    var dial: i32 = 50;
    for (input.items) |rot| {
        var rotation = rot;
        // normalize
        if (rotation >= 100 - dial) {
            count += 1;
            rotation -= 100 - dial;
            dial = 0;
        } else if (rotation < 0 and @abs(rotation) >= dial and dial != 0) {
            count += 1;
            rotation += dial;
            dial = 0;
        }

        if (dial == 0 and @abs(rotation) > 0) {
            const abs_rot: i32 = @intCast(@abs(rotation));
            count += @divFloor(abs_rot, 100);
        }

        dial = @mod(dial + rotation, 100);
    }
    return count;
}

fn parse(alloc: std.mem.Allocator, input: []const u8) ArrayList(i32) {
    var result = ArrayList(i32).initCapacity(alloc, 1000) catch @panic("parse: could not allocate memory");
    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |line| {
        if (line.len <= 0) break;
        const rotation = std.fmt.parseInt(i32, line[1..], 10) catch @panic("parseInt: could not parse input");
        const direction: i32 = if (line[0] == 'R') 1 else -1;
        result.append(alloc, rotation * direction) catch @panic("append: could not add number to list");
    }
    return result;
}
