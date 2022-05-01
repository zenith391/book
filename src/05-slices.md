

# Slices

**This chapter needs serious rewrite.**

You may have noticed that Zig does have a syntax for arrays `[N]T` (where `N` is a number and
`T` a type) like `[100]u32` for 100 integers.

Cool, but real apps manipulate data that may have any size, right?

In C and Zig, arrays are fixed size as they are represented just as a lot of variables.
Meanwhile, slices are, like they name indicate, the slice of an array.

```
var array = [5]u8 { 1, 2, 3, 4, 5 };
var slice = array[0..5];
```

## Strings

Strings are just slices of `u8`. They're usually encoded with UTF-8 but in theory nothing forces them to be.
