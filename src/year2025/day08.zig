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

fn part1(allocator: std.mem.Allocator, input: []Junction) !usize {
    var data = try allocator.alloc(Junction, input.len);
    @memcpy(data, input);

    var q = std.PriorityQueue(Distance, void, lessThan).init(allocator, {});
    for (0..data.len) |i| {
        for (i + 1..data.len) |j| {
            const d = Distance{ .i = i, .j = j, .dist_sq = data[i].dist(data[j]) };
            try q.add(d);
        }
    }

    var circuits = try std.ArrayList(usize).initCapacity(allocator, 1_000);
    var i: usize = 0;
    while (q.removeOrNull()) |elem| : (i += 1) {
        if (i == 1000) break;
        var u = &data[elem.i];
        var v = &data[elem.j];

        if (u.circuit == null and v.circuit == null) {
            try circuits.append(allocator, 2);
            u.circuit = circuits.items.len - 1;
            v.circuit = circuits.items.len - 1;
        } else if (u.circuit == null) {
            circuits.items[v.circuit.?] += 1;
            u.circuit = v.circuit;
        } else if (v.circuit == null) {
            circuits.items[u.circuit.?] += 1;
            v.circuit = u.circuit;
        } else if (u.circuit != v.circuit) {
            const old_c = v.circuit.?;
            for (0..data.len) |k| {
                if (data[k].circuit == old_c) data[k].circuit = u.circuit;
            }
            circuits.items[u.circuit.?] += circuits.items[old_c];
            circuits.items[old_c] = 0;
        }
    }

    var sum: usize = 1;
    std.mem.sort(usize, circuits.items, {}, std.sort.desc(usize));
    for (circuits.items, 0..) |c, k| {
        if (c == 0) continue;
        if (k == 3) break;
        sum *= c;
    }
    return sum;
}

fn part2(allocator: std.mem.Allocator, input: []Junction) !usize {
    var data = try allocator.alloc(Junction, input.len);
    @memcpy(data, input);

    var q = std.PriorityQueue(Distance, void, lessThan).init(allocator, {});
    for (0..data.len) |i| {
        for (i + 1..data.len) |j| {
            const d = Distance{ .i = i, .j = j, .dist_sq = data[i].dist(data[j]) };
            try q.add(d);
        }
    }

    var circuits = try std.ArrayList(usize).initCapacity(allocator, 1_000);
    var i: usize = 0;
    while (q.removeOrNull()) |elem| : (i += 1) {
        var u = &data[elem.i];
        var v = &data[elem.j];

        if (u.circuit == null and v.circuit == null) {
            try circuits.append(allocator, 2);
            u.circuit = circuits.items.len - 1;
            v.circuit = circuits.items.len - 1;
        } else if (u.circuit == null) {
            circuits.items[v.circuit.?] += 1;
            u.circuit = v.circuit;
        } else if (v.circuit == null) {
            circuits.items[u.circuit.?] += 1;
            v.circuit = u.circuit;
        } else if (u.circuit != v.circuit) {
            const old_c = v.circuit.?;
            for (0..data.len) |k| {
                if (data[k].circuit == old_c) data[k].circuit = u.circuit;
            }
            circuits.items[u.circuit.?] += circuits.items[old_c];
            circuits.items[old_c] = 0;
        }

        var done = true;
        for (0..data.len) |k| {
            if (data[0].circuit != data[k].circuit) done = false;
        }
        if (done) {
            return u.point[0] * v.point[0];
        }
    }
    return error.NoAnswer;
}

const Distance = struct {
    i: usize,
    j: usize,
    dist_sq: usize,
};

const Junction = struct {
    point: [3]usize,
    circuit: ?usize,

    pub fn dist(self: Junction, junc: Junction) usize {
        const a = self.point;
        const b = junc.point;
        const dx = @as(isize, @intCast(a[0])) - @as(isize, @intCast(b[0]));
        const dy = @as(isize, @intCast(a[1])) - @as(isize, @intCast(b[1]));
        const dz = @as(isize, @intCast(a[2])) - @as(isize, @intCast(b[2]));
        return @intCast(dx * dx + dy * dy + dz * dz);
    }
};

fn lessThan(context: void, a: Distance, b: Distance) std.math.Order {
    _ = context;
    return std.math.order(a.dist_sq, b.dist_sq);
}

fn parse(allocator: std.mem.Allocator, input: []const u8) ![]Junction {
    const rows = std.mem.count(u8, input, "\n");
    var buf = try allocator.alloc(Junction, rows);

    var i: usize = 0;
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| : (i += 1) {
        if (line.len == 0) continue;
        var it = std.mem.splitScalar(u8, line, ',');
        var digits: [3]usize = undefined;
        var j: usize = 0;
        while (it.next()) |digit| : (j += 1) {
            if (digit.len == 0) continue;
            digits[j] = try std.fmt.parseInt(usize, digit, 10);
        }
        buf[i] = Junction{ .point = digits, .circuit = null };
    }
    return buf;
}
