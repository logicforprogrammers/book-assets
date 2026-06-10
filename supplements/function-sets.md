# Quantifying over functions

*Logic for Programmers* uses first-order logic, meaning there's no such thing as a "set of predicates" and predicates can't take other predicates as values. But if you end up poking around at SMT solvers a bit (see chapter 11) you'll find two things:

1. SMT solvers are defined as [checking first-order formulas](https://smt-lib.org/about.shtml). 
2. SMT solvers can totally quantify over functions, including Boolean functions.



So, uh, isn't this kinda weird? Why is quantifying over predicates forbidden but not functions?

The answer comes down to how we define "function". If a function is "anything that takes an input value and returns an output value", then they're called [function symbols](https://en.wikipedia.org/wiki/Function_symbol) and no more tractable than predicates. But most of the time we think of functions as not taking *any* kind of input and producing *any* kind of output, but things like "take a boolean and output a boolean" or "taking a string and an int and output a set of floats". 

Most math is done with this more restrictive notion of "function": a mapping between two known sets. So let's formalize this notion and see what we can do with it.

## Set-theoretic functions

Let's start by defining a function as being a set of pairs, the first element being the function input and the second being the output. For example, the function `not(x: bool)` is the set `{(true, false), (false, true)}`. The first element is always a Boolean, and the second element is also always a Boolean. Therefore, we can say `not` is a *subset* of the set `Bool x Bool` (where `x` is the Cartesian Product).

Now let's look at `add(x, y: int)`. This is the infinite set 

```
{
((0, 0), 0),
((1, 2), 3),
((-1, 6), 5),
...
}
```

`add` is a subset of `(Int x Int) x Int`. But not all subsets of this set are functions! To be a function from `Int x Int` to `Int`, we have two requirements: 

1. The function must map *every* value in `Int x Int` to some value in `Int`.
2. The function can't map one input to two different outputs.
3. The function must only map values of the input to values of the output (and not some other set).

Formally:

```
IsFunction(f, In, Out) =
    1. f subset In x Out
    2. MapsAllInputs(f, In, Out)
    3. OneOutPerIn(f, In, Out)
      

# Some helpers
MapsAllInputs(f, In, Out) =
    all i in In:
        some o in Out:
            (i, o) in f
 

OneOutPerIn(f, In, Out) =
    all i in In, o1, o2 in Out:
        (i, o1) in f && o1 != o2 => (i, o2) !in f
```

Once we have that, we can define the set of all functions between `In` and `Out` via a set map over the [set of subsets](https://en.wikipedia.org/wiki/Power_set):

```
2^set = `set of all subsets of s`
InOutFunctions = {f in 2^(In x Out): IsFunction(f, Int, Out)}
```

As a more concise notation, we can write "the set of all functions from `In` to `Out`" as `In -> Out`. So `iseven in Int -> Bool` and `add in Int x Int -> Int`. `In` is the function's **domain** and `Out` is the function's **codomain**.

(Note that while a function must map *from* every element of the domain, it does not need to map *to* every element of the codomain. The set "all outputs of a function" is called the **range**, and the range is always a subset of the codomain.

Note further that the codomain is a property of the function set. There's no way to take an individual function and figure out its codomain.)


Now we can explicitly construct a set of functions, we can quantify over the function set, for example to say "all commutative functions over the integers":

```
commutative = {f in Int x Int -> Int: all x, y in Int: f(x, y) = f(y, x)}
```


## Why can't we do the same with predicates?

The argument goes "well predicates are basically boolean functions, so we can quantify over the predicates by quantifying over the set of boolean functions".

Except there's no "set of boolean functions". In order to construct the function set you need *both* the domain and the codomain. So there's the set of all boolean functions on strings, the set of all boolean functions over strings, etc.

On top of that there's some predicates which don't correspond to Boolean functions, because they don't have a set "domain". This is getting into more abstract territory, but one rough example would be

```
Finite(s) = `s is a finite set`
```

If this were a function, the domain would be "everything", aka [universal set](https://en.wikipedia.org/wiki/Universal_set). And having a universal set causes paradoxes in set theory, so we don't want it to be possible. So it makes sense to distinguish "boolean functions" from "predicates". All boolean functions can be represented to predicates, but not all predicates correspond to boolean functions!

All that said, as long as we're working we're working with a known domain, we can safely "quantify over predicates" by sneakily replacing the predicates with boolean functions. This is sloppy but valid.


## A brief note on functional programming

[Haskell](https://www.haskell.org/) only allows functions to take one parameter. So how do we define something like `and(bool1, bool2)`, which takes two parameters? We use **currying**: have `and` take a bool and return a *function* in `Bool -> Bool`. So if `and` is normally this set:

```
{(t, t, t),
 (t, f, f),
 (f, t, f),
 (f, f, f)
}
```

Then the curried version of `and` is 

```
{(t, {(t, t),
      (f, f)
     })
 (f, {(t, f),
      (f, f)
     })
}
```

So instead of having type `Bool × Bool -> Bool`, it's `Bool -> (Bool -> Bool)`. Exercise for the reader: explain why all functions can be curried.

Incidentally, currying is vaguely why we can [reorder the indices](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.reorder_levels.html#pandas.DataFrame.reorder_levels) of a dataframe or transpose the rows and columns of a matrix: multidimensional arrays are equivalent to curried functions. I wrote a bit more about this [here](https://buttondown.com/hillelwayne/archive/2000-words-about-arrays-and-tables/).

### And admitting some guilt

Now, I keep using the model "types are sets of values", and polymorphic functions are one place that model breaks down. You can write this function in Haskell:

```haskell
id :: a -> a
id a = a
```

This has the same problem as `Finite`: the domain would be all sets, and the function would be a subset of "all values -> all values", which is impossible. Really what's happening here is that `a` is a **type variable**, and we can see this as basically meaning:

```
all a: Type(a) => some f in (a -> a): all x in a: f(x) = x
all a: Type(a) => id in (a -> a)
```

In other words, every concrete type like `Int` or `Set[Char]` or `Maybe Foo` has a corresponding function set `Int -> Int` or `Set[Char] -> Set[Char]` or `Maybe Foo -> Maybe Foo`, and one function in that set returns all inputs unchanged. 
