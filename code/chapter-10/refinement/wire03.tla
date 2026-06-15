TLA+ is a formal specification language
that can verify abstract software models satisfy properties.
Learn more at https://tlapl.us

This requires `wire03.cfg` to work.
To run in VSCode, first download both files, install the TLA+ extension, and run `TLA+: Check Model with TLC`.
---- MODULE wire03 ----
EXTENDS Integers

VARIABLES balance, state, data
vars == <<balance, state, data>>

People == {"alice", "bob"}
MaxWorkers == 2
Workers == 1..MaxWorkers

Init ==
  /\ balance = [p \in People |-> 10]
  /\ state = [w \in Workers |-> "Ready"]
  /\ data = [w \in Workers |-> "No Data"]

StartWire(w, sender, receiver, amount) ==
  /\ sender # receiver
  /\ balance[sender] >= amount
  /\ state[w] = "Ready"

  /\ state' = [state EXCEPT ![w] = "Transfer"]
  /\ data' = [data EXCEPT ![w] =
    [ sender |-> sender,
      receiver |-> receiver,
      amount |-> amount
    ]]
  /\ balance' = [balance EXCEPT ![sender] = @ - amount]

Transfer(w) ==
  /\ state[w] = "Transfer"
  /\ state' = [state EXCEPT ![w] = "Ready"]
  /\ balance' = [balance EXCEPT 
        ![data[w].receiver] = @ + data[w].amount
    ]
  /\ data' = [data EXCEPT ![w] = "No Data"]

Next ==
  \E w \in Workers:
    \/ Transfer(w)
    \/ \E sender, receiver \in People: 
         \E amount \in 1..balance[sender]:
           StartWire(w, sender, receiver, amount)

        
Spec == Init /\ [][Next]_vars 

NoOverdrafts ==
  [](\A p \in People:
    balance[p] >= 0)

Abstract == INSTANCE wire02 WITH balance <- balance
Refinement == Abstract!Spec \* ! is namespacing
====
