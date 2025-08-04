"""This python program was compiled from Dafny, see qr.dfy
It's missing some extra Dafny packages and will not run.
To compile qr.dfy yourself, do:
`dotnet dafny.dll build -t:py qr.dfy`
"""

# Dafny `qr` compiled into Python

import sys
from typing import Callable, Any, TypeVar, NamedTuple
from math import floor
from itertools import count

import module_ as module_
import _dafny as _dafny
import System_ as System_

# Module: module_

class default__:
    def  __init__(self):
        pass

    @staticmethod
    def qr(x, y):
        q: int = int(0)
        r: int = int(0)
        q = _dafny.euclidian_division(x, y)
        r = (x) - ((q) * (y))
        return q, r
