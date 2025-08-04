\* TLA+ is a formal specification language
\* that can verify abstract software models satisfy properties.
\* Learn more at https://tlapl.us

---- MODULE transfers2 ----
EXTENDS TLC, Integers

People == {"alice", "bob"}
Money == 1..10
NumTransfers == 2

(* --algorithm wire
variables
  acct \in [People -> Money];

define
  NoOverdrafts ==
    [](\A p \in People:
      acct[p] >= 0)
end define;

process wire \in 1..NumTransfers
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
