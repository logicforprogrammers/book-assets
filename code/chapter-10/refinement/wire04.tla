TLA+ is a formal specification language
that can verify abstract software models satisfy properties.
Learn more at https://tlapl.us

This requires `wire04.cfg` to work.
To run in VSCode, first download both files, install the TLA+ extension, and run `TLA+: Check Model with TLC`.
---- MODULE wire04 ----
EXTENDS Integers

VARIABLES true_balance, state, data, shown_balance
vars == <<true_balance, state, data, shown_balance>>

People == {"alice", "bob"}
MaxWorkers == 2
Workers == 1..MaxWorkers

Init ==
  /\ true_balance = [p \in People |-> 10]
  /\ state = [w \in Workers |-> "Ready"]
  /\ data = [w \in Workers |-> "No Data"]
  /\ shown_balance = true_balance

StartWire(w, sender, receiver, amount) ==
  /\ sender # receiver
  /\ true_balance[sender] >= amount
  /\ state[w] = "Ready"

  /\ state' = [state EXCEPT ![w] = "Transfer"]
  /\ data' = [data EXCEPT ![w] =
    [ sender |-> sender,
      receiver |-> receiver,
      amount |-> amount
    ]]
  /\ true_balance' = [true_balance EXCEPT ![sender] = @ - amount]
  /\ shown_balance' = [shown_balance EXCEPT 
       ![sender] = @ - amount,
       ![receiver] = @ + amount
     ]

Transfer(w) ==
  /\ state[w] = "Transfer"
  /\ state' = [state EXCEPT ![w] = "Ready"]
  /\ true_balance' = [true_balance EXCEPT 
        ![data[w].receiver] = @ + data[w].amount
    ]
  /\ data' = [data EXCEPT ![w] = "No Data"]
  /\ UNCHANGED <<shown_balance>>

  

Next ==
  \E w \in Workers:
    \/ Transfer(w)
    \/ \E sender, receiver \in People: 
         \E amount \in 1..true_balance[sender]:
           StartWire(w, sender, receiver, amount)

      
Spec == Init /\ [][Next]_vars

NoOverdrafts ==
  [](\A p \in People:
    true_balance[p] >= 0)

Abstract == INSTANCE wire02 WITH balance <- shown_balance
Refinement == Abstract!Spec

====
