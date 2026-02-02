from z3 import *

a,b,c = Reals('a b c')

solver = Solver()

solver.add(a >= b)
theorem = a*c >= b*c

if sat == solver.check(Not(theorem)):
  print(solver.model())
  print(solver.model().evaluate(a*c))
  print(solver.model().evaluate(b*c))
else:
  print("Theorem is true")
