# Partial Orders

In Testing:

> If P passes, Q also passes. If R passes, Q also passes. This means P => Q && R => Q.
P and R are stronger than Q in different ways: P gives a more specific answer for
the same input, while R gives the same answer for a superset of inputs. Neither R
nor P are stronger than each other: each will pass some version of max the other
would reject. Mathematicians would say that => forms a partial order 

> If ``P`` passes, ``Q`` also passes. If ``R`` passes, ``Q`` also passes. This means ``P => Q && R => Q``. ``P`` and ``R`` are stronger than ``Q`` in different ways: ``P`` gives a more specific answer for the same input, while ``R`` gives the same answer for a superset of inputs. Neither ``R`` nor ``P`` are stronger than each other: each will pass some version of ``max`` the other would reject. Mathematicians would say that ``=>`` forms a :dfn:`partial order` (:numref:`test-ordering`). 

Partial orderings are a useful concept that would have taken too many pages in the book, so I'm putting it here.

Let's start by analogy to the number line. We have an intuitive notion that numbers are "ordered", that 10 is bigger than 9 and 9 is bigger than 8. As with anything else that's interesting about numbers, we now have three math ideas to explore: 

1. Can we formalize our notion of "order"? 
2. What does being "ordered" tell us about numbers?
2. Do things besides numbers have "order", too? What does this "order" look like?

First, to formalize order, we notice that for any two integers `a ≤ b` has all of these properties:

1. It is **total**: `a ≤ b || b ≤ a`
2. It is **reflexive**: `a ≤ a`
3. It is **antisymmetric**: `a ≤ b && b ≤ a => a == b`
4. It is **transitive**: `(a ≤ b && b ≤ c) => a ≤ c`

This makes `≤` a **total order** on the integers.

Any set with a total ordering can be [stably sorted](https://en.wikipedia.org/wiki/Sorting_algorithm#Stability). That's why it's possible to put Webster dictionary in a book form, because there's a total ordering on English strings (lexicographic ordering). This is a really strong property! And it means that, by the ability-guarantee tradeoff, total orderings are "relatively rare". There are many more relations that are "ordering shaped" but don't satisfy all the properties of a total ordering. 

One example of a non-total ordering is "sorting a deck of cards by rank". It's clear that 6♠ ≤ 6♥, but also 6♥ ≤ 6♠, and yet 6♠ != 6♥. So "ordering by rank" isn't properly antisymmetric, so it can't be a total order. We can *make* it a total order by adding inducing an ordering on the suites, too, but "ordering by rank" by itself must be some sort of weaker kind of ordering. And in fact we say a [weak order](https://en.wikipedia.org/wiki/Weak_ordering) is one that allows "ties". A weak order guarantees that the set can be sorted, but not *stably* sorted.

Okay, so with all of that, a partial ordering is what we get when we throw away totality.

## Partial Ordering

The relation ≼ is a **partial order** on the set S if:

```
all a, b in S:
    1. a ≼ a
    2. (a ≼ b) && (b ≼ a) => a == b
    3. all c in S:
        (a ≼ b && b ≼ c) => a ≼ c
```

So it's still reflexive, antisymmetric, and transitive, but no longer total. Some mathematicians use `≤` instead of ≼ but I think that'll be confusing here. Similarly to `<`, we can define `a ≺ b` to mean `a ≼ b && a != b`. The canonical example is subsets: the set "all laptops" is a subset of both "all computers" and "all mobile electronics", which are both subsets of "all electronics". But neither "all computers" nor "all mobile electronics" is a subset of the other: a digital camera isn't a computer, and an IBM mainframe certainly isn't mobile!

We can't meaningfully sort a set on a partial order. Instead, we get the weaker property "we can put the set into a directed acyclic graph". And because DAGs crop up all over the place (along with the special case of trees),  a lot of things have interesting partial orders. Commit graph? Partial order. Type hierarchy? Partial order. Package dependencies? Partial order. 

### [Advanced] Test strength is "partially ordered"

Now, in the book, I said that `=>` forms a partial order. First of all, this is a lie-by-omission, because I never told you "on what set". On the booleans, `=>` forms a *total* order. In the context of the chapter, I was using `P => Q` as shorthand for "`all func:` if `func` passes test P then `func` passes test Q". In the language of partial orders:



```
P(x) ≼ Q(x) =
    all a: P(a) => Q(a)
```

But this has a new problem: a partial order is a property of a relation and a *set*. What is the set here? It can't be the set of predicates, because we're in first-order logic and we can't have sets of predicates. The answer is that I simplified things a little for the book. "Tests are predicates" is "morally correct": it's correct enough to do useful work with, and possible to make "correct" without caveats, but doing so is fiddly and would distract from the broader topic of the book. Here goes, though:


The basic idea is that we can sort of [mimic](https://www.hillelwayne.com/post/software-mimicry/) a "set of predicates" by creating a set of boolean functions, as in discussed in [quantifying over functions](function-sets.md). Define `[Int]⁺` to mean `NonemptyList[Int]`. If `max` has type `[Int]⁺ -> Int`, then it belongs to the *set of functions* `[Int]⁺ -> Int`. A "test of `max`", then, is any function that takes an element `candidate` of `[Int]⁺ -> Int` and returns true when passed in `max`. Then the set of all "tests of `max`" is a subset of `([Int]⁺ -> Int) -> Bool` and can be partially ordered by implication:

```
# For terseness, let [Int]⁺ mean [Int]⁺

TestsOfMax = {f in ([Int]⁺ -> Int) -> Bool: f(max)}

weak ≼ strong =
  all f in [Int]⁺ -> Int
    strong(f) => weak(f)

PartialOrdering(≼, TestsOfMax)
```

