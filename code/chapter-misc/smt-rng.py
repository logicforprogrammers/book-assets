"""This was the example of SMT solving in a previous version of the book.
The solver takes a sequence of outputs from a 'linear congruential generator' PRNG 
and tries to find the starting parameters of the RNG. 
"""
# requires `pip install z3-solver`
from z3 import *
solver = Solver()

modulus = 2**31
sequence = [4096, 618876929, 113892918, 1048278319]

a = Int('a')
c = Int('c')

solver.add(0 <= a, a < modulus)
solver.add(0 <= c, c < modulus)

for i in range(len(sequence) - 1):
    solver.add(sequence[i+1] == c + (a * sequence[i]) % modulus)

if solver.check() == sat:
    model = solver.model()
    print(f"a = {model[a].as_long()}")
    print(f"c = {model[c].as_long()}")
else:
    print("Could not find parameters.")
