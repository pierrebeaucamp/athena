---
title: Getting started in PureScript (Part 3)
date: 2016-02-09
description: This time, we’ll add a button to our page which will generate a name for us.
...

This time, we'll add a button to our page which will generate a name for us.

First, we add the button itself to our html document:

```html
<div class="widgets">
    <input type="text" id="inputName" maxlength="15">
    <div>
        <button id="generateButton">Aye! Gimme a name!</button>
    </div>
</div>
```

Now we want to add an event listener to our new button, similar to the event listener we added to the input element in part 1.

```haskell
main = do
    input <- unsafeDocument globalWindow >>= unsafeQuerySelector "#inputName"
    unsafeAddEventListener "input" updateBadge input
    button <- unsafeDocument globalWindow >>= unsafeQuerySelector "#generateButton"
    unsafeAddEventListener "click" generateBadge button
```

As you can see, we will call the `generateBadge` function in case of a click event. let's implement this function next:

```haskell
{-|
    generateBadge is the callback method for the event listener of the button.
    It will generate a random name to show on our badge.
-}
generateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
generateBadge event = do
    badge <- unsafeDocument globalWindow >>= unsafeQuerySelector "#badgeName"
    unsafeSetTextContent "Anne Bonney" badge
```

Our `generateBadge` function does only have a single purpose so far: Set the name on the badge to "Anne Bonney".

Compile the code and open `index.html` in your browser. If you click the button, the badge should display "Anne Bonney" in it.

Neat! But we can do better.

First of, there are a lot of lines reading
```haskell
unsafeDocument globalWindow >>= unsafeQuerySelector "#elementid"
```
This is annoying, let's hide it away:

```haskell
{- |
    querySelector is a shorthand function to select an element from the global
    document using a query.
-}
querySelector :: forall eff. String -> Eff (dom :: DOM | eff) HTMLElement
querySelector query = unsafeDocument globalWindow >>= unsafeQuerySelector query
```

Now we can replace each occurrence simply with `querySelector "#elementid"`.

Next, let's apply our knowledge from part 1 and clean up our remaining functions using the `>>=` monad. At this point, our code looks like this:

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
    generateBadge is the callback method for the event listener of the button.
    It will generate a random name to show on our badge.
-}
generateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
generateBadge event = do
    querySelector "#badgeName" >>= unsafeSetTextContent "Anne Bonney"

{-|
    main is the entry point of this program. Its sole purpose is to add event
    listeners to the button and the input field.
-}
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    querySelector "#inputName" >>= unsafeAddEventListener "input" updateBadge
    querySelector "#generateButton" >>= unsafeAddEventListener "click" generateBadge

{- |
    querySelector is a shorthand function to select an element from the global
    document using a query.
-}
querySelector :: forall eff. String -> Eff (dom :: DOM | eff) HTMLElement
querySelector query = unsafeDocument globalWindow >>= unsafeQuerySelector query

{-|
    updateBadge is the callback method for the event listener of the input
    field. It will display the value of the input field on the badge.
-}
updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = do
    input <- unsafeEventTarget event >>= unsafeValue
    querySelector "#badgeName" >>= unsafeSetTextContent input
```

For the last feature, we'll disable the button if there is already a name on the badge. This is a good UX practise: After pressing the button for the first time, it doesn't provide any functionality anymore.

First, we'll add a new function to our program: `setBadgeName`. This function will, as you might have guessed, set the name of the badge. Afterwards, `updateBadge` and `generateBadge` will be updated to call `setBadgeName` instead of setting the name themselves. In the end, we will decide if we need to disable our button or not.

let's dive in:

```haskell
{-|
    setBadgeName sets the name of the Badge and calls `disableIfEmpty`
    afterwards.
-}
setBadgeName :: forall eff. String -> Eff (dom :: DOM | eff) Unit
setBadgeName name = do
    badge <- querySelector "#badgeName"
    button <- querySelector "#generateButton"
    unsafeSetTextContent name badge
    unsafeTextContent badge >>= disableIfEmpty button
```

This should be fairly easy to follow. `disableIfEmpty` is yet another function we have to implement later. Technically, we could have included everything from `disableIfEmpty` in `setBadgeName` itself, but I  like to keep my functions as small as possible.

Now let's modify `updateBadge` and `generateBadge` to call `setBadgeName`:

```haskell
generateBadge event = setBadgeName "Anne Bonney"
...
updateBadge event = unsafeEventTarget event >>= unsafeValue >>= setBadgeName
```

As you can see, we could reduce both functions to a single line.

The last step is to implement `disableIfEmpty`. In our case, it looks like this:

```haskell
{-|
    disableIfEmpty disables a provided HTMLElement if the *content* string is
    empty.
-}
disableIfEmpty :: forall eff. HTMLElement -> String -> Eff (dom :: DOM | eff) Unit
disableIfEmpty button content = if eq content "" then do
        unsafeSetTextContent "Aye! Gimme a name!" button
        unsafeRemoveAttribute "disabled" button
    else do
        unsafeSetTextContent "Arrr! Write yer name!" button
        unsafeSetAttribute "disabled" "true" button
```

There are a couple of new things here: First, we have `unsafeSetAttribute` and `unsafeRemoveAttribute`. They are provided by `purescript-simple-dom` again.

The other new thing here is the `if ... then ... else` expression. In its pure form, it looks like this:

```haskell
if condition
	then operation_a
	else operation_b
```

The indentation is important: if you forget it, the compiler will throw errors. Otherwise, the notation works just as you know it from other languages.

In the end, our final code looks like this:

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
    generateBadge is the callback method for the event listener of the button.
    It will generate a random name to show on our badge.
-}
generateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
generateBadge event = setBadgeName "Anne Bonney"

{-|
    main is the entry point of this program. Its sole purpose is to add event
    listeners to the button and the input field.
-}
main :: forall eff. Eff (dom :: DOM | eff) Unit
main = do
    querySelector "#inputName" >>= unsafeAddEventListener "input" updateBadge
    querySelector "#generateButton" >>= unsafeAddEventListener "click" generateBadge

{-|
    querySelector is a shorthand function to select an element from the global
    document using a query.
-}
querySelector :: forall eff. String -> Eff (dom :: DOM | eff) HTMLElement
querySelector query = unsafeDocument globalWindow >>= unsafeQuerySelector query

{-|
    setBadgeName sets the name of the Badge.
-}
setBadgeName :: forall eff. String -> Eff (dom :: DOM | eff) Unit
setBadgeName name = do
    badge <- querySelector "#badgeName"
    button <- querySelector "#generateButton"
    unsafeSetTextContent name badge
    unsafeTextContent badge >>= disableIfEmpty button

{-|
    updateBadge is the callback method for the event listener of the input
    field. It will display the value of the input field on the badge.
-}
updateBadge :: forall eff. DOMEvent -> Eff (dom :: DOM | eff) Unit
updateBadge event = unsafeEventTarget event >>= unsafeValue >>= setBadgeName

{-|
    disableIfEmpty disables a provided HTMLElement if the *content* string is
    empty.
-}
disableIfEmpty :: forall eff. HTMLElement -> String -> Eff (dom :: DOM | eff) Unit
disableIfEmpty button content = if eq content "" then do
        unsafeSetTextContent "Aye! Gimme a name!" button
        unsafeRemoveAttribute "disabled" button
    else do
        unsafeSetTextContent "Arrr! Write yer name!" button
        unsafeSetAttribute "disabled" "true" button

```
