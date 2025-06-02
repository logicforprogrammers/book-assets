"""This Python demo uses pytest (https://docs.pytest.org/en/stable/)
and Hypothesis (https://hypothesis.readthedocs.io/en/latest/).
both can be installed with `pip install pytest hypothesis`.
Run with `pytest test-refactoring.py`."""

import hypothesis.strategies as s
from hypothesis import given

def old_function(l, P, Q):
  if not all(P(x) for x in l) or any(not Q(x) for x in l):
    return 1
  else:
    return 2

def refactor(l, P, Q):
  if all(P(x) and Q(x) for x in l):
    return 2
  else:
    return 1

@given(s.lists(s.integers()), 
       s.functions(like=lambda x: ..., 
                   returns=s.booleans(), pure=True),
       s.functions(like=lambda y: ..., 
                   returns=s.booleans(), pure=True)
       )

def test_max(l, P, Q):
    assert old_function(l, P, Q) == refactor(l, P, Q)

