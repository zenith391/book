const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const reader = std.io.getStdIn().reader();

    var grades = std.ArrayList(f32).init(allocator);
    defer grades.deinit();
    while (true) {
        std.debug.print("Enter a grade: ", .{});
        const line = try reader.readUntilDelimiterAlloc(allocator, '\n', std.math.maxInt(usize));
        defer allocator.free(line);
        if (std.mem.eql(u8, line, "")) { // empty line means we stop entering grades
            break;
        } else {
            const number = try std.fmt.parseFloat(f32, line);
            try grades.append(number);
        }
    }

    var sum: f32 = 0; // add all the grades
    for (grades.items) |grade| {
        sum += grade;
    }
    const average = sum / @intToFloat(f32, grades.items.len); // and divide by the number of grades
    std.debug.print("Your average is {d}\n", .{ average });
}