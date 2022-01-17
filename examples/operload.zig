const std = @import("std");

const Vector3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn new(x: f32, y: f32, z: f32) Vector3 {
        return Vector3 { .x = x, .y = y, .z = z };
    }
};

fn isVariable(comptime word: []const u8, comptime T: type) bool {
    return @hasField(T, word);
}

const ParserState = enum {
    Start,
    StartBinaryOp,
};

pub fn operload(comptime str: []const u8, args: anytype) Vector3 {
    _ = args;
    comptime {
        var state = ParserState.Start;
        var split = std.mem.split(u8, str, " ");

        while (split.next()) |word| {
            switch (state) {
                .Start => {
                    if (isVariable(word, @TypeOf(args))) {
                        state = .StartBinaryOp;
                    } else {
                        @compileError("We don't know how to handle that yet!");
                    }
                },
                .StartBinaryOp => {} // TODO
            }
        }
    }

    return undefined;
}

const expectEqual = std.testing.expectEqual;
test "simple addition" {
    const a = Vector3.new(0, 1, 0);
    const b = Vector3.new(0, 0, 1);
    const vec = operload("a + b", .{ .a = a, .b = b });

    try expectEqual(@as(f32, 0.0), vec.x);
    try expectEqual(@as(f32, 1.0), vec.y);
    try expectEqual(@as(f32, 1.0), vec.z);
}
