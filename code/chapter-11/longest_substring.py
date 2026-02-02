# requires `pip install z3-solver`
import z3

strings = ["abcdef", "def", "bcdeg"]

# create the string solver variable 's',
# store reference in Python variable 'substr'
substr = z3.String('s') 

# set up optimizer
opt = z3.Optimize()
for s in strings:
    opt.add(z3.Contains(s, substr))

opt.maximize(z3.Length(substr))

if opt.check() == z3.sat:
    print(opt.model()[substr])
else:
    print("No overlapping string")
