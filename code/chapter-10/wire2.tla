TLA+ is a formal specification language
that can verify abstract software models satisfy properties.
Learn more at https://tlapl.us

This requires `wire2.cfg` to work. It is also uses "PlusCal", a DSL for writing common kinds of specifications
To run in VSCode, first download both files, install the TLA+ extension, then run 

1. `TLA+: Parse Module` (translates Pluscal to TLA+)
2. `TLA+: Check Model with TLC`.
---- MODULE wire2 ----
EXTENDS TLC, Integers

People == {"alice", "bob"}
Money == 1..10
NumWires == 2

(* --algorithm wire
variables
  acct \in [People -> Money];

define
  NoOverdrafts ==
    [](\A p \in People:
      acct[p] >= 0)
end define;

process wire \in 1..NumWires
variable
  amnt \in 1..5;
  from \in People;
  to \in People
begin
  Check:
    if acct[from] >= amnt then
      Withdraw:
        acct[from] := acct[from] - amnt;
      Deposit:
        acct[to] := acct[to] + amnt;
    end if;
end process;
end algorithm; *)

====
