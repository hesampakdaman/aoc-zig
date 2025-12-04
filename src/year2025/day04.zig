const std = @import("std");
const Solution = @import("../solution.zig").Solution;
const ArrayList = std.ArrayList;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const grid = try parse(allocator, input);

    const p1 = part1(grid);
    const p2 = try part2(allocator, grid);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(input: [][]const u8) usize {
    var rolls: usize = 0;
    for (0..input.len) |i| {
        for (0..input[0].len) |j| {
            if (input[i][j] != '@') continue;
            if (paperNeighbors(input, i, j) < 4) rolls += 1;
        }
    }
    return rolls;
}

fn part2(allocator: std.mem.Allocator, input: [][]const u8) !usize {
    var rolls: usize = 0;
    const rows = input.len;

    var grid = try allocator.alloc([]u8, rows);
    for (input, 0..) |line, r| {
        const len = line.len;
        grid[r] = try allocator.alloc(u8, len);
        std.mem.copyForwards(u8, grid[r], line);
    }

    var done = false;
    while (!done) {
        done = true;
        for (0..input.len) |i| {
            for (0..input[0].len) |j| {
                if (grid[i][j] != '@') continue;
                if (paperNeighbors(grid, i, j) < 4) {
                    grid[i][j] = '.';
                    done = false;
                    rolls += 1;
                }
            }
        }
    }
    return rolls;
}

fn parse(allocator: std.mem.Allocator, input: []const u8) ![][]const u8 {
    const rows = std.mem.count(u8, input, "\n");
    var grid = try allocator.alloc([]const u8, rows);

    var it = std.mem.splitScalar(u8, input, '\n');
    var r: usize = 0;
    while (it.next()) |row| : (r += 1) {
        if (row.len <= 0) continue;
        grid[r] = row;
    }
    return grid;
}

fn paperNeighbors(grid: []const []const u8, i: usize, j: usize) usize {
    const rows = grid.len;
    const cols = grid[0].len;
    var sum: usize = 0;

    if (i > 0 and grid[i - 1][j] == '@') sum += 1;
    if (i > 0 and j < cols - 1 and grid[i - 1][j + 1] == '@') sum += 1;
    if (i > 0 and j > 0 and grid[i - 1][j - 1] == '@') sum += 1;

    if (j < cols - 1 and grid[i][j + 1] == '@') sum += 1;
    if (j > 0 and grid[i][j - 1] == '@') sum += 1;

    if (i < rows - 1 and grid[i + 1][j] == '@') sum += 1;
    if (i < rows - 1 and j < cols - 1 and grid[i + 1][j + 1] == '@') sum += 1;
    if (i < rows - 1 and j > 0 and grid[i + 1][j - 1] == '@') sum += 1;

    return sum;
}
