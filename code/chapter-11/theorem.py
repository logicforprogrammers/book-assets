from z3 import *

a,b,c = Reals('a b c')
solver = Solver()

solver.add(a >= b)
theorem = a*c >= b*c

if sat == solver.check(Not(theorem)):
  print(solver.model())
else:
  print("Theorem is true")
