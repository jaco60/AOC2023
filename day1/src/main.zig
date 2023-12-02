const std = @import("std");
const String = []const u8;
const print = std.debug.print;
const tokenizeAny = std.mem.tokenizeAny;
const indexOf = std.mem.indexOf;
const isDigit = std.ascii.isDigit;

const numbers = [_]String{
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
};

fn part(input: String, part2: bool) u32 {
    var lines = tokenizeAny(u8, input, "\r\n");
    var result: u32 = 0;

    while (lines.next()) |line| {
        var first_i: ?usize = null;
        var last_i: ?usize = null;
        var first_val: u32 = 0;
        var last_val: u32 = 0;

        for (line, 0..) |char, i| {
            if (isDigit(char)) {
                if (first_i == null) {
                    first_i = i;
                    first_val = char - '0';
                }
                last_i = i;
                last_val = char - '0';
            }
        }

        if (part2) {
            for (numbers, 1..) |str, int| {
                const pos = indexOf(u8, line, str);
                if (pos) |i| {
                    if (first_i == null or i < first_i.?) {
                        first_i = i;
                        first_val = @intCast(int);
                    }

                    if (last_i == null or i > last_i.?) {
                        last_i = i;
                        last_val = @intCast(int);
                    }
                }
            }
        }

        result += first_val * 10 + last_val;
    }
    return result;
}

pub fn main() !void {
    const input = @embedFile("input.txt");
    print("Part 1 : {d}\n", .{part(input, false)});
    print("Part 2 : {d}\n", .{part(input, true)});
}

test "part1" {
    const sample = @embedFile("sample1.txt");
    try std.testing.expectEqual(part(sample, false), 142);
}

test "part2" {
    const sample = @embedFile("sample2.txt");
    try std.testing.expectEqual(part(sample, true), 281);
}
