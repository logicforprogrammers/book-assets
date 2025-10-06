"""This is a script that calculates, for a certain APY and time length,
What minimum contribution is required to reach a goal value.

This is provided as a comparison benchmark to apy.mzn.
We have to provide an algorithm to find the optimum, in this case via a binary search.
This is also much, much faster than the constraint solver version. 
"""

from time import time_ns

def total_returns(c: int, irate: float, years: int) -> float:
    out = c
    for _ in range(years-1): # years - 1
        out = out * (1 + irate) + c
    return out

start = time_ns()
print(start)
goal = 10000
lo, hi = 0, goal
i = (lo + hi) // 2

while True:
    x = total_returns(i, 0.03, 20)
    if x > goal:
        hi, i = i, (lo + i)//2
    elif x < goal:
        lo, i = i, (i + hi)//2
    if i in (lo, hi):
        break

print(hi)
print(time_ns())
print(f"time (ms): {(time_ns() - start) / 1_000_000}")
