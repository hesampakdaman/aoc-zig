const std = @import("std");
const Solution = @import("../solution.zig").Solution;
const ArrayList = std.ArrayList;

const MAX_ROTATIONS = 100;
const DIAL_START_POSITION = 50;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const rotations = try parse(allocator, input);
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
    var dial: i32 = DIAL_START_POSITION;

    for (input.items) |rotation| {
        dial = @mod(dial + rotation, MAX_ROTATIONS);
        if (dial == 0) count += 1;
    }
    return count;
}

fn part2(input: ArrayList(i32)) i32 {
    var count: i32 = 0;
    var dial: i32 = DIAL_START_POSITION;

    for (input.items) |rot| {
        var rotation = rot;

        const crosses_zero_forward = rotation >= MAX_ROTATIONS - dial;
        const crosses_zero_backward = rotation < 0 and @abs(rotation) >= dial;

        if (crosses_zero_forward) {
            count += 1;
            rotation -= MAX_ROTATIONS - dial;
            dial = 0;
        } else if (crosses_zero_backward and dial != 0) {
            count += 1;
            rotation += dial;
            dial = 0;
        }

        const at_zero_and_has_extra_turns = dial == 0 and @abs(rotation) > 0;
        if (at_zero_and_has_extra_turns) {
            const abs: i32 = @intCast(@abs(rotation));
            count += @divFloor(abs, MAX_ROTATIONS);
        }

        dial = @mod(dial + rotation, MAX_ROTATIONS);
    }
    return count;
}

fn parse(alloc: std.mem.Allocator, input: []const u8) !ArrayList(i32) {
    var result = try ArrayList(i32).initCapacity(alloc, 1000);

    var it = std.mem.splitScalar(u8, input, '\n');
    while (it.next()) |line| {
        if (line.len <= 0) continue;
        const rotation = try std.fmt.parseInt(i32, line[1..], 10);
        const direction: i32 = if (line[0] == 'R') 1 else -1;
        try result.append(alloc, rotation * direction);
    }
    return result;
}
