from z3 import *

a, b, c = Reals('a b c')
solver = Solver()

solver.add(a >= b)
theorem = a*c >= b*c

result = solver.check(Not(theorem))
if result == sat: 
    print(solver.model())
    print(solver.model().evaluate(a*c))
    print(solver.model().evaluate(b*c))
elif result == unsat:
    print("Theorem is true")
else: # See end of section
    print("Answer unknown")
