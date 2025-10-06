# requires `pip install z3-solver`
import z3

strings = ["abcdef", "def", "bcdeF"]
substr = z3.String('s')

opt = z3.Optimize()
for s in strings:
    opt.add(z3.Contains(s, substr))

opt.maximize(z3.Length(substr))

if opt.check() == z3.sat:
    print(opt.model()[substr])
else:
    print("No overlapping string")
