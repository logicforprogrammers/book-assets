TLA+ is a formal specification language
that can verify abstract software models satisfy properties.
Learn more at https://tlapl.us

This requires `wire03.cfg` to work.
To run in VSCode, first download both files, install the TLA+ extension, and run `TLA+: Check Model with TLC`.
---- MODULE wire03 ----
EXTENDS Integers

VARIABLES 
  balance, \* Each user's balance
  state,   \* The state of a wire
  data     \* For transferring wires, who sends how much to who

vars == <<balance, state, data>>

People == {"alice", "bob"}
MaxWorkers == 2
Workers == 1..MaxWorkers

Init ==
  /\ balance = [p \in People |-> 10]
  /\ state = [w \in Workers |-> "Ready"]
  /\ data = [w \in Workers |-> "No Data"]

StartWire(w, sender, receiver, amount) ==
  /\ sender # receiver \* Can't send to yourself
  /\ balance[sender] >= amount
  /\ state[w] = "Ready" \* Worker goes Ready -> Transfer

  /\ state' = [state EXCEPT ![w] = "Transfer"]
  /\ data' = [data EXCEPT ![w] = \* Store wire data for next step
    [ sender |-> sender,
      receiver |-> receiver,
      amount |-> amount
    ]]
  /\ UNCHANGED balance \* equiv. to balance' = balance

Transfer(w) ==
  /\ state[w] = "Transfer" \* Worker goes Transfer -> Ready

  /\ state' = [state EXCEPT ![w] = "Ready"]
  /\ balance' = [balance EXCEPT
        \* @ is shorthand for "the original value"
        ![data[w].sender] = @ - data[w].amount, 
        ![data[w].receiver] = @ + data[w].amount
    ]
  /\ data' = [data EXCEPT ![w] = "No Data"] \* Wipe data

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
====
