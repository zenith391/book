# Loops

## While loop

The `while` loop is very similar in Zig to other languages, it's used this way:

```zig
while (condition) {
    // Do something..
}
```

where `condition` is a `bool` value (`true` or `false`).
The following comparisons can be done and give a `bool` value:

| Condition | Meaning                                  |
| --------- | ---------------------------------------- |
| `a == b`  | Tests equality between two values        |
| `a != b`  | Tests inequality between two values      |
| `a > b`   | `true` if `a` is higher than `b`         |
| `a >= b`  | `true` if `a` is higher or equals to `b` |
| `a < b`   | `true` if `a` is lower than `b`          |
| `a <= b`  | `true` if `a` is lower or equals to `b`  |

Operators on `bool` values:

| Condition | Meaning                                                                                                      |
| --------- | ------------------------------------------------------------------------------------------------------------ |
| `a and b` | `true` if both `a` and `b` are equal to `true`                                                               |
| `a or b`  | `true` if either `a` or `b` is equal to `true`                                                               |
| `!a`      | [NOT](https://en.wikipedia.org/wiki/Inverter_(logic_gate)): `true` if `a` is `false`, `false` if `a` is true |

For example:

```zig
var a: u32 = 9;
var b: u32 = 42;
while (b > a) {
    a += 1;
    b -= 1;
}
std.debug.print("Results are {} and {}\n", .{ a, b });
```

which will substract 1 from `b` and add 1 to `a` while `a` is higher than `b`

As `bool` are just regular values, we can also save them in variables:

```zig
const boolean = computeOneValue() > computeOtherValue();
std.debug.print("is one > other ? {}\n", .{ boolean });
```

## For loop

The `for` loop in Zig acts more like a for-each loop, that is it iterates over each
element of an array or a slice.

For example we can translate the following Javascript code:

```js
var items = [ 124, 135, 12, 95423, 10 ];
for (var item of items) {
    console.log(item);
}
```

to the following Zig code:

```zig
var items = [_]u32 { 124, 135, 12, 95423, 10 };
for (items) |item| {
    std.debug.print("{}\n", .{ item });
}
```

However, in the style of having only one *obvious* way to do things in Zig, the C-style for loop is absent:

```c
for (int i = 0; i < 10; i++) {
    printf("%d\n", i);
}
```

intuitively, it should be translated to:

```zig
var i: u32 = 0;
while (i < 10) : (i += 1) {
    std.debug.print("{}\n", .{ i });
}
```

Here, the instruction in parentheses after the while loop (`(i += 1)`) is executed at the end of each
loop.