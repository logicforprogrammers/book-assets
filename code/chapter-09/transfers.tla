\* TLA+ is a formal specification language
\* that can verify abstract software models satisfy properties.
\* Learn more at https://tlapl.us

---- MODULE transfers ----
EXTENDS TLC, Integers

VARIABLES alice, bob
vars == <<alice, bob>>

Init ==
  alice = 10 
  /\ bob = 10

AliceToBob ==
  \E amnt \in 1..alice:
    alice' = alice - amnt
    /\ bob' = bob + amnt

BobToAlice ==
  \E amnt \in 1..bob:
    alice' = alice + amnt
    /\ bob' = bob - amnt

Next ==
  AliceToBob
  \/ BobToAlice

Spec == Init /\ [][Next]_vars \* [](Next \/ Stutter)

NoOverdrafts ==
  [](alice >= 0 /\ bob >= 0)

====
