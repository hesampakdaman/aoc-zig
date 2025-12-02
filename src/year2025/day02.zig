const std = @import("std");
const Solution = @import("../solution.zig").Solution;
const ArrayList = std.ArrayList;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const product_ids = try parse(allocator, input);

    const p1 = part1(product_ids);
    const p2 = try part2(product_ids);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(input: ArrayList([2]usize)) usize {
    var sum: usize = 0;

    for (input.items) |range| {
        const A = range[0];
        const B = range[1];

        const k_max = numDigits(B) / 2;
        var k = numDigits(A) / 2;

        while (k <= k_max) : (k += 1) {
            const scale = std.math.pow(usize, 10, k);
            const first_half_min = std.math.pow(usize, 10, k - 1);

            for (first_half_min..scale) |first_half| {
                const symmetric = first_half * scale + first_half;
                if (symmetric > B) break;
                if (symmetric >= A) sum += symmetric;
            }
        }
    }
    return sum;
}

fn part2(input: ArrayList([2]usize)) !usize {
    var sum: usize = 0;

    for (input.items) |range| {
        for (range[0]..range[1] + 1) |n| {
            var buf: [32]u8 = undefined;
            const s = try std.fmt.bufPrint(&buf, "{}", .{n});

            for (1..(s.len / 2) + 1) |p| {
                if (s.len % p != 0) continue;
                const block = s[0..p];

                var ok = true;
                var i: usize = p;
                while (i < s.len) : (i += p) {
                    if (!std.mem.eql(u8, block, s[i .. i + p])) {
                        ok = false;
                        break;
                    }
                }

                if (ok) {
                    if ((s.len / p) >= 2) sum += n;
                    break;
                }
            }
        }
    }

    return sum;
}

fn numDigits(n: usize) usize {
    var x = n;
    var d: usize = 1;

    while (x >= 10) : (x /= 10) d += 1;

    return d;
}

fn parse(alloc: std.mem.Allocator, input: []const u8) !ArrayList([2]usize) {
    var result = try ArrayList([2]usize).initCapacity(alloc, 10_000);

    var it = std.mem.splitScalar(u8, input, ',');
    while (it.next()) |elem| {
        if (elem.len <= 0) continue;
        const line = std.mem.trim(u8, elem, "\n");
        const split = std.mem.indexOf(u8, line, "-").?;
        const start = try std.fmt.parseInt(usize, line[0..split], 10);
        const end = try std.fmt.parseInt(usize, line[split + 1 ..], 10);
        try result.append(alloc, .{ start, end });
    }
    return result;
}
