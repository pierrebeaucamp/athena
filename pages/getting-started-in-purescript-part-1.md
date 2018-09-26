---
title: Getting started in PureScript (Part 1)
date: 2016-01-16
description: PureScript is an amazing language to write Web Apps in. It is purely functional, strongly typed and compiles into surprisingly small Javascript.
...

PureScript is an amazing language to write Web Apps in. It is purely functional,
strongly typed and compiles into surprisingly small Javascript.

But similar to Haskell, I find the learning curve is extremely steep at the
beginning. There is a comprehensive and free to read E-Book by Phil Freeman,
called "[PureScript by Example](https://leanpub.com/purescript/read)", however,
I couldn't find a single useful "getting started" tutorial for this language.

I decided to fill this gap with the following tutorial. It is an adaptation of
the 1 hour "[Darrrt](https://www.dartlang.org/codelabs/darrrt/)" code lab for
Dart, as it was one of the best introductions to a new programming language I've
encountered. Let's get started!

## Prerequisites

For this project, we'll use both PureScript and
[Pulp](https://github.com/bodil/pulp), a build system for PureScript. If you
haven't installed them yet, you can get them through Node:

```bash
npm install -g purescript pulp
```

To create a new Pulp Project, we'll create a new folder and run `pulp init` in
it:

```bash
mkdir purescript-tutorial
cd purescript-tutorial
pulp init
```

The project structure is pretty much self-explanatory: There is a `src` folder
for source files, a `test` folder for unit tests and `bower.json`.

As we're creating a web app, we'll also need an HTML file. I've put some
[skeleton files on
Github](https://github.com/pierrebeaucamp/purescript-tutorial/releases) - you
might want to download them if you want to follow along. Both `index.html` and
`styles.css` are simply placed in the project's root folder.

## Examine the skeleton app

With the project initialized and the skeleton files in place, it's time for the
first compilation of our app. To compile our code, run:

```bash
pulp build -O --to main.js
```
[^description-1]

Now, open `index.html` in your favorite web browser. You should be greeted by
the following pirate badge:

![skeleton pirate badge]({{url_for('static', filename='img/badge1.png')}})

And if you open the Javascript console, you should see a friendly "*Hello
Sailor!*".

Let's take a look what we've got so far:
**index.html**
```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Pirate badge</title>

        <script async src="main.js"></script>
        <link rel="stylesheet" href="styles.css">
    </head>

    <body>
        <h1>Pirate badge</h1>
        <div class="widgets">
            TO DO: Put the UI widgets here.
        </div>
        <div class="badge">
            <div class="greeting">
                Arrr! Me name is
            </div>
            <div class="name">
                <span id="badgeName"> </span>
            </div>
        </div>
    </body>
</html>
```

Nothing fancy here. We load `main.js` in our header (remember `pulp build -O
--to main.js`) which holds all of our PureScript code. If you're curious, just
open the file and read through the produced code. One of the strengths of
PureScript is the readability of the Javascript output!

The body of the HTML document should be straight forward as well. We've got the
red badge itself (`<div class="badge">`), an empty widget (`<div
class="widgets">`) and a heading.

Note that there is an empty `<span id="badgeName">`. This is the place where we
can put a name on the badge later on.

**src/main.purs**
```haskell
module Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Console

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
    log "Hello sailor!
```

This is the default PureScript file after you run `pulp init`. If you've only
worked with C-like syntax before, this might look strange at first. But in
reality, it's pretty simple. Let's dive in.

The file begins with a module header. In this case, our module is `Main`, as it
provides the `main` method, the entry point of our program.

In the following lines, you see a couple of `import` statements. It might seem
like a lot of imports for a simple "Hello World" program, but it shows the high
modularity of the language. The most important module we're importing is
`Prelude`. It holds the most basic functions, like numeric addition or
multiplication. Yes, they are in their own module - PureScript itself is as
minimalistic as possible. `Control.Monad.Eff` is a module for side effects. Side
effects are a bit complicated if you've never heard of impure functions before,
so I'll skip over them for now. Lastly, `Control.Monad.Eff.Console` is a module
for accessing the Javascript console.

Now for the line which scared me the most while diving into functional
programming: `main :: forall e. Eff (console :: CONSOLE | e) Unit`. This is the
type declaration for the main function. It's similar to `int main()` in C++. But
in this case, our `main` function isn't of the type `int`, it's of the type
`forall e. Eff (console :: CONSOLE | e) Unit`.

I know this can be very overwhelming, but please, stay with me. In fact, I'll
make your life a bit easier: Just delete the line! Type declarations are a best
practice, but completely optional. With this out of the way, we can also delete
line 3 (`import Prelude`) and line 4 (`import Control.Monad.Eff`). So the
following code will still compile to the same, fully operational program as
before:

```haskell
module Main where

import Control.Monad.Eff.Console

main = do
    log "Hello sailor!"
```

This is not to say that you should ignore type declarations - it's just easier
for newcomers to get a hold of this language this way. After some time working
with PureScript, I hope everyone will understand the benefits of the type system
and the modularity of this language.

Now for the last part of our code:
```haskell
main = do
    log "Hello sailor!"
```

This should be quite easy to understand. `main` is the name of our function and
it's purpose is to `log "Hello sailor!"`. The `log` function is provided through
the `Control.Monad.Eff.Console` module we've imported earlier in the code.

As for right now, our `main` function has only a single instruction (`log`). So
we could write `main = log "Hello sailor!"` and it would still be the same
program. But once a function has more than one instruction (so a sequence of
instructions), the `do` notation comes in handy. This notation basically tells
the interpreter to do one instruction after another:

```haskell
main = do
    action1
    action2
    action3
```

This will execute `action1`, then `action2` and finally `action3`. Personally,
it was pretty interesting to read about the reasoning behind `do`, but, for now,
it's ok just to remember that we need to write `do` if our function has more
than one instruction.

Now that we are up and running, head over to [part
2](/posts/getting-started-in-purescript-part-2/) to start coding!

[^description-1]: {-} The `-O` flag strips all the unused code away, so the
  resulting Javascript code is as small as possible. <br> The `--to` flag
  defines the output file.


