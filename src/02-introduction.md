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

In this chapter, our objective is to show \"Hello, World\" in the Zig
programming language.

We can start by declaring the main() function, the *main* function which
is run at the start of a Zig program.

```zig
pub fn main() void {

}
```

The syntax is quite simple, `fn main() void`. `void` shows the function
returns nothing. Finally, `pub` is necessary for a function to be
public, which means it can be used in other source files.

And finally, what we will put between `{` and `}` will be the code of
our function.

Making `main()` public (using `pub`) is necessary because the Zig standard
library, which is another source file will do *magic* in order to make your
`main()` function works. And in order to do that, it needs to access your
main function.

<div class="box-information">
Currently, the Zig compiler requires you to use spaces instead of tabs
and Unix line return (LF). On most editors, you can configure this in
the status bar (near the lower right-hand corner). If you use Notepad,
you can get a new editor like Notepad++ or Visual Studio Code, those are
free.
</div>

To see if this works, we must save this in a file, that could be named `hello.zig`.
Then we compile and run it using the `zig` command like the following:

```
$ zig run hello.zig
```

We can see that the program compiles but does nothing.
To print Hello World, we need to access the standard
output. First, we need to import the standard library using
`const std = @import("std");`. There, we declare a variable
(`const std = `) containing the standard library `@import("std");` Then,

From that, we can get `std.io.getStdOut().writer()` which allows
to use the **st**an**d**ard **out**put, this time we can put it in the
`main` function.

A writer is how you write data to a given destination (like a file, a network
stream, a terminal, ...) in Zig. Similarly, a reader allows to read data from a
given source.

```zig
const std = @import("std");

pub fn main() void {
    const stdout = std.io.getStdOut().writer();
}
```

Then we can use the `print()` function that can be used to write text.

```zig
pub fn main() void {
    const stdout = std.io.getStdOut().writer();
    writer.print("Hello, World\n", .{});
}
```

Note that `\n` is a line return, adding it is necessary so that we can write another line after it.

Now you can try to compile the program, but we get.. an error!

```
$ zig run hello.zig
./hello.zig:5:17: error: error is ignored. consider using `try`, `catch`, or `if`
stdout.print("Hello, World\n", .{});
```

This informs us that `print` may return an error and that we cannot
ignore it. That is because in Zig, errors are just values, the only
difference is, special handling for it was made in the language to
make it easier to handle them.

We can use `catch` to manually handle the error, for example, to print an
error message without stopping the whole program, but here we'll just stop
the program and return the error to the caller.

```zig
stdout.print("Hello World\n", .{}) catch |err| return err;
```

The `try` keyword allows us to shorten this into

```zig
try stdout.print("Hello World\n", .{});
```

We try to compile and we get..

```
$ zig run hello.zig
./hello.zig:5:5: error: expected type 'void', found 'std.os.WriteError'
try stdout.print("Hello, World\n", .{});
    ^
./hello.zig:3:15: note: function cannot return an error
pub fn main() void {
              ^
```

The note helps us here:
we need to declare that the function can return an error. For this, we
can use the `!void` syntax which handles this for us. Finally, we have

```zig
const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Hello, World\n", .{});
}
```

```
$ zig run hello.zig
Hello, World
```

The program now prints `Hello, World`.

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

```zig
const std = @import("std");

pub fn main() !void {
    const fahrenheit: f64 = 80; 
    const celsius: f64 = (fahrenheit - 32) / 1.8;

    std.debug.print("{}°F is {}°C", .{ fahrenheit, celsius });
}
```

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
