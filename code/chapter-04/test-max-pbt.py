"""This Python demo uses pytest (https://docs.pytest.org/en/stable/)
and Hypothesis (https://hypothesis.readthedocs.io/en/latest/).
both can be installed with `pip install pytest hypothesis`.
Run with `pytest test-max-pbt.py`."""

import hypothesis.strategies as s
from hypothesis import given

def good_max(l):
    return max(l)

def max_of_first_five(l):
    return max(l[0:4])

def max_of_absolute_value(l):
    return max(map(abs, l))

# Uncomment whichever one you want to test.
# f = good_max
f = max_of_first_five
# f = max_of_absolute_value

@given(s.lists(s.integers(), min_size=1))
def test_max(l):
    max_val = f(l) # our max function
    assert max_val in l                   # (a)
    assert all(max_val >= x for x in l)   # (b)
