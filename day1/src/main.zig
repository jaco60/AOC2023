const std = @import("std");
const String = []const u8;

// Hack because ComptimeStringMap doesn't provides a keyIterator like StringHashMap
const numbers = [_]String{
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
};

// Comptime translation table for part2
const translations = std.ComptimeStringMap(u8, .{
    .{ "one", '1' },
    .{ "two", '2' },
    .{ "three", '3' },
    .{ "four", '4' },
    .{ "five", '5' },
    .{ "six", '6' },
    .{ "seven", '7' },
    .{ "eight", '8' },
    .{ "nine", '9' },
});

fn part(alloc: std.mem.Allocator, in_part2: bool) !u32 {
    const input = @embedFile("input.txt");
    var lines = std.mem.tokenizeAny(u8, input, "\r\n");
    var sum: u32 = 0;
    while (lines.next()) |line| {
        sum += try keepDigits(line, alloc, in_part2);
    }
    return sum;
}

fn keepDigits(line: String, alloc: std.mem.Allocator, in_part2: bool) !u32 {
    var digits = std.ArrayList(u32).init(alloc);
    defer digits.deinit();

    var i: usize = 0;
    while (i < line.len) : (i += 1) {
        const char = line[i]; // Part1 + Part2
        if (std.ascii.isDigit(char)) {
            try digits.append(char - '0');
        }
        if (in_part2) { // <---- Only Part 2
            for (numbers) |number| {
                if (number.len + i <= line.len) {
                    if (std.mem.eql(u8, line[i .. number.len + i], number)) {
                        const n = translations.get(number) orelse unreachable;
                        try digits.append(n - '0');
                    }
                }
            }
        }
    }
    return digits.items[0] * 10 + digits.getLast();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();
    defer _ = gpa.deinit();

    std.debug.print("part1: {!}\n", .{part(alloc, false)}); // part 1
    std.debug.print("part2 : {!}\n", .{part(alloc, true)}); // part 2
}
