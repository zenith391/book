
# The Zig, the String, and the Unicode

Now, one concerning fact about Zig is that strings are plain slices of bytes, which
means iterating over a string will actually iterate over bytes!

Does Zig not have support for UTF-8 ?

Well yes, and no. Zig has decided not to treat strings specially because really, there
is no correct way to do it.

For example, for iterating over a string, you might expect to iterate over a number of
characters? Problem is Unicode doesn't even define what a character is, and it might
range from a single byte to an entire
[grapheme cluster](https://www.unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries).
For example, take
`"👩‍👦‍👦"`, what we see as a single character is actually made out of **5 codepoints**
(U+1F469 U+200D U+1F466 U+200D U+1F466) and each should be correctly preserved otherwise
we end up with a different emoji!

So, if your language has built-in Unicode support, what should it do ? Iterate over
codepoints ? over grapheme clusters ? What if I want to iterate through all of them ?
Is the Unicode table defining grapheme clusters (separators, joiners, etc.) always updated ?
That's why Zig leaves Unicode as something for standard library and other libraries to handle.

A simple example of thinking strings are simple and failing catatrosphically is JavaScript,
the programming language supposed to handle strings, but where `"👩‍👦‍👦".length` is equals to 8 !!
In almost all cases this is not the intented behaviour when getting a string's length. 
So really Javascript (and most languages that supposedly handle strings) trick you into believing
your code will work intuitively when in fact, human language is just complicated. Hence why,
like for many things, Zig wants you to think about what you want in order to get a correct behaviour.

For basic string manipulation, you'd look at `std.mem` and `std.ascii`, `std.mem` contains
useful functions like `indexOf` or `replace` while `std.ascii` contains ASCII-specific functions
(as its name suggests).

<div class="box-information">
The reason the namespace is `std.mem` and not not `std.string` is because thanks to generic
functions (see [Understanding Zig's comptime]) it also works on slices of any integer types.
So you can do `indexOf` on a `[]u32` without recoding it.
</div>

For Unicode-y things, you can use.. `std.unicode`. It contains methods for iterating over
[codepoints](https://en.wikipedia.org/wiki/Code_point), for encoding and decoding UTF-16 and UTF-8.

```zig
const str = "Forêt UTF-8 ⚡";

// it returns an error if 'str' is not valid UTF-8
var view = try std.unicode.Utf8View.init(str);
var iterator = view.iterator();

while (iterator.nextCodepoint()) |codepoint| {
    std.debug.print("{c}", .{ codepoint });
}
```

TODO: speak about string normalization and letter + accent instead of accented letter

Finally for more complex things, this is where Zig will need an external library, like many other
languages (yes, even those with that advertised Unicode support), notably for normalization which is
**very important** before storing a string because turns out a character can have multiple Unicode
representations, for *correctly* upper-casing or lower-casing a string which is complex because turns out
English isn't the only language in the world, and that letter case isn't universal (think Chinese), etc.

Zig currently has a good library for that, named [ziglyph](https://github.com/jecolon/ziglyph) it bundles
all needed Unicode data (thanks to comptime) and makes correct behaviour for Unicode characters.
It should be used for separating strings into grapheme clusters (necessary for most
[emojis](https://tonsky.me/blog/emoji/)) or string order, whether it's ascending or descending.

But really, in most cases, you should reconsider whether you really want to do those string operations
because, often, they [don't make sense in other languages](https://utf8everywhere.org/#myth.strlen).  
In fact, even with support for grapheme clusters there can be problems.
Think about "œ" (used in languages like French), it's one grapheme but two characters, yet you would
expect the reverse of "œuf" to be "fueo" (which would need special handling, imagine that for all
the characters in the world..) if we reverse it again, we get "oeuf" which, linguistically, isn't the
same word. So even in Latin languages, those job interviews string problems cause problems.

To conclude I'll ask you: what's the upper casing of नमस्ते👩‍👦‍👦שָׁלוֹם ?
