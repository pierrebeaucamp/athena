---
title: Formally proving FizzBuzz
date: 2018-04-15
description: A dependently typed FizzBuzz solution using F-Star
...

As long as I can remember, my passion for programming was driven by learning how
to write "better" programs. At the beginning, this was writing programs more
elegantly, then it was about writing more performant programs - but for the last
three years, I've been obsessed with writing bug free programs. This led me down
a rabbit hole of functional programming, proof assistants and lots of very
interesting math.

I came to the realization that the closest method to write "correct" software is
by leveraging dependent types - thanks to Curry-Howard. However, this is still
very novel way of programming, or at least it doesn't have much of a following
outside academia. This makes it very hard to pick it up and learn. So altough
I'm far from an expert in this field and I still have a lot to learn, I decided
to write this article. I hope that it sparks some interest about dependent types
(or type systems in general) in people who might not be used to this concept. I
would love to see more languages adapt stronger type systems, so we can have
stronger correctness guarantees in our Software.

In this article, I want to implement the classic "FizzBuzz" problem in F-Star.
I'm currently using F-Star because I want to experiment with some of its
libraries, but the same concept should be applicable to any language with
dependent types. I can also wholeheartedly recommend Idris since it's currently
gaining a lot of popularity.

The reason why I picked "FizzBuzz" is that it is a very boring algorithm which
is trivial to implement in any language. The focus here is less on writing the
program itself, but more on proving its correctness using the type system.

Coming from imperative languages, my usual approach to writing programs would be
to start with a `main` method and then add step after step until the program
achieves what it needs to. Then, I'd see if I can refactor anything and would
call it a day.

Unfortunately, this approach leads you to no-where when trying to prove
software. This is because your implementation of a given problem might change
drastically when you express it using proper types. Instead, the approach which
works best for me is "Type Driven Development" (a concept named by Edwin Brady).
This means, we start by defining the types of our program. With the proper types
in place, the actual implementation becomes trivial.

To find the type of "FizzBuzz", let's read through the problem statement first:

> Write a program that prints the numbers from 1 to 100. But for multiples of
three print “Fizz” instead of the number and for the multiples of five print
“Buzz”. For numbers which are multiples of both three and five print “FizzBuzz”.

A first approach to the type of a "fizzbuzz" function might look like this:

```fs
val toFizzbuzz: int -> string
```

That is, "toFizzbuzz" is function taking an integer and returning a string. But
what do we infer from this? Well, not much actually. If you think about it, this
is only marginally better than no types at all, because the function would be
correct by returning *any* string for *any* integer. So if the implementation
of "fizzbuzz" would take `-3` as its argument and returns `Hello World`, it
would still be correct, as per its type.

So as you might have guessed, the goal to write a "correct" fizzbuzz program is
to refine the types in such a way that the function _only_ accepts valid inputs
and returns _only_ valid outputs.

Let's try another approach. This time, we use sum types to restrict our output
a bit more:

```fs
type fizzbuzz =
  | Int      : int -> fizzbuzz
  | Fizz     : fizzbuzz
  | Buzz     : fizzbuzz
  | FizzBuzz : fizzbuzz

val toFizzbuzz: int -> fizzbuzz
```

In this example, we first define a custom type, called "fizzbuzz". Values of
this type are either an integer, or one of the enums "Fizz", "Buzz", or
"FizzBuzz".

This is already a bit better. We can see that our function takes an integer and
returns either another integer, "Fizz", "Buzz", or "FizzBuzz". However, we still
have a similar problem as before: Judging from the type alone, the function
could return wrong results. I.e. we could call it with `13` and it returns
`Buzz`.

This is were dependent types can help us: We can make the type of the return
value dependent on the value of our argument, thanks to type level functions:

```fs
type fizz     = | Fizz     : fizz
type buzz     = | Buzz     : buzz
type fizzbuzz = | FizzBuzz : fizzbuzz

val getFizzbuzzType: int -> Type0
let getFizzbuzzType n =
  if (n%15=0) then fizzbuzz
  else if (n%5=0) then buzz
  else if (n%3=0) then fizz
  else int

val toFizzbuzz: n:int -> (getFizzbuzzType n)
```

Let's break this down:

First we define three individual types: `Fizz`, `Buzz` and `FizzBuzz`. Then, we
write a function which takes an integer as its argument and returns the
correct type. We can actually call this function from the type annotation of
`toFizzBuzz` to calculate the right type depending on its argument.

So now, without knowing the implementation of `toFizzbuzz` itself, we know that
it takes a number and returns "fizz" if it's a multiple of three, "buzz" if it's
a multiple five and so on. However, we still have one edge-case that we didn't
proof: We know that given a number which isn't a multiple of either three, five
or both, we return another number - but we didn't specify that it is indeed the
same number. I.e. the implementation of our function could still have a bug
which lets it return `3` after being called with `7`.

Unfortunately, we cannot easily specify this case in our type system. In this
case, we have to fall back to prooving the actual implementation of `toFizzbuzz`.

```fs
let _ = assert (forall n. n%3>0 && n%5>0 ==> toFizzbuzz n = n)
```

This is pretty similar to how you would write a unit test, however instead of
asserting one specific pair of arguments and results, we assert the correctness
of the result *for all* inputs which are not multiples of three or five.

At this point, we can rest assured that no matter how we decide to implement
our fizzbuzz function, it will always be correct. One implementation might look
light this:

```fs
let toFizzbuzz n =
  if (n%15=0) then FizzBuzz
  else if (n%5=0) then Buzz
  else if (n%3=0) then Fizz
  else n
```

As you can see, "FizzBuzz" is not really that exciting of a problem to proof. As
the algorithm is very trivial, the implementation and the type function look
nearly identical. This method of writing correct function really shines when
an implementation becomes non-trivial and might hide edge-cases which are easily
overlooked.

What follows is the complete code, including a `Main` function which applies our
`toFizzbuzz` function to a list of 1 to 100 and prints out the result.

```fs
type buzz     = | Buzz     : buzz
type fizzbuzz = | FizzBuzz : fizzbuzz

val getFizzbuzzType: int -> Type0
let getFizzbuzzType n =
  if (n%15=0) then fizzbuzz
  else if (n%5=0) then buzz
  else if (n%3=0) then fizz
  else int

val toFizzbuzz: n:int -> (getFizzbuzzType n)
let toFizzbuzz n =
  if (n%15=0) then FizzBuzz
  else if (n%5=0) then Buzz
  else if (n%3=0) then Fizz
  else n

let _ = assert (forall n. n%3>0 && n%5>0 ==> toFizzbuzz n = n)

type printable =
  | PrintInt      of int
  | PrintFizz     of fizz
  | PrintBuzz     of buzz
  | PrintFizzBuzz of fizzbuzz

val showFizzbuzz: printable -> string
let showFizzbuzz x = match x with
  | PrintFizz     _ -> "Fizz"
  | PrintBuzz     _ -> "Buzz"
  | PrintFizzBuzz _ -> "FizzBuzz"
  | PrintInt      i -> string_of_int i
```

As a final note: The resulting program still relies on a lot of unknowns. We
trust the standard library that mapping over lists is indeed correct, we trust
the compiler that the resulting machine code is a correct representation of our
code, we trust the operating system that printing to the screen is indeed
printing to the screen, and last but not least: we trust the processor that the
opcode is correct. The only thing we can do ourselves is to verify that our
business logic is correct. And that is already more than we can say about
average code.

In the end, I compiled this f-star code to C using an experimental "Kremlin"
compiler. Then, I leveraged the verified "Compcert" C compiler to obtain a final
binary. To my knowledge, this is one of the more rigerous methods to achieve
correct programs, but I'm always interested to learn more. Please ping me on
Twitter if you want to share some other ideas in this domain.


