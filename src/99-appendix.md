# Appendix

## Standard Library

### About strings

In Zig, strings are only assumed to be byte slices (`[]const u8`). This doesn't mean Zig programs can't support UTF-8, nor that there are no Unicode functions in the standard library.

### Concatenating strings
```zig
// Any strings you want to concatenate
const a = "Hello";
const b = ", ";
const c = "World";

const hello = try std.mem.concat(u8, allocator,
	&.{ a, b, c }); // any number of strings
```

### Check valid UTF-8
```zig
fn doSomeStringThings(str: []const u8) void {
	std.debug.assert(std.unicode.utf8ValidateSlice(str));
	// do some stringy thingy
}
```

### List codepoints
```zig
var view = try std.unicode.Utf8View.init("¡Hola!");
var iterator = view.iterator();
while (utf8.nextCodepointSlice()) |codepoint, index| {
  std.debug.print("codepoint #{}: {}\n", .{ codepoint, index + 1 });
}
```
