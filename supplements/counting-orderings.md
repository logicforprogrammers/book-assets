# Counting Execution Orderings

In System Modeling:

> Concurrent and distributed systems are notoriously difficult for programmers to design, simply due to the sheer number of ways things can go wrong. If we have three processes execute simultaneously, and each takes three linear steps to complete, **there are 1,680 possible execution orderings.** If even one of those orderings leads to a bug then the whole system must be fixed. And it's hard to know if we actually fixed the bug if it only happened on 0.1% of executions.

How do we get that number?

Let's start with the simpler case where each process has only one step. The first executes `A`, the second `x`, and the third `1`. We can brute force all possible interleavings:

```
Ax1
A1x
1Ax
1xA
x1A
xA1
```

That's six total. This is equivalent of finding every possible ordering (or **permutation**) of three elements, which is `3! = 3*2*1 = 6`. If we had nine processes of one step each, there would be `9! = 362880` interleavings. 

Now, let's say we only keep permutations with the subsequence `ABC`? Let's see what happens to these six orderings: 

```
AxBy123zC
AxCy123zB
BxAy123zC
BxCy123zA
CxBy123zA
CxAy123zB
```

The first one, with the subsequence `ABC`, remains. The other three, with subsequences `ACB`, `BAC`, etc are thrown away. More generally, we can take any sequence and generate a set of `3!` sequences by permuting the order of `A`, `B`, and `C`. Of this `3!`-element set only one element contains the subsequence `ABC`. This means that only `9!/3! = 60480` permutations contain the subsequence `ABC`.

By the same logic, only `(9!/3!)/3!` interleavings contain subsequences `ABC` *and* `xyz`, and only `((9!/3!)/3!)/3!` contain all three of `ABC`, `xyz`, and `123`. That gives us 1680 as expected. 

We can generalize this with a little algebra. First of all, `(a/b)/c == a/(b*c)`. Second, we get `9!` because we had three processes with three steps each, and `3+3+3 = 9`. So the more general form of the equation is `(3!+3!+3!)/(3!*3!*3!)`.

To check this, let's try three special cases. The first our previous three processes with one step each. This would be `(1+1+1)!/(1!*1!*1!)`, which is just `3!`. The second is a single three-step process. This is `3!/3! = 1`, which makes sense because one process has no concurrency. Finally, try one single step process and one `N` step process. Intuitively, the first process can happen either before the second process starts, or after any one of its N steps, so there should be `N+1` interleavings total. Applying the formula, we get `(N+1)!/(N!*1!) = (N+1)!/N! = N+!`, which matches our intuition.

Note this all assumes that two processes can't take steps simultaneously. If `Ax1` is considered distinct from `A[x1]`, then we have to drag out [higher-dimension Delannoy paths](https://raku-advent.blog/2024/12/11/day-11-counting-up-concurrency/).
