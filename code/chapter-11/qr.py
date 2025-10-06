from z3 import *

def qr(x, y):
  q = x / y # z3 floordiv
  r = x - q*y
  return (q, r)

# Variables
x, y, q, r = Ints('x y q r')

# Preconditions
requires = [x >= 0, y > 0]

# Postconditions
ensures = [
    q * y + r == x,     # a
    And(0 <= r, r < y), # b
    q >= 0              # c
]

s = Solver()

s.add(requires)
s.add(q == qr(x, y)[0])
s.add(r == qr(x, y)[1])

for e in ensures:
    if s.check(Not(e)) == sat:
        m = s.model()
        print(f"{e} violated: ", [m[x], m[y], m[q], m[r]])
    else:
        print(f"{e} holds")
