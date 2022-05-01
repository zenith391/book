# Proper input and output

## Reader

### Improving upon our converter program

...

std.io.readUntilDelimited, std.fmt.parseFloat

# Understanding Zig's comptime

One of Zig's particularities is that it brings a new concept called compile-time code
execution. To use this, we simply tell Zig that we want to execute some specific functions
when the code is being compiled. So that when we compile the code, code is executed and we
can use what it returned as constant data.

For example, the standard library uses this simple concept to make [generics](https://github.com/ziglang/zig/blob/master/lib/std/array_list.zig) and [type-erased functions](https://github.com/ziglang/zig/blob/master/lib/std/math.zig#L472) and you too will be able to do so later in this chapter.

<div class="box-information">
Something that is known at compile-time simply means it can be entirely computed during
the compilation without depending on anything external to it. Basically, this
means that if you read a file or look up google.com, it is NOT known at compile-time.
</div>

Compile time code execution can be divided in a few core concepts:

## A type is just yet another variable

As you know, in Zig every variable has an unchangeable type
that is kept throughout its whole lifetime. For example when declaring `const a: u32 = 0`,
`u32` is the variable's type.

Now the new thing is that the type of `u32` would simply be `type`,
type of `f64` would also be `type`, etc.

In practice, this means that we can store types in constants:

```zig
const MyFavouriteInteger = u32;
```

The only constraint is that it MUST be known at compile time.
This means the below code would NOT work:

```zig
var someValue = computeThings();
var MyType: ?type = null;

if (someValue < 10) {
    MyType = u32;
} else {
    MyType = bool;
}
```

However, we can make it depend on compile-time known values:

```zig
const someValue = 5;
const MyType = if (someValue < 10) u32
    else bool;

var someVariable: MyType = undefined;
```

Here, `someValue` is known to be 5 at compile-time, so the compiler replaces

```zig
const MyType = if (someValue < 10) u32
    else bool;
```

with

```zig
const MyType = u32;
```

and so `someVariable` will be a `u32`.

And then it can be used like anything else!

```zig
var someInt: MyType = 5; // this will be a 'u32' variable
```

## You can execute functions at compile-time

<div class="box-information">
For short, you can say comptime instead of compile-time.
</div>

The second concept is that functions can be executed at compile-time
as long as its arguments are known during comptime. If it's the case
we can just add `comptime` to the function call:

```zig
fn factorial(x: u32) u32 {
    if (x == 0) return 1;
    return x * factorial(x - 1);
}

const result = comptime factorial(5);
if (result != 120) {
    @compileError("Mathematics just broke.");
}
```

Here, as we explicitely said to execute it at compile-time using `comptime`, the
`factorial` is executed during compilation. If we remove `comptime`, it would
still be executed at compile-time if the compiler finds it's necessary.

What this means in practice is that in the final executable, there won't be any code
for computing the [factorial](https://en.wikipedia.org/wiki/Factorial) of 5, instead it will be like if we replaced

```zig
const result = comptime factorial(5);
```

with

```zig
const result = 120;
```

The major difference is that we keep the convenience of calling `factorial`
so we explicitely know it's `factorial(5)` and not some magic `120` value.

This also means if one day we want to change the value, it's much easier. For small
things like that it might not matter much, but this feature can be extended to generate
**entire images** in compile-time, and there it's much better to easily tweak parameters.

Another interesting part is

```zig
if (result != 120) {
    @compileError("Mathematics just broke.");
}
```

Now this simply means that if factorial of 5 is not equals to 120, we make a
compile error.

Also, given the value only needs to be known at comptime, we can do something like

```zig
const result = comptime factorial(factorial(3));
```

This will find that factorial(3) = 6 and that factorial(6) = 720, so this will be replaced with

```zig
const result = 720;
```

Something as simple as that would better be replaced with Zig testing (coming soon chapter)
but there are major cases where it can be used:

```zig
const builtin = @import("builtin");

fn doSomeAppleThing() void {
    if (!builtin.os.isDarwin()) {
        @compileError("You're not compiling for Apple platform >_<");
    }
    // we can now be bare Metal, pun intended
}
```

If we call this function and try to compile the program for Windows, the compiler will
show an error: You're not compiling for Apple platform >\_<

What's happening is that we called the `isDarwin()` function (which returns false if
if we're not compiling for iOS, macOS, and others) and we were able to make a compile error
out of it.

When defining a function, you might also want to declare a parameter as
`comptime`, this as the effect to force the parameter to be known at
compile-time, and if it is not possible, the compiler will simply output an error.

## What can be done with it

From all the above points, we can easily make something like this:

```zig
pub fn MyType(comptime OtherType: type) type {
    return struct {
        pub fn returnValue(value: OtherType) OtherType {
            return value;
        }
    }
}
```

Admitedly, this `returnValue` function is not very useful, but the above code
already shows quite a few things:

- We defined a function `MyType` that takes a `type` as input and returns another
  `type`. The type we take as argument can be anything, and we return a struct from
  the function.
- We can use `OtherType` argument like an `u32`, an `f64`, those are types and so is
  `OtherType` !

We can make something more useful, like a basic list:

```zig
pub fn List(comptime T: type) type {
    return struct {
        items: []T,

        const Self = @This();

        pub fn get(self: *Self, index: usize) T {
            return self.items[index];
        }
    }
}
```

As said above, we can use our type parameter (which here is named `T`) as any other type,
so we use it to declare a field `items: []T`. The `get` function is also simple. What's
worth noting is the `@This()`. It simply returns the type we're in. As can be seen,
we're making a struct type, so `@This()` references the struct type. For example,
you can think of `const Self = @This()` as `const Self = List(T)`.

Then using allocators you saw in the 'More Memory' chapter, we can make a simple array list:

```zig
pub fn ArrayList(comptime T: type) type {
    return struct {
        items: []T,
        allocator: *Allocator,

        const Self = @This();

        pub fn append(self: *Self, value: T) !void {
            // We expand our item list
            self.items = try self.allocator.realloc(items, items.len + 1);

            // And we set the newly allocated space to the new value
            self.items[self.items.len - 1] = value;
        }
    };
}
```

And we can add an init function to make it easier to use:

```zig
pub fn init(allocator: *Allocator) Self {
    return Self {
        .allocator = allocator,
        .items = allocator.alloc(T, 0) catch unreachable // can't fail as we're literally allocating no memory
    }
}
```

And like this, we can use it as any other type:

```zig
var list = ArrayList(f64).init(allocator);
try list.append(6.3);
```

We can even put the result in a constant:

```zig
const MyList = ArrayList(f64);

var list = MyList.init(allocator);
try list.append(6.3);
```

Of course, this list could be made much better, but it's great as an overview of how "generics" like
`std.ArrayList` and other types actually work.

`type`, `anytype`, ...

## (Huge) Practical example: coding an operation parser

Now, you know Zig doesn't have operator overloading for entirely valid reasons, but when
implementing vector maths or trying to use matrixes, it can quickly become a parentheses
hell bringing among the oldest Lisp-nam war flashbacks and PTSD (`a.add(b.mul(c.normalize().add(d)))`).

Now the task we're gonna do is complicated and hard to think about, but the day you fully
understand that, you know the power of compile-time code execution.

As we know, `std.fmt.format` parses the format string at compile-time, so here we can
take a try at extending the language using comptime !

Our end goal is being able to write something like

```zig
operload("a + ( b * ( normalize c + d ) )",
    .{ .a = a, .b = b, .c = c, .d = d });
```

For simplicity, we will not take care of operator precedence (the fact that we
do multiplications first and then we do additions) in order to make parsing simpler given
it's not the main topic here.

We can quickly devise a parser where the root node is an Expression.

An expression can be either an unary operation (like `normalize c`) or a binary
operation (like `a + ( b * ... )`).

For that we can build a simple state machine that will match for every word:

- If we encounter an operator, this means we're at the start of an unary
  expression, so we parse the next expression and make that.
- If we encounter a variable, this means we're at the start of a binary
  expression (`a`), so we parse the following operator (`+`) and the following
  expression (`b`) to get `a + b`.

We'll also store a list of comptime 

So we can start coding,

```zig
// for now, we will assume the end result is a Vector3
pub fn operload(comptime str: []const u8, args: anytype) Vector3 {

}
```

First we'll start by splitting our input word by word (if we were doing actual parsing,
we wouldn't do that):

```zig
pub fn operload(comptime str: []const u8, args: anytype) Vector3 {
    comptime {
        var split = std.mem.split(u8, str, " ");
        while (split.next()) |word| {

        }
    }
}
```

And we can fully make it a state machine:

```zig
const ParserState = enum {
    Start,
    StartBinaryOp,
};

/// Returns whether 'word' corresponds to a variable defined in 'args'
fn isVariable(comptime word: []const u8, comptime T: type) bool {
    return @hasField(T, word);
}

pub fn operload(comptime str: []const u8, args: anytype) Vector3 {
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
}
```
