const std = @import("std");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const data = try parse(allocator, input);

    const p1: usize = try part1(allocator, data);
    const p2: usize = try part2(allocator, data);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

const Index = struct {
    i: usize,
    j: usize,
};

fn part1(allocator: std.mem.Allocator, input: Data) !usize {
    var data = input;
    data.buf = try allocator.dupe(u8, input.buf);
    const start = std.mem.indexOf(u8, data.buf, "S").?;
    var q = try std.ArrayList(Index).initCapacity(allocator, 1_000);
    var visited = try allocator.alloc(bool, data.buf.len);
    try q.append(allocator, .{ .i = 1, .j = start });

    var split: usize = 0;

    while (q.pop()) |pos| {
        if (pos.i >= data.rows) continue;
        if (visited[pos.i * data.cols + pos.j]) continue;

        visited[pos.i * data.cols + pos.j] = true;
        switch (data.get(pos)) {
            '^' => {
                try q.append(allocator, .{ .i = pos.i + 1, .j = pos.j - 1 });
                try q.append(allocator, .{ .i = pos.i + 1, .j = pos.j + 1 });
                split += 1;
            },
            else => {
                const next: Index = .{ .i = pos.i + 1, .j = pos.j };
                try q.append(allocator, next);
            },
        }
    }

    return split;
}

fn part2(allocator: std.mem.Allocator, input: Data) !usize {
    var data = input;
    data.buf = try allocator.dupe(u8, input.buf);
    const start = std.mem.indexOf(u8, data.buf, "S").?;
    const down = Index{ .i = 1, .j = start };
    const cache = try allocator.alloc(usize, data.buf.len);
    @memset(cache, 0);
    return dfs(down, input, cache);
}

fn dfs(idx: Index, input: Data, cache: []usize) usize {
    if (idx.i >= input.rows) return 1;
    if (cache[idx.i * input.cols + idx.j] > 0) return cache[idx.i * input.cols + idx.j];
    if (input.get(idx) == '^') {
        const left: Index = .{ .i = idx.i, .j = idx.j - 1 };
        const right: Index = .{ .i = idx.i, .j = idx.j + 1 };
        const number = dfs(left, input, cache) + dfs(right, input, cache);
        cache[idx.i * input.cols + idx.j] = number;
        return number;
    }
    const down = Index{ .i = idx.i + 1, .j = idx.j };
    return dfs(down, input, cache);
}

const Data = struct {
    buf: []u8,
    rows: usize,
    cols: usize,

    pub fn get(self: Data, idx: Index) usize {
        return self.buf[idx.i * self.cols + idx.j];
    }

    pub fn set(self: Data, idx: Index, c: u8) void {
        self.buf[idx.i * self.cols + idx.j] = c;
    }
};

fn parse(allocator: std.mem.Allocator, input: []const u8) !Data {
    const rows = std.mem.count(u8, input, "\n");
    var buf = try allocator.alloc(u8, input.len);
    var i: usize = 0;
    for (input) |ch| {
        if (ch == '\n') continue;
        buf[i] = ch;
        i += 1;
    }
    return .{ .buf = buf[0..i], .rows = rows, .cols = i / rows };
}
