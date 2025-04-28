# requires `pip install z3-solver`
from z3 import *
solver = Solver()

modulus = eval(input("Enter modulus: "))
sequence = eval(input("Enter sequence: ")) # Separate with commas

a = Int('a')
c = Int('c')

solver.add(a >= 0, a < modulus)
solver.add(c >= 0, c < modulus)

for i in range(len(sequence) - 1):
    solver.add(sequence[i+1] == c + (a * sequence[i]) % modulus)

if solver.check() == sat:
    model = solver.model()
    print(f"a = {model[a].as_long()}")
    print(f"c = {model[c].as_long()}")
else:
    print("Could not find parameters")