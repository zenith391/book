# Pointers

**This chapter needs serious rewrite.**

We have a slice of some temperatures we want to convert to Celsius:

```zig
const temperatures = &[_]f32 { -40, 37.5, 100, 50 };
for (temperatures) |fahrenheit| {
    const celsius = convertTemperature(fahrenheit);

}
```

It's good to have values, so, let's try editing a value in a function:

```zig
fn convertTemperature(temperature: f32) void {
    temperature = (temperature - 32) / 1.8;
}
```

We can try calling it with

```zig
var temperature: f32 = 80.0;
convertTemperature(temperature);
```

And.. we get an error:

```
./example.zig:4:38: error: cannot assign to constant
    temperature = (temperature - 32) / 1.8;
```

It'd be nice if we could tell the function that we need to edit the variable in itself, not it's value. Right?

Well that's exactly what pointers do. It is the address to the value (which is what
a variable actually is).

[diagram of a computer memory, showcasing pointers as just addresses]

Zig has quite a few pointer types (where T is any type):

- `*T` is a pointer to a variable, this means we can ~~mutate~~ change the variable as much a we want, and the change will be correctly applied!
- `*const T` is a pointer to a *constant* value. This can be useful for large sized structs,
  as a pointer is only 64-bit on a 64-bit machine, and 32-bit on a 32-bit machine. Yes, that's
  what those bits are!

So let's update our example:

```zig
fn convertTemperature(temperature: *f32) void {
    temperature.* = (temperature.* - 32) / 1.8;
}

var temperature: f32 = 80.0;
convertTemperature(temperature);
```

`temperature.*` is called de-referencing a pointer. We know the *point*er is *point*ing to
a value, so dereferencing is used to get the value.
Thanks to the fact it's a pointer, we can edit the value in it with `temperature.* = ...` !
