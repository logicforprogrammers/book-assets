"""
This file showcases the possible performance improvements of using
sets for certain data collections vs using regular lists.

To run the benchmarks, call this file directly with `python filename.py`.
"""

connections = {"alice": ["bob", "carol"],
               "bob": ["alice", "dave"],
               "carol": ["alice", "dave"],
               "dave": ["bob", "carol"]
               }

connections_as_set = {k: set(v) for k,v in connections.items()}

# These should really be type annotated, 
# but these are directly injected in the book and I didn't want the
# types to get in the way of the lesson. 
# Wish there was a way to put the types ABOVE a function!
# These also should have contracts for the same reason
# and were left out for the same reason.

def get_with_lists(user, conn_list):
    out = []
    for c in conn_list[user]:
        for u in conn_list[c]:
            if u != user and u not in out:
                out.append(u)
    return out


def get_with_sets(user, conn_set):
    out = set()
    for c in conn_set[user]:
        out |= conn_set[c] #union=
    out -= {user} #difference=
    return out

def test_all_bidirectional():
    for u, cs in connections.items():
        assert all(u in connections[c] for c in cs)

def test_equiv_gets():
    for u in connections:
        assert set(get_with_lists(u, connections)) == get_with_sets(u, connections_as_set)



# BENCHMARKS
from random import sample
from timeit import timeit

# These all need to be global, otherwise timeit
# can't recognize them 
# For simplicity, no more bidirectional graphs
m = 1000
bcl = {x: sample(range(m), k = 60) for x in range(m)}
bcs = {k: set(v) for k,v in bcl.items()}

def benchmark(iterations=100):
    assert set(get_with_lists(34, bcl)) == get_with_sets(34, bcs)
    print(f"{iterations} iterations of get_with_lists (sec): ", timeit("get_with_lists(34, bcl)", globals=globals(), number=iterations))
    print(f"{iterations} iterations of get_with_sets (sec): ",timeit("get_with_sets(34, bcs)", globals=globals(), number=iterations))
    print(f"{iterations} iterations of get_with_sets, incl conversion time (sec): ",timeit("bcs = {k: set(v) for k,v in bcl.items()}; get_with_sets(34, bcs)", globals=globals(), number=iterations))
    ...

if __name__ == "__main__":
    benchmark()
        
