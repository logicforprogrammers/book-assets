"""This was the example of SMT solving in a previous version of the book.
The solver tries to find four *distinct* positive numbers a, b, c, d 
such that (a+b == c+d) and (a*b == c*d).

The solver does not find a solution, meaning no such set exists.
If you replace n = 2 with n = 3 though, it looks for a set of six numbers
(a+b+c = d+e+f etc) and succeeds.
"""

# requires `pip install z3-solver`
import z3
n = 2
lhs = z3.IntVector("lhs", n)
rhs = z3.IntVector("rhs", n)

s = z3.Solver()
s.add(sum(lhs) == sum(rhs)) # a+b = c+d
s.add(z3.Product(lhs) == z3.Product(rhs)) # a*b=c*d
s.add(z3.Distinct(lhs + rhs)) # a!=b!=c!=d
for x in lhs + rhs: # all numbers >= 0
    s.add(x >= 0) 

if s.check() == z3.sat:
    m = s.model()
    l = [m[l].as_long() for l in lhs]
    r = [m[r].as_long() for r in rhs]
    print(l, r)
    print(f"sum={sum(l)} prod={z3.Product(l)}")
else:
    print("unsat")
