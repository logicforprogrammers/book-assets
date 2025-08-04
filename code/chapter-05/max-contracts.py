"""This Python demo uses pytest (https://docs.pytest.org/en/stable/)
and Hypothesis (https://hypothesis.readthedocs.io/en/latest/).
both can be installed with `pip install pytest hypothesis`.
Run with `pytest test-refactoring.py`."""

import hypothesis.strategies as s
from hypothesis import given

# Note this shadows the builtin python max.
# I kept the same name to make the book explanation cleaner
def max(l):
    assert len(l) > 0 # (a)
    out = l[0]
    for i in l:
      if i > out:
        out = i
    assert out in l #(b)
    assert all(out >= x for x in l) 
    return out

# An incorrect implementation of max
# you can enable it by uncommenting the below line

def bad_max_absolute_value(l: list[int]):
    assert len(l) > 0
    out = l[0]
    for i in map(abs, l):
      if i > out:
        out = i
    assert out in l
    assert all(out >= x for x in l)
    return out

# Uncomment this to see the tests fail
# max = bad_max_absolute_value

@given(s.lists(s.integers(), min_size=1))
def test_max(l):
    max(l)
