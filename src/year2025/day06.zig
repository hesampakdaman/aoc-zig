const std = @import("std");
const Solution = @import("../solution.zig").Solution;

pub fn solve(allocator: std.mem.Allocator, input: []const u8) !Solution {
    const tick = try std.time.Instant.now();

    const data = try parse(allocator, input);

    const p1: usize = try part1(allocator, data.problems, data.operators);
    const p2: usize = try part2(allocator, input);

    const tock = try std.time.Instant.now();

    const p1_str = try std.fmt.allocPrint(allocator, "{}", .{p1});
    const p2_str = try std.fmt.allocPrint(allocator, "{}", .{p2});
    return Solution.init(
        p1_str,
        p2_str,
        tock.since(tick),
    );
}

fn part1(allocator: std.mem.Allocator, problems: std.ArrayList(std.ArrayList(usize)), operators: []u8) !usize {
    var partials = try allocator.alloc(usize, operators.len);
    for (operators, 0..) |op, i| {
        switch (op) {
            '+' => partials[i] = 0,
            else => partials[i] = 1,
        }
    }
    for (problems.items) |problem| {
        for (problem.items, 0..) |digit, i| {
            switch (operators[i]) {
                '+' => partials[i] += digit,
                else => partials[i] *= digit,
            }
        }
    }

    var sum: usize = 0;
    for (partials) |partial| {
        sum += partial;
    }

    return sum;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !usize {
    var sum: usize = 0;
    const rows: usize = std.mem.count(u8, input, "\n");
    const cols: usize = input.len / rows;
    var m = cols;
    var op: ?u8 = null;
    var partial = try std.ArrayList(u8).initCapacity(allocator, 5);
    while (m > 0) : (m -= 1) {
        const j = m - 1;
        for (0..rows) |i| {
            const char = input[i * cols + j];
            if (char == ' ' or char == '\n') continue;
            if (char == '*' or char == '+') {
                op = char;
                continue;
            }
            try partial.append(allocator, char);
        }
        if (op == null) {
            try partial.append(allocator, ' ');
        } else if (op == '+') {
            var partial_sum: usize = 0;
            var it = std.mem.splitScalar(u8, partial.items, ' ');
            while (it.next()) |digit| {
                if (digit.len == 0) continue;
                partial_sum += try std.fmt.parseInt(usize, digit, 10);
            }
            sum += partial_sum;
            op = null;
            partial.clearRetainingCapacity();
        } else {
            var partial_sum: usize = 1;
            var it = std.mem.splitScalar(u8, partial.items, ' ');
            while (it.next()) |digit| {
                if (digit.len == 0) continue;
                partial_sum *= try std.fmt.parseInt(usize, digit, 10);
            }
            sum += partial_sum;
            op = null;
            partial.clearRetainingCapacity();
        }
    }

    return sum;
}

fn parse(allocator: std.mem.Allocator, input: []const u8) !struct { problems: std.ArrayList(std.ArrayList(usize)), operators: []u8 } {
    var problems = try std.ArrayList(std.ArrayList(usize)).initCapacity(allocator, std.mem.count(u8, input, "\n"));
    var lines = std.mem.splitScalar(u8, input, '\n');
    while (true) {
        if (std.mem.containsAtLeast(u8, lines.peek().?, 1, "*")) break;

        const line = lines.next().?;
        if (line.len == 0) continue;

        var row = try std.ArrayList(usize).initCapacity(allocator, 1_000);
        var digits = std.mem.splitScalar(u8, line, ' ');
        while (digits.next()) |digit_char| {
            if (digit_char.len == 0) continue;

            const digit = try std.fmt.parseInt(usize, digit_char, 10);
            try row.append(allocator, digit);
        }
        try problems.append(allocator, row);
    }

    var operators = try allocator.alloc(u8, problems.items[0].items.len);
    var it = std.mem.splitScalar(u8, lines.next().?, ' ');
    var i: usize = 0;
    while (it.next()) |op| {
        if (op.len == 0) continue;
        operators[i] = op[0];
        i += 1;
    }

    return .{ .problems = problems, .operators = operators };
}
