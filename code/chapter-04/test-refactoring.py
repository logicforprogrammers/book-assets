"""This Python demo uses pytest (https://docs.pytest.org/en/stable/)
and Hypothesis (https://hypothesis.readthedocs.io/en/latest/).
both can be installed with `pip install pytest hypothesis`.
Run with `pytest test-refactoring.py`."""

import hypothesis.strategies as s
from hypothesis import given

# Some complicated arbitrary predicates
P = lambda x: hash(x) % 17 < 7
Q = lambda x: hash(x) % 59 < 50

def old_function(l):
  if not all(P(x) for x in l) or any(not Q(x) for x in l):
    return "do_thing()"
  else:
    return "do_other_thing()"

def refactor(l):
  if all(P(x) and Q(x) for x in l):
    return "do_other_thing()"
  else:
    return "do_thing()"

@given(s.lists(s.text()))
def test_max(l):
    assert old_function(l) == refactor(l)
