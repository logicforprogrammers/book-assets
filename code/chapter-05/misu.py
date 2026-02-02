"""This is a demo of Making Illegal States Unrepresentable in Python.

By making `status` an enumerable, we can enforce the top level invariant

!(available && cancelled)

In the structure of the item.

Note that Python is poorly equipped to actually enforce this invariant
and is only used to be consistent with the rest of the book.

"""
from dataclasses import dataclass
from enum import Enum

Status = Enum("Status", "available out_of_stock discontinued")

# invariant: !(available && discontinued)
@dataclass
class Item:
  name: str
  price: int # invariant: price > 0
  status: Status = Status.available

i = Item("a", 2, Status.available)
i2 = Item("a", 2, "blancelled") # Python typechecker raises an error (but still lets it run)

print(i)
