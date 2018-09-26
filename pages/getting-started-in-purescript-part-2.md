---
title: Getting started in PureScript (Part 2)
date: 2016-01-29
decsription: After we learned how to set up a PureScript project in part 1, we’ll begin writing our first app.
...

After we learned how to set up a PureScript project in [part
1](/posts/getting-started-in-purescript-part-1/), we'll begin writing our first
app.

Let's start by editing our HTML file to include the input field itself. Remove
the `TO DO` line and replace it with

```html
<input type="text" id="inputName" maxlength="15">
```

Now for the interesting part: PureScript. First, we'll adjust the `import`
section of our code. We don't need `Control.Monad.Eff.Console` anymore, as we
don't plan to log anything to the console. Instead, we'll import some modules
needed to interact with the DOM. Add the following lines in between the module
declaration and the main function:

```haskell
import Data.DOM.Simple.Unsafe.Element
import Data.DOM.Simple.Unsafe.Events
import Data.DOM.Simple.Unsafe.Window
import Data.DOM.Simple.Window
import Prelude
```

This might seem like an awful lot of imports for a simple program like ours. But
remember the modularity of PureScript: Only the libraries you actually need will
be included. While a huge standard library (like Go) is great to quickly write
up prototypes, I like this modular approach when it actually comes to shipping
code - I have full control over it.

So having added the new import statements, we can now adjust our main method.
The purpose of our program is to listen for any input on the text field and
display the value on the badge. The `Data.DOM.Simple.Unsafe.Events` module comes
with a `unsafeAddEventListener` function which will do the job.

To learn more about a function, the type declaration comes in handy (remember
that huge thing for `main`?). The documentation for `unsafeAddEventListener`
tells us:

```haskell
unsafeAddEventListener :: forall eff t e b. String -> (e -> Eff (dom :: DOM | t) Unit) -> b -> Eff (dom :: DOM | eff) Unit
```

Ouf, that's certainly something. To make it easier to understand, let's pretend
for a moment that there is no `forall`, `eff` or `Eff()` in our declaration. So,
a *watered down* version of this declaration would be:

```haskell
unsafeAddEventListener :: String -> e -> b -> Unit
```

That doesn't look quite as scary anymore. The type declaration in Purescript is
both used for the input arguments as well as for the return values. In general,
the last thing an arrow is pointing to is the return type (in this case `Unit`).
Again, we're out of luck, as a `Unit` is somewhat special, but for now, let's
pretend it is the same as `void` in C. [^disclaimer]

As we already know that the function outputs something like `void`, the input
arguments must be the preceding values. In our case, `unsafeAddEventListener`
will take a `String`, some `e` and some `b`. But what exactly are `e` and `b`?
Remeber the proper type declaration started with `forall eff t e b.` This simply
means "for any eff, t, e or b" - the function will work with any type.

So to sum things up, we have `unsafeAddEventListener`, which takes a String and
any two objects to return us something like `void`.

Sadly, the `purescript-simple-dom` module doesn't come with lots of
documentation, but from an example, we learn that the `String` is the EventType,
the first `e` is the event callback and the second `b` is the element to listen
on.

Alright, let's put it all together. Adjust your `main` function to look like
this:

```haskell
main = do
    unsafeAddEventListener "input" updateBadge element
```
[^description-1]

Let's continue by looking for a way to select the right HTML element and
reference it in `element`. In `Data.DOM.Simple.Unsafe.Element`, we find
a `unsafeQuerySelector` module which sounds about right. Again, we look at the
type declaration to see what we need to pass:

```haskell
unsafeQuerySelector :: forall eff a. String -> a -> Eff (dom :: DOM | eff) HTMLElement
```

In this case, it needs a string for the query itself and any object to run the
function on. It will then return an HTMLElement - just what we need.

As the `element` variable needs to be declared before we can use it in
`unsafeAddEventListener`, we declare it on the line above:

```haskell
main = do
    element <- unsafeQuerySelector "#inputName" document
    unsafeAddEventListener "input" updateBadge element
```
[^description-2]

There is a new operator (`<-`) that we haven't seen yet. This is a *bind*
operator - it binds the result of the function on its right side to the variable
on the left side. The equal sign (`=`) works more like an alias in PureScript.
But in this case, we want to work with the output of `unsafeQuerySelector`
itself, so we chose `<-`.

We still need to declare the `document` variable though. This time, we can't use
`unsafeQuerySelector` as we want to refernece the whole HTML document itself.
Again, we dive into the documentation and find the function `unsafeDocument` in
the module `Data.DOM.Simple.Unsafe.Window` with the following type declaration:

```haskell
unsafeDocument :: forall eff a. a -> Eff (dom :: DOM | eff) HTMLDocument
```

By now, it shouldn't be all to hard to get a basic understanding from type
declarations: The function takes any object `a` and returns an `HTMLDocument`
from it.

But what exactly should we pass as `a`? We need to find the parent object of the
root document - and frankly, there is only the global window. Luckily, there is
the constant `globalWindow` in `Data.DOM.Simple.Window` which is exactly what we
need.

Finally, we have everything in order to write a complete `main` method:
```haskell
main = do
    document <- unsafeDocument globalWindow
    element  <- unsafeQuerySelector "#inputName" document
    unsafeAddEventListener "input" updateBadge element
```

Phew, this has been a lot of work to simply add an event listener to an object.
But if you've made it this far in the tutorial, you're already over the hardest
parts. Coming from one of the more popular imperative languages to functional
programming, it can often be off-putting to write so detailed code. But it is
incredible how much safer our programs can be if we enforce strict type checking
and pure functions onto them.

But let's not get carried away! There is still our `updateBadge` function which
needs to be implemented.

Once more, let's start by looking for the right function in one of our modules.
What is the purpose of `updateBadge`? To set the text of the badge to the text
of the input field. In `Data.DOM.Simple.Unsafe.Element`, we find
`unsafeTextContent` with the following type declaration:

```haskell
unsafeSetTextContent :: forall eff a. String -> a -> Eff (dom :: DOM | eff) Unit
```
Sounds great, let's use it:

```haskell
updateBadge event = do
    unsafeSetTextContent input badge
```
[^description-3]

Note that `updateBadge` takes a paramter called `event`. But how exactly did
I know that the callback function will receive a paramter? Let's take a look at
the type declaration of `unsafeAddEventListener` again:

```haskell
unsafeAddEventListener :: forall eff t e b. String -> (e -> Eff (dom :: DOM | t) Unit) -> b -> Eff (dom :: DOM | eff) Unit
```

In our *simplified* version of this declaration, we wrote:
```haskell
String -> e -> b -> Unit
```
But in reality, `e` is declared as:
```haskell
(e -> Eff (dom :: DOM | t) Unit)
```

Or, if we discard `Eff` again, we see `(e -> Unit)`. So in the context of
`String -> (e -> Unit) -> b -> Unit`, the second parameter of
`unsafeAddEventListener` is anything which takes any `e` and returns `Unit`.
Again, from some examples in the documentation, we know that `e` is the object
of the event itself.

Alright, we have our `unsafeSetTextContent` in place, but still need to declare
both our `input` and our `badge` objects. Let's start with `badge`, as we can
simply apply our knowledge from `main`. Adjust your function to look like this:

```haskell
updateBadge event = do
    document <- unsafeDocument globalWindow
    badge    <- unsafeQuerySelector "#badgeName" document
    unsafeSetTextContent input badge
```

To get our `input` string, we'll go down a slightly different route. We know
that a Javascript event listener will pass the event itself to the callback
function. This `event` object already includes a reference to the element it
listened to. This reference is called event target. Again, we look through the
documentation of our modules and find `unsafeEventTarget` with the following
type:

```haskell
unsafeEventTarget :: forall eff a. DOMEvent -> Eff (dom :: DOM | eff) a
```
So this function takes a `DOMEvent` and returns *something*.

I guess we finally need to talk about the `Eff` monad and so-called side
effects. Purely functional programming languages have a common problem: Most
functions are simply not *pure*. What does this mean? Well, think of a function
the same as in calculus, for example `f(x) = x * x`. This is a pure function:
Given the same input values, it will always generate the same output. But our
programs depend on a whole bunch of outside parameters we can't include in every
function. Things like time, random numbers, logging or, you guessed it, the DOM.
A function like `querySelector` will return different outputs while using the
same input parameters. Why? Because it depends on the DOM, which does not exists
in our code. The DOM can vary from user to user.

Those functions are called impure. So how does a *purely functional* language
treat an impure function? In PureScript, we have the concept of *side effects*:
an impure function has a number of side effects. For example,
`unsafeQuerySelector` depends on the DOM, so it has the side effect of being
affected by the DOM. Let's take a look at its type declaration again:

```haskell
unsafeQuerySelector :: forall eff a. String -> a -> Eff (dom :: DOM | eff) HTMLElement
```

Now, the return value makes more sense. The function returns an `HTMLElement`
with the side effect `Eff (dom :: DOM | eff)`. As you might have guessed it,
`Eff` stands for "Effect". Let's break down what is going inside its brackets:
Earlier, we've encountered `eff` in combination with `forall`: `forall eff a.`.
So, again, `eff` is declared as *anything*. In contrast, `dom` is declared
inline as type `DOM`. Putting it all together, the construct `forall eff. Eff
(dom :: DOM | eff)` means "Side effects include DOM and *any other effects*".

This is a very elegant solution to the problem of impure functions. We don't
know how many things the DOM is affected by. Thus, we also don't know how many
other things will somehow influence our function. But what we *do* know is that
it's affected by the DOM itself.

Now let's go back to `unsafeEventTarget` with its type declaration:

```haskell
unsafeEventTarget :: forall eff a. DOMEvent -> Eff (dom :: DOM | eff) a
```

We already know that it takes a `DOMEvent`. But now comes the beautiful part:
The function returns *some object* which will be affected by the DOM and *any
other side effects*. So we still don't know what the hell we're receiving back,
but we do know it has something to do with the DOM, and we can work with that!

So we need to find a function which takes anything affected by the DOM and gives
us a string. After looking around, we find `unsafeValue` with the declaration
`unsafeValue :: forall eff a. a -> Eff (dom :: DOM | eff) String`. Perfect: It
doesn't care what we're feeding it, but the function returns a string affected
by the DOM.

Now let's put everything together and hope it works! This is my complete
document at this point:

```haskell
module Main where

import Data.DOM.Simple.Unsafe.Element
import Data.DOM.Simple.Unsafe.Events
import Data.DOM.Simple.Unsafe.Window
import Data.DOM.Simple.Window
import Prelude

main = do
    document <- unsafeDocument globalWindow
    element  <- unsafeQuerySelector "#inputName" document
    unsafeAddEventListener "input" updateBadge element

updateBadge event = do
    document <- unsafeDocument globalWindow
    badge    <- unsafeQuerySelector "#badgeName" document
    target   <- unsafeEventTarget event
    input    <- unsafeValue target
    unsafeSetTextContent input badge
```

I know your fingers are probably itching to try this out, so go ahead and run
`pulp build`!

Aaaaaand your build will probably fail. I guess you got something like the
following error:

```markdown
Unknown module Data.DOM.Simple.Element
```

That's because we haven't installed the `purscript-simple-dom` package yet.
Fortunately, it's very easy to resolve this dependency: simply run `pulp dep
install purescript-simple-dom --save`.

But this should be the last obstacle in this chapter. Run `pulp build -O --to
main.js` and open `index.html` in your browser. You should find an empty input
field - go ahead and enter something. Whatever you inserted into the field
should now appear on the badge. Horray!

![Working pirate badge]({{url_for('static', filename='img/badge2.png')}})

## Refactoring
Our code is working as intended, so now it's time to improve it a bit.

The first thing to do is to get rid of the nasty warnings we get while
compiling. Who likes warnings anyways? Those are the two warnings I got:

```markdown
Warning 1 of 2:

  in module Main
  at /home/pierrebeaucamp/Downloads/projects/purescript-tutorial/src/Main.purs line 14, column 1 - line 18, column 32

    No type declaration was provided for the top-level declaration of updateBadge.
    It is good practice to provide type declarations as a form of documentation.
    The inferred type of updateBadge was:

      forall t6. DOMEvent -> Eff ( dom :: DOM
                                 | t6
                                 )
                             Unit


  in value declaration updateBadge

  See https://github.com/purescript/purescript/wiki/Error-Code-MissingTypeDeclaration for more information,
  or to contribute content related to this warning.

Warning 2 of 2:

  in module Main
  at /home/pierrebeaucamp/Downloads/projects/purescript-tutorial/src/Main.purs line 9, column 1 - line 14, column 1

    No type declaration was provided for the top-level declaration of main.
    It is good practice to provide type declarations as a form of documentation.
    The inferred type of main was:

      forall t29. Eff ( dom :: DOM
                      | t29
                      )
                  Unit


  in value declaration main

  See https://github.com/purescript/purescript/wiki/Error-Code-MissingTypeDeclaration for more information,
  or to contribute content related to this warning.
```

First of all: Those are probably the most helpful warnings ever! It even
suggests a way to fix them. So let's go ahead and provide type declarations for
our functions:

```haskell
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    ...

updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = do
    ...
```

That's pretty much exactly what the compiler suggested. I just switched out `t6`
and `t29` with `eff` for increased readability. But I could have called it
whatever I want. Let's compile again and see if the warnings went away.

Uh-Oh. `Unknown type Eff`? `Unknown type DOMEvent`? Turns out that we need to
import modules even if we only reference them in our type declarations. So let's
go ahead and add the following packages to our `import` statements:

```haskell
import Control.Monad.Eff
import Data.DOM.Simple.Type
import DOM
```

Now save the file and recompile it - the warnings and errors should now be gone.

Another thing I want to do is to bring the number of lines down. Especially
`updateBadge` is a bit of a personal pain point as I don't like to have as many
declarations just to use them once. So let's try to inline as many as we can
while keeping the line length under 81 characters.

Our best helper here is the `>>=` notation. `>>=` is another alias for `bind`,
just as `<-` is. From the "[PureScript by
Example](https://leanpub.com/purescript/read)" book by Phil Freeman, we learn
that the following notation

```haskell
do
    value <- someComputation
    whatToDoNext value
```
is the same as
```
someComputation >>= whatToDoNext
```
Perfect, let's apply this:
```haskell
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    element <- unsafeDocument globalWindow >>= unsafeQuerySelector "#inputName"
    unsafeAddEventListener "input" updateBadge element

updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = do
    badge <- unsafeDocument globalWindow >>= unsafeQuerySelector "#badgeName"
    input <- unsafeEventTarget event >>= unsafeValue
    unsafeSetTextContent input badge
```

The last thing is often overlooked, no matter the language you're used to:
**document your code!** Most of the time, documentation is just and
afterthought, but it should be an essential part of your work. PureScript
supports Haddock-style comments, so we could even generate proper documentation
from our comments alone - awesome.

Here is what my code looks now:
```haskell
module Main where

import Control.Monad.Eff
import Data.DOM.Simple.Unsafe.Element
import Data.DOM.Simple.Unsafe.Events
import Data.DOM.Simple.Unsafe.Window
import Data.DOM.Simple.Types
import Data.DOM.Simple.Window
import DOM
import Prelude

{-|
    main is the entry point of this program. Its sole purpose is to add an
    event listener to the input field.
-}
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    element <- unsafeDocument globalWindow >>= unsafeQuerySelector "#inputName"
    unsafeAddEventListener "input" updateBadge element

{-|
    updateBadge is the callback method for the event listener of the input
    field. It will display the value of the input field on the badge.
-}
updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = do
    badge <- unsafeDocument globalWindow >>= unsafeQuerySelector "#badgeName"
    input <- unsafeEventTarget event >>= unsafeValue
    unsafeSetTextContent input badge
```

That's it for now. Take a break, drink a coffee and head over to [part
3](/posts/getting-started-in-purescript-part-3/) to continue on your functional
journey!

[^disclaimer]: Please don't associate `Unit` with C's `void`. They are
  ***completely*** different. A `Unit` is the type of an empty record. C's
  `void` would likely be `Nothing` in PureScript.

[^description-1]: {-} The event type we want to listen to is `input`. <br>
  `updateBadge` is our event callback - we've yet to implement it. <br>
  `element` is the element we want to attach the event listener to.

[^description-2]: {-} `#inputName` is the id of our input field. We've declared
  it in our HTML document itself. <br> `document` is the parent HTML element we
  want to run the function on.

[^description-3]: {-} `input` is a string with the text of our input field <br>
  `badge` is an HTML element referencing our badge.

