# Introduction

## Installing Zig

The book targets `master` version (until 1.0 releases)

Download the Zig compiler from the [ziglang.org website](https://ziglang.org/download/),
selecting the OS and architecture you use. For example`zig-windows-x86_64`
on Windows 64-bit.

Then, you need to setup your PATH variable.

- Windows

System wide (admin Powershell):

```powershell
[Environment]::SetEnvironmentVariable(
   "Path",
   [Environment]::GetEnvironmentVariable("Path", "Machine") + ";C:\your-path\zig-windows-x86_64-your-version",
   "Machine"
)
```

User level (Powershell):

```powershell
[Environment]::SetEnvironmentVariable(
   "Path",
   [Environment]::GetEnvironmentVariable("Path", "User") + ";C:\your-path\zig-windows-x86_64-your-version",
   "User"
)
```

- Linux, macOS and BSD

You can add an export line to your shell startup script (.profile, .zshrc, …)
by adding the Zig install directory to the `PATH` variable.

```sh
export PATH=$PATH:~/path/to/zig-folder
```

## Hello World

In this chapter, our objective is to show 'Hello, World' in the Zig programming language.

We can start by declaring the main() function, the *main* function which
is run at the start of a Zig program.  

In Zig, the program to print 'Hello, World' is 
```zig
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, World\n", .{});
}
```

Using the editor of your choice, write the above program in it and save it
to a file that ends in `.zig`, like `hello.zig`

In a new window, open a terminal (`cmd.exe` on Windows) then, compile and run it with this command
```
zig run hello.zig
```
the command then prints
```
hello world
```

On the first line `const std = @import("std")` imports the standard library (std) and puts its definitions in the constant `std`.

`pub fn main() void` defines a public function called `main` which takes no arguments (nothing between `()`) and returns nothing `void`.

And finally, what we will put between `{` and `}` will be the code of our function.
Our `main` function only has one statement: `std.debug.print("Hello, World", .{});`.
This statement tells the computer to call the function `print`, from `debug`, from `std` (the constant we imported).

# A deeper introduction

During this chapter, you will learn how does Zig handles basic management of your computer's memory.

## Variables

We already wrote variables in the last chapter, like `const stdout = std.io.getStdOut().writer();`

Except for a few special types, **all variables use a fixed number of bytes from the computer memory**.

This means all numbers use a fixed number of bytes.
For integers, that fixed number of bytes gives the maximum value of
a number. This is like if we had to write an integer in a limited
number of digits.

```zig
const a: i16 = -12345; // This is an integer that takes 16-bit
const b: i16 = 60000;  // This value is too large to fit in 16-bit and will make a compile error,
// So we can increase the bit size:
const c: i32 = 60000;  // yay!
```

There's also another trick to save on bytes: unsigned integers.

This means it can only store positive values

```zig
const a: u16 = 60000; // works
const b: u16 = 0;     // works
const c: u16 = -12;   // error!
```

In a sense, setting the bit size for your integer is like asserting that it will never go above the maximum value
and that it will never go below the minimum value.

<div class="box-information">
- For a signed number, if $n$ is the number of bits, the maximum value is $2^{n-1}-1$
while the minimum value is $-2^{n-1}$.
- For an unsigned number, the maximum value is $2^n-1$ and the minimum is always 0.

Example: the maximum value of a `u16` is $2^{16}-1 = 65535$

</div>

As a good default, you can just use `u32` and `u64` (unsigned) or `i32` and `i64` (signed).

## Floating point numbers

We want to swim but don't want to get cold. Fortunately,
we've got a thermometer that we put in the pool. But too bad, it gives results
only in Fahrenheit ! To avoid diving in too cold water, we could write a
program that can convert from Fahrenheit to Celsius degrees.

With a [quick search](https://en.wikipedia.org/wiki/Fahrenheit) we can
find the computation we need to do that: we substract 32 and divide by 1.8

However, 1.8 is not an integer :O !

To represent other numbers, there is what's called floating point numbers.
It's what's used when you write `var a = 1.8` in JavaScript. For our
temperatures, we can use something like `f64`. The `f` means it is a floating
point number, and `64` means it uses 64 bits.

```zig
const std = @import("std");

pub fn main() !void {
    const fahrenheit: f64 = 80;
    const celsius: f64 = (fahrenheit - 32) / 1.8;
}
```

The program is really simple to understand, `const fahrenheit: f64 = 80;`
is like how we defined variables before, except we added '`:f64`' which
says we want this variable to be an `f64`.
And then `(fahrenheit - 32) / 1.8` does the operation we described above.

## Printing numbers

The only thing left is printing the resulting value.

<div class="zig-example">
    const std = @import("std");

    pub fn main() !void {
        const fahrenheit: f64 = 80; 
        const celsius: f64 = (fahrenheit - 32) / 1.8;

        std.debug.print("{}°F is {}°C", .{ fahrenheit, celsius });
    }
</div>

Using `std.debug.print` here is much shorter than using `std.io.getStdOut()`,
it also assumes we don't care if we can't show our text and will not error in
that case.

Here, `{}` is used to say we want to print the corresponding value we passed
in the `.{ fahrenheit, celsius }` argument. This way, the first `{}` gets
the first argument which is `fahrenheit` and the second `{}` gets the second
argument which is `celsius`.

Running the program gives us

```
8.0e+01°F is 2.66666679e+01°C
```

> Woops, looks like the result is in scientific notation :/

By default, Zig prints floating point numbers in scientific notation.

The `std.debug.print` function we use actually works using `std.fmt.format` underneath.

Looking for this function in [the standard library source code](https://github.com/ziglang/zig/blob/master/lib/std/fmt.zig#L27) which is easy to read and very useful, we find this:

```md
Renders fmt string with args, calling output with slices of bytes.
If `output` returns an error, the error is returned from `format` and
`output` is not called again.

The format string must be comptime known and may contain placeholders following
this format:
`{[argument][specifier]:[fill][alignment][width].[precision]}`

Each word between `[` and `]` is a parameter you can replace with something:
- *argument* is either the index or the name of the argument that should be inserted
- *specifier* is a type-dependent formatting option that determines how a type should formatted (see below)
[...]
- *precision* specifies how many decimals a formatted number should have

The *specifier* has several options for types:
[...]
  - `e`: output floating point value in scientific notation
  - `d`: output numeric value in decimal notation
[...]
```

This mean to get decimal notation, we can just use `{d}` in our program:

```zig
const std = @import("std");

pub fn main() !void {
    const fahrenheit: f64 = 80;
    const celsius: f64 = (fahrenheit - 32) / 1.8;
    const stdout = std.io.getStdOut().writer();

    try stdout.print("{d}°F is {d}°C", .{ fahrenheit, celsius });
}
```

The result is:

```
80°F is 26.666667938232422°C
```

Great!

Looking back at [the standard library source code](https://github.com/ziglang/zig/blob/master/lib/std/fmt.zig#L27),
we see we can use `precision` to round our number.
The change is as simple as using `{d:.1}` instead of `{d}`.

Which rounds the number and gives us:

```
80°F is 26.7°C
```
