import math
from dataclasses import dataclass

@dataclass
class Item:
    name: str = ""
    price: int = 1 # typeinv: price > 0
    available: bool = True

# Note this shadows the builtin python max.
# I kept the same name to make the book explanation cleaner
# Also, it could be `assert l` due to python truthiness, I left it like this for non-python knowers
def max(l):
    assert l != [], "list must be nonempty"
    out = l[0]
    for i in l:
      if i > out:
        out = i
    assert out in l, "out must be in list"
    assert all(out >= x for x in l), "out must be max"
    return out

# Get max price of available items
def max_avail_price(items):
    avail = []
    for item in items:
        if item.available:
            avail.append(item.price)
    return max(avail)

if __name__ == "__main__":
    items = [Item("a", 0, True), Item("b", 4, False), Item("c", 2, False)]
    # vvv uncomment this to get an assertion failure
    # items = [Item("a", 0, False), Item("b", 4, False), Item("c", 2, False)]
    print(max_avail_price(items))
