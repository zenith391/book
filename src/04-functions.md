# Functions

**This chapter needs serious rewrite.**

Now as you may know, it is often much better to break parts of the code that we'll use
often into functions.

For this, we use the same syntax we used for our main function:
here take our Fahrenheit to Celsius proram and turn the conversion into
a function:

```zig
fn fahrenheitToCelsius(fahrenheit: f32) f32 {
    return (fahrenheit - 32) / 1.8;
}
```

Parameters, like variables, have a name, `:` and then the type of the parameter. So here we say
we accept a `fahrenheit` parameter that MUST be an `f32`.

This contrasts with dynamic language (think Javascript or Python) where often you have to
check the correct type yourself which can be tiresome and error-prone (which is
why languages like TypeScript where made). Enforcing a paremeter's type is called static
typing. So we can say Zig is a statically typed language.

We can call a function using the usual parentheses syntax:

```zig
const celsius: f32 = fahrenheitToCelsius(80.0);
```

As there is no Object prototypes or operator overloading, the only way something can call
a function is with `theFunction()` syntax. This can help a lot in reading code by not
having to keep the mental overhead of what is overloaded, what's inherited by a class,
what prototype is it.

## Error handling in functions

error sets, `errdefer`, ...
...