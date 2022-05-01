<figure>
    <img src="https://raw.githubusercontent.com/ziglang/gotta-go-fast/master/zigfast.png"
        style="max-width: 800px;">
    <figcaption>Zig gotta go fast</figcaption>
</figure>

English version | Version française (à faire)

# Foreword

ZIG: Zig Isn't Gnu

This book targets people who already have experience programming in other
languages. Having experience in a systems programming language like C or
Rust can help but having something like intermediate level in Python is
enough to understand the book's concepts.

Being that the book is still very early, **if you have feedback, please tell me**
(you can send me a message on my Discord Zen1th#3854)

Complementary (free) material you might also want to use to learn Zig:

- [The language reference](https://ziglang.org/documentation/master/) which is of an awesome quality
- [Ziglearn](https://ziglearn.org) bare introductions in bullet list style
- [Ziglings](https://github.com/ratfactor/ziglings), like Rustlings but for Zig
- [Reading the standard library](https://github.com/ziglang/zig/tree/master/lib/std) because
  it is really well written and serves as an example for many concepts and conventions in Zig.
- [Zig examples](https://github.com/Mouvedia/zig-examples/blob/main/zig.html.markdown)
- [Zig by example](https://zig-by-example.com/)

# Zig, Why?

TODO

The Road To Zig 1.0: [https://www.youtube.com/watch?v=Gv2I7qTux7g](https://www.youtube.com/watch?v=Gv2I7qTux7g)

There is also the [Zig's Zen](https://ziglang.org/documentation/master/#Zen) which is a set of ideals for the
language.

One 'disclaimer' I would like to say, there is one aspect of [Zig's Zen](https://ziglang.org/documentation/master/#Zen)
that will probably need time for you to adapt:

- Favor reading code over writing code.

This manifests in more verbose syntax and things like `usingnamespace` not being like other languages
`using namespace` (like in C++) in order to actually avoid those bad patterns that hurt readability by
favoring writing code (for example, having `using namespace std;` is considered bad practice in C++). It
also manifests in unused variables being errors, which can be sometimes feel irritating, sometimes feel
wonderful as it uncovers a bug.  
So if you're coming to Zig, remember, favor reading code over writing code.
