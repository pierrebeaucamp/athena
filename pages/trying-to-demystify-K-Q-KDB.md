---
title: Trying to demystify K/Q/kdb+
date: 2018-10-01
description: Trying to demystify K/Q/kdb+
...

For a rather long time now, I wanted to learn more about APL. As a self taught
programmer coming from C-style languages, its concepts seemed so foreign to me.
So far, I had no trouble wrapping my head around new paradigms introduced by
Haskell, LISP or Prolog, yet the APL family of languages seemed more of an
impractical joke to me.

Yet I found myself coming back to APL over and over, mainly thanks to examples
like the the [vintage APL demonstration from
1975](https://www.youtube.com/watch?v=_DTpQ4Kk2wA), the [one line sudoku
solver](https://github.com/KxSystems/kdb/blob/master/sudoku.k) or the
[impressive benchmarks of
KDB+](http://tech.marksblogg.com/billion-nyc-taxi-kdb.html), an in-memory
database implemented in K, a modern decendant of APL.

But I could just not bring myself to understand, or even like APL. And anyone
researching this language will quickly find a sea of developers denouncing its
terse syntax. However, Kx Systems, the company developing K, Q and KDB+ recently
hosted a workshop about their technology and proofed to be a perfect
introduction into the world of APL.

What follows is my personal interpretation of Q, a commercial array language by
Kx Systems. I am not a Q, K or KDB+ expert and my experience with those
technologies is still very small. However I think it is helpful to shine
a different light on it, as it is an incredibly undervalued language and I would
love to see larger adoption of it in the future.


## Notation as a Tool of Thought

Let's take the one-line Sudoku example I mentioned above:

```k
*(,x)(,/{@[x;y;:;]'&~in[!10]x*|/p[;y]=p,:3/:_(p:9\:!81)%3}')/&~x
```
[^kx-copyright]

I think the first time I saw this, I immediatly gave up on trying to understand
it. Obviously this is just a golfing language, what other explanation would
there be for this?

Thankfully, someone introduced me to Kenneth Iverson's Turing award lecture
"[Notation as a Tool of
Thought](http://www.eecg.toronto.edu/~jzhu/csc326/readings/iverson.pdf)".
I highly recommend reading the entire paper, but there is a quote in the
introduction which sums it up quite nicely:

> By relieving the brain of all unnecessary work, a good notation sets it free
> to concentrate on more advanced problems, and in effect increases the mental
> power of the race.
>
> --- A.N. Whitehead

Essentially, by having a notation which "hides" away most of the implementation
of a specific operation, we allow ourselves to reason more clearly about the
problem at hand.

However the paper talks about APL itself, where each operator was represented by
a special graphic symbol, for example ⍕ or ⍋. This made the language precise to
read, but hard to write, as special keyboards were needed.

Apparently the abstract syntax was large enough of a problem that J, a synthesis
of APL by Iverson himself (together with Roger Hui), was only using characters
found in the ASCII character set.

Yet this leads to the next problem: Character overloading. To my knowledge, most
operands in APL had a single meaning. Contrast this K where a single symbol can
have up to four different meanings, dependent on how many arguments we apply it
to. To a lesser extend, take the `*` symbol from the Sudoku example above.
Applied to two arguments, it is simply "multiplication", but applied to a single
one, it becomes "first".

Luckily, yet another dialect of APL was introduced, this time called Q. And
Q seems to be the "friendliest" language to read, with many functions having
proper english names, instead of single characters.


## J/K & M-Expressions

By now, I talked about APL itself, but also J, K, and Q. It is easy to think of
J and K as simple iterations of APL, but in reality both of these adaptions are
a combination of APL and a second programming lanauge.

For J, this other part is FP, a language proposed by John Backus in his turing
award lecture (and one of my favourite papers) "[Can Programming Be Liberated
from the von Neumann
Style?](http://www.csc.villanova.edu/%7Ebeck/csc8310/BackusFP.pdf)". Although FP
is very notable, I don't have a lot of experience with it.

However K combines APL with LISP.

Learning this for the first time really suprised me. I adore LISP languages for
their cleanliness and K looks... still like a random assortment of ASCII
characters. But the similarities are glaring. There is a whole [comparison of
LISP vs K](http://kparc.com/lisp.txt) by Arthur Withney, the author of
K himself. But the gist of it is: The main datatypes in K are Atoms and Lists,
and code is written in M-Expressions, as opposed to S-Expressions. So for
example, the following two samples are equivalent:

LISP:

```lisp
(defun fact_iter (lambda (product counter max_count)
  (if (> counter max_count)
    product
    (fact_iter (* counter product)
               (+ counter 1)
               max_count))))
```

K:

```k
:[fact_iter; {[product; counter; max_count]
  :[>[counter; max_count];
    product;
    _f[*[counter; product];
       +[counter; 1];
       max_count]]}]
```

Notice the few differences in K

1. The Lambda function is implictly bound to curly brackets

2. Lists are seperated by a semicolon, not a whitespace

3. The colon sign is an overloaded character. In the first line, it denotes
   "assign to", but in the second line, it represents the "if" function

4. Instead of calling `fact_iter` recursively, we call `_f`, which is a constant
   referring to the current function. We need to call `_f` because `fact_iter`
   is not yet defined when K parses the sourcecode.

To me, discovering the M-Expression syntax of K and Q was some muche needed
familiarity. However it is uncommon to find this notation in the wild. In
reality, a K implementation of `fact_iter` would most likely look like this:

```k
f:{:[y>z;x;_f[y*x;y+1;z]]}
```

I guess that this will actually make sense right now, but only because you read
the "longform" notation previously. The shortform shows my main problem with the
language:

Without having the K / Q reference open in a seperate window or somehow knowing
most definitions by heart, it is next to impossible to decifer. Sure, in this
small example, I could probably infer the algorithm from it after staring at it
for  a while, but embedded in a bigger codebase, this option would not exist.
Implicit argument names (x, y and z) make the code very clean, but we loose any
information we might have stored in the variable name itself. On top of that, we
need knowledge about any internal constants (`_f`) and possible overloaded
characters.

Again, I can understand if this seems like a minor issue for this isolated
example, but let's take the sudoku example again:

```k
*(,x)(,/{@[x;y;:;]'&~in[!10]x*|/p[;y]=p,:3/:_(p:9\:!81)%3}')/&~x
```

Even though I'd say that I "get" K at this point, I can't explain this line of
code. Let's try to rewrite it in Q and break it up into mulitple sections:

```k
/ Some friendlier names for readability
toInt: "I" $
amend: @
join: {x,y}

/ Again, just a friendlier name for readability, but wihtout it, it is hard to
/ differentiate between a simple `over` and `repeat`.
repeat: {x y/z}

/ The puzzle itself, taken from
/ https://github.com/KxSystems/kdb/blob/master/sudoku.k
puzzle: toInt each "200370009009200007001004002050000800008000900006000040900100500800007600400089001"

/ row_col is a matrix of rows and columns:
/ 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 .. / Row index
/ 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 8 .. / Column index
row_col: (9\:) til 81

/ row_col_box is a matrix of rows, columns and subgrid (box).
/ 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 .. / Row index
/ 0 1 2 3 4 5 6 7 8 0 1 2 3 4 5 6 7 8 .. / Colum index
/ 0 0 0 1 1 1 2 2 2 0 0 0 1 1 1 2 2 2 .. / Box number at the row & column index
row_col_box: join[row_col; enlist (3/:) floor row_col % 3]

/ gaps is a list of integers. Each integer denotes an index of a "blank" space
/ in our puzzle, i.e. a gap we need to fill.
gaps: where not puzzle

check: {where not in[til 10; x * {x or y} over row_col_box[;y] = row_col_box]}

first repeat[enlist puzzle; join over {amend[x;y;:;] each check[x;y]}'; gaps]
```

This is 30 lines longer than the original, and I _still_ can't really explain
the last two lines. I think I get the gist of it, and I could probably spend
more time debugging it, but for now I'm giving up. In my opinion, this
demonstrates the "readability" problem pretty well.


## It's about time

At this point, we know that K/Q are commerically successful LISP-like languages
with a rich history and infamous readability problems. This begs the question
_why_ they are successful instead of a more readable LISP alternative.

The answer is apparently speed. It is said that most K code is as fast or faster
than most C code while still being interpreted. How fast are we talking? Well
the Kx Systems license agreement prevents me from distributing "any report
regarding the performance" of Q/K. Therefore I can only talk about an open
source implementation of K, such as [Kona](https://kona.github.io/). Q _could_
be much faster, much slower or about the same as Kona, but this is for the
reader to find out. Please don't sue me.

As an example, let's calculate the n-th fibonnaci number. While this might not
be a good measurement for real world performance, it still tells us a lot about
language characteristics.

As the baseline, I'm using the following C code, compiled with `gcc -O3`:

```c
#include <stdio.h>

int main() {
  unsigned long long first = 0, second = 1, next = 0;

  for (int i = 0; i < 100000000; i++) {
    next = first + second;
    first = second;
    second = next;
  }

  printf("%llu\n", next);
  return 0;
}
```

This calculates the 100.000.000th fibonacci number and takes 5-6 milliseconds on
my Surfacebook laptop.

Now, let's compare this to the follwing K implementation:

```k
*| 5000 {x,+/-2#x}/0 1
```

In 5-6 milliseconds, I could only calculate the 5.000th fibonacci number. In
other words, this K example is 20.000 times slower than C (And there is an
integer overflow in there).

Although I am a bit dissapointed in the weak performance of K against C in this
arbitratry test, it is about what I'd expect from an interpreted language.

Let's compare this to yet another implementation, this time in Racket:
[^time_racket]

```rkt
#lang racket

(define (repeat n f a)
  (let ([x (f a)])
    (cond
      [(> n 1) (repeat (- n 1) f x)]
      [else x])))

(define (fib n)
  (repeat n (lambda (x) (append x (list (apply + (take-right x 2))))) (list 0 1)))

(time (last (fib 226)))
```

This time, we only got to the 226th fibonacci number in our time window. This is
about 22 times slower than K. There are probably faster implementations out
there, but I want to compare "simple" implementations.

Speaking of "simple", this is not really how one would implement a fibonacci
function in racket / LISP. A more straight forward function would look like
this:

```rkt
#lang racket

(define (fib n)
  (if (<= n 2)
      1
      (+ (fib (- n 1)) (fib (- n 2)))))

(time (fib 30))
```

Notice how this is significantly slower again, but for a good reason: This
algorithm has a runtime complexity of `O(n²)` where as the previous code was
`O(n)`. What is interesting however is the runtime of this `O(n²)` algorithm in
K:

```k
{:[x<2;1;_f[x-1]+_f[x-2]]}[14]
```

Notice how this is only able to calculate the 14th fibonacci number in
5 milliseconds. Or in other words: K really doesn't like recursion. Ouch. This
is a pretty large restriction for a LISP-like language.


## Da·ta·base

K and Q have a second selling point besides being a somewhat fast LISP-like
language. A database called KDB or KDB+, advertised as "the world’s fastest
time series database".

Again, I'm apparently not allowed to comment on the _actual_ performance of this
technology, but I can describe its design, as this is already public
information:

First of all, KDB is not really a product on it's own. What is called "KDB" is
just a map / dictonary in Q/K. Nothing more and nothing less. Now, having
a dictonary in Q is enormously powerful and I don't want to take away from that.
Querying for data in M-Expressions, with all the Q and K functionality at hand
is amazing. However, it is "just" an internal datastructure. There is no
built-in persistance, sharding, fail-over or even concurrency methods. It is
fast because it's simple and because it's realised in a simple and relatively
fast language to begin with. However it is certainly not magic.

Let's look at the benchmark published by another author:
[http://tech.marksblogg.com/benchmarks.html](http://tech.marksblogg.com/benchmarks.html)
With enough processing power, it is not hard to beat KDB+. However what truely
stands out is how little KDB+ requires and how "easy" it is to use. And to me,
this is far more respectable than having the fastest benchmarks out there.


## K/Q/KDB+ demystified?

I hope I could demenstrate some advantages and disadvantages about K & Q. I'm
certainly still new to this technology, but I think this overview is good enough
to build a picture of this technology.

I started this jouney with a lot of respect for languages of the APL families.
I definetly still have the same amount of respect for K/Q, albeit for different
reasons. I expected a terse, hard to learn golfing language which was faster
than pretty much everything out there because it probably relies on a ton of
hacks. What I found was a foreign, but yet familiar language with above average
performance in its class. And the sobering realization that there is no magic
under the hood, but just a simple and small language with the right influences
is actually increasing the likelyhood of me using it in the future.

So in the end, don't be afraid of K & Q. It's amazing that this piece of
technology prevailed all these years while the largest part of software
development is focused on Javascript and reinventing the wheel. The only thing
missing from it is a thriving open source community, but projects like
[oK](https://github.com/JohnEarnest/ok) or
[Kona](https://github.com/kevinlawler/kona) are a good start. I'd be excited to
see a larger adoption of it.

[^kx-copyright]: {-} Taken from
  [https://github.com/KxSystems/kdb/blob/master/sudoku.k](https://github.com/KxSystems/kdb/blob/master/sudoku.k)

[^time_racket]: {-} I'm using the build in `time` method as racket has a ~30
  millisecond startup time.
