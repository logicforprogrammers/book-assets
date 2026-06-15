TLA+ is a formal specification language
that can verify abstract software models satisfy properties.
Learn more at https://tlapl.us

This requires `wire02.cfg` to work.
To run in VSCode, first download both files, install the TLA+ extension, and run `TLA+: Check Model with TLC`.
---- MODULE wire02 ----
EXTENDS TLC, Integers

VARIABLES balance
vars == <<balance>>

People == {"alice", "bob"}

Init ==
  balance = [p \in People |-> 10]

Wire(sender, receiver) ==
  /\ sender # receiver \* # means not equal 
  /\ \E amnt \in 1..balance[sender]:
      balance' = [balance 
        EXCEPT ![sender] = balance[sender] - amnt,
               ![receiver] = balance[receiver] + amnt
     ]

Next ==
  \E sender, receiver \in People:
    Wire(sender, receiver)

Spec == Init /\ [][Next]_vars 

NoOverdrafts ==
  [](\A p \in People:
    balance[p] >= 0)
====
