# bad writing graveyard

Memory - Variables:

Imagine, because we have limited space on our desk, we use in a tiny screen
which can only show up to 4 digits, it's easy to guess our maximum number
is 9999. This would work to show a tiny number like the number of
notifications you have on a phone. If we used a signed number, using
the same space, the maximum and minimum would be +999 and -999.

However we can't use it to show the world population (\~8 billion),
so we can use again the smallest screen, but that is able to fit a number
like 8 billion, which would be a screen with 10 digits. We don't need 11
digits as we know the world population cannot be negative. (it wouldn't
make any sense), thus we saved on some space!

And like this we did the exact same process as thinking about how many bytes a
number should have.

In practice, the number of digits is replaced by the number of bits.
The maximum and minimum value, like in the above analogy, depend on
whether it is a signed or an unsigned number.

# TODO

utilité erreur "unused variable":
you copy-pasted a test case:

```zig
var rect = Rect(.{ .color = Color.blue });
std.testing.expectEqual(Color.blue, rect.color);

var rect2 = Rect(.{ .color = Color.yellow });
std.testing.expectEqual(Color.yellow, rect.color);
```

This looks perfectly fine to run! Except not, we did a typo (`rect` instead of `rect2`) and the test will fail,
Zig avoids this by making unused variables an error, it can feel like a pain, but it can save you from a lot of
bugs like this.

