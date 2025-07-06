const std = @import("std");
const year2015 = @import("year2015/main.zig");

pub fn main() !void {
    const args = std.process.args();
    var it = args;
    _ = it.next();

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const year_str = it.next() orelse {
        std.debug.print("Usage: zig build run -- <year> <day>\n", .{});
        return;
    };
    const day_str = it.next() orelse {
        std.debug.print("Usage: zig build run -- <year> <day>\n", .{});
        return;
    };

    const year = try std.fmt.parseInt(u16, year_str, 10);
    const day = try std.fmt.parseInt(u8, day_str, 10);

    var buf: [65536]u8 = undefined;
    const len = try std.io.getStdIn().readAll(&buf);
    const input = buf[0..len];

    switch (year) {
        2015 => try year2015.run(allocator, day, input),
        else => std.debug.print("Unknown year: {}\n", .{year}),
    }
}

const _ = year2015;

test {
    std.testing.refAllDecls(@This());
}
