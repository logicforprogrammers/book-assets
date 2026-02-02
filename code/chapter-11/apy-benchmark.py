"""This is a script that calculates, for a certain APY and time length,
What minimum contribution is required to reach a goal value.

This is provided as a comparison benchmark to apy.mzn.
We have to provide an algorithm to find the optimum, in this case via a binary search.
This is also much, much faster than the constraint solver version. 
"""

from time import time_ns

def total_returns(c: int, irate: float, years: int) -> float:
    assert years >= 1
    assert irate > 0.0
    out = 0
    for _ in range(years):
        out = out * (1 + irate) + c
    assert out >= c * years
    return out

start = time_ns()
goal = 10000
years = 20
irate = 0.03
lo, hi = 0, goal
i = (lo + hi) // 2

while True:
    assert lo <= i <= hi, f"{(lo, i, hi)}" # loop invariant
    x = total_returns(i, irate, years)
    if x > goal:
        hi, i = i, (lo + i)//2
    elif x < goal:
        lo, i = i, (hi + i)//2
    if i in (lo, hi):
        break

print(f"time (ms): {(time_ns() - start) / 1_000_000}")
assert total_returns(hi, irate, years) >= goal
assert total_returns(lo, irate, years) < goal
print(hi)
