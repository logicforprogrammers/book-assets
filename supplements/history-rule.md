In *Composing Code Correctly*:

> The type newtype is compatible with oldtype when:
>
> 1. Every method of oldtype must be replaceable with the corresponding method of newtype, as discussed [earlier in the chapter].
> 2. Every value of newtype must satisfy the type invariants of oldtype, or `all n in newtype: NewInvariants(n) => OldInvariants(n)`.

There's one more obscure bit to the replacement rule in subtyping: the **history rule** says that the subtype must have a compatible history to the supertype. Imagine we have an AI in a game with the following code:

```
class AI {
  x = 2 # typeinv >= 0
  
  # requires x > 0
  # ensures x' == x - 1
  good_move() {
   # logic
   x = x - 1;
  }
  
  # ensures x' > 0
  bad_move() {
    # logic
    x = 2;
  }
  
  make_move() {
    if x == 0 { bad_move(); }
    else {
        randomly_pick_good_or_bad()
  }
}
```

If we subtype this with `BetterAI`, where the only difference is `BetterAI.x == 99`, we're still compatible with all of the contracts and type invariants, but we violate the history rule of "the AI can't do three good moves in a row".

We can convert the history rule into a type invariant by adding a `history` field to a type. 

```
[bad_move, good_move, good_move, ...]
```

Then the history rule becomes `all i in 0..<len(history): bad_move in history[i..=i+3]`.

Liskov's History Rule in [A Behavioral Notion of Subtyping](https://www.cs.cmu.edu/~wing/publications/LiskovWing94.pdf) Gives the example of a history rule in an append-only set: `x in set => x in set'`. This is a history rule only over successor states, though, which is why I tried to find a good example of one over any sequence of states.
