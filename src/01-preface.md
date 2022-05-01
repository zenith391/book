<figure>
    <img src="https://raw.githubusercontent.com/ziglang/gotta-go-fast/master/zigfast.png"
        style="max-width: 800px;">
    <figcaption>Zig gotta go fast</figcaption>
</figure>

English version | Version française (à faire)

# Preface

Today, computers are faster than ever. You can have a computer a thousand times more powerful than 1980s' that fits in your pocket. Yet, instead of seeing a trend where all software get faster and nobody has to wait for a software to compute, processing time stalled. It even increased, Windows ~~10~~ 11 can take half a minute to start, much more than Windows 95 computers. It's not like Windows 11 has a thousand times more features than Windows 95, yet it is much slower. Why ?

The reality is simply a mix of laziness and deadlines to respect, why the heck would you bother optimizing your software from the get go? You'd just miss your deadline.  After all, the saying goes that 'premature optimization is the root of all evil'. And besides, if the customer is unhappy, can't he pay a little more for making the software faster? Really, most customers got accustomed to slow software anyways.

And that's how software development split into two worlds: web technologies, faster to develop for, horrible performance, which is used my almost all applications we use today due to reasons said above. And native applications, notorious for being hard to grasp, slowing development, and requiring people competent in that domain, which is losing terrain more and more, except for the most performance-critical applications.

There has been attempt for fast high-level languages, like Julia. But by removing access to actually controlling the computer, you lose opportunity to make your algorithms just run faster. Hence, the usage of C, C has been around since the 1970s and won't disappear anytime soon, but C trusts the developer too much: no runtime safety, macros, which are the biggest advantage and disadvantage of C, weird undefined behaviour (signed overflow is defined, unsigned overflow isn't :/) ...

Hence why I turned to the Zig programming language. It removes many footguns from C and introduces error sets, instead of exceptions and error codes. It introduces comptime, instead of magic values and additional compilation steps. Yet the language also feel simpler, because you don't have to write in two languages (macros and C) and because some concepts naturally emerge from simpler mechanics, like generics that naturally come from comptime and types as values.

Now, this book won't teach you introductory programming knowledge, it assumes familiarity with concepts like variables, functions and loops. It will mostly teach you about Zig, obviously, but also about how memory works and what are allocators.

Being that the book is still very early, **if you have feedback, please tell me**
(you can send me a message on my Discord Zen1th#3854)

Complementary (free) material you might also want to use to learn Zig:

- [The language reference](https://ziglang.org/documentation/master/) which is of great help
- [Ziglearn](https://ziglearn.org) with just bare introductions in bullet list style
- [Ziglings](https://github.com/ratfactor/ziglings), like Rustlings but for Zig
- [Reading the standard library](https://github.com/ziglang/zig/tree/master/lib/std) because
  it is well written and serves as an example for many concepts and conventions in Zig.
- [Zig examples](https://github.com/Mouvedia/zig-examples/blob/main/zig.html.markdown)
- [Zig by example](https://zig-by-example.com/)

## Zig, Why?

TODO

The Road To Zig 1.0: [https://www.youtube.com/watch?v=Gv2I7qTux7g](https://www.youtube.com/watch?v=Gv2I7qTux7g)

There is also the [Zig's Zen](https://ziglang.org/documentation/master/#Zen) which is a set of ideals for the
language.

One 'disclaimer' I would like to say, there is one aspect of [Zig's Zen](https://ziglang.org/documentation/master/#Zen)
that will probably need time for you to adapt:

- Favor reading code over writing code.

This manifests in more verbose syntax and things like `usingnamespace` not being like other languages `using namespace` (like in C++) in order to actually avoid those bad patterns that hurt readability by favoring writing code (for example, having `using namespace std;` is considered bad practice in C++). It also manifests in unused variables being errors, which can be sometimes feel irritating, sometimes feel
wonderful as it uncovers a bug.
So if you're coming to Zig, remember, favor reading code over writing code.
