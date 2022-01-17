const std = @import("std");

fn convertTemperature(temperature: *f32) void {
    temperature.* = (temperature.* - 32) / 1.8;
}

pub fn main() !void {
    var temperature: f32 = 80.0;
    convertTemperature(&temperature);

    std.log.info("{d}°C", .{ temperature });
}