const std = @import("std");
const print = std.debug.print;

// Too bad there's still no regexp in Zig !
fn solve(input: []const u8) ![2]u32 {
    var games = std.mem.tokenizeAny(u8, input, "\r\n");
    var result1: u32 = 0;
    var result2: u32 = 0;

    // Counting all red, green, blue cubes for each game...
    while (games.next()) |game| {
        var nbRed: u32 = 0;
        var nbGreen: u32 = 0;
        var nbBlue: u32 = 0;

        var cubes = std.mem.tokenizeAny(u8, game[5..], " :,;");
        const numGame = try std.fmt.parseInt(u32, cubes.next().?, 10);

        while (cubes.next()) |cube| {
            const nb = try std.fmt.parseInt(u32, cube, 10);
            const color = cubes.next().?;
            if (std.mem.eql(u8, color, "red")) {
                nbRed = @max(nb, nbRed);
            } else if (std.mem.eql(u8, color, "green")) {
                nbGreen = @max(nb, nbGreen);
            } else {
                nbBlue = @max(nb, nbBlue);
            }
        }

        // Part 1
        if (nbRed <= 12 and nbGreen <= 13 and nbBlue <= 14) {
            result1 += numGame;
        }

        // Part2
        result2 += nbRed * nbGreen * nbBlue;
    }

    return .{ result1, result2 };
}

// Thanks to SpexGuy for its simple vision of the problem (mine was far too complex)
pub fn main() !void {
    const input = @embedFile("input.txt");
    const parts = try solve(input);
    print("part1: {!}\n", .{parts[0]}); // part 1
    print("part2 : {!}\n", .{parts[1]}); // part 2
}

test "sample" {
    const input = @embedFile("sample.txt");
    const parts = try solve(input);
    try std.testing.expectEqual(parts[0], 8);
    try std.testing.expectEqual(parts[1], 2286);
}
