# Errata for v1.0

On **page 15** [Text change]:

The text should read "We often use `=>` to only **check** an `all` on a subset of elements."

---

On **page 167** [Clarification of material]:

This is not an error per se, but the example of something that Z3 cannot solve:

```python
# this returns unknown
b = Real('b')
solver = Solver()
solver.add(2**b == 16)
```

This is only unsolvable over reals. If we replace the first line with `b = Int('b')` then Z3 *can* solve it. It should further be noted that this is due to new code added in 2023. A future release of Z3 may also be able to solve the `Real('b')` version.
