TLA+ is a formal specification language
that can verify abstract software models satisfy properties.
Learn more at https://tlapl.us

This requires `wire.cfg` to work.
To run in VSCode, first download both files, install the TLA+ extension, and run `TLA+: Check Model with TLC`.
---- MODULE wire ----
\* marks a comment
EXTENDS TLC, Integers \* imports

VARIABLES alice, bob \* variables
vars == <<alice, bob>> \* sequence [alice, bob]

Init == \* == is definition
  alice = 10 
  /\ bob = 10

AliceToBob ==
  \E amnt \in 1..alice: \* \E means "some"
    alice' = alice - amnt
    /\ bob' = bob + amnt

BobToAlice ==
  \E amnt \in 1..bob:
    alice' = alice + amnt
    /\ bob' = bob - amnt

Next ==
  AliceToBob
  \/ BobToAlice

\* [][Next]_vars means [](Next \/ vars' = vars)
\* Since vars is a list of all variables
\* It means "Next or stutter"
Spec == Init /\ [][Next]_vars 

\* Our property
NoOverdrafts ==
  [](alice >= 0 /\ bob >= 0)

====
