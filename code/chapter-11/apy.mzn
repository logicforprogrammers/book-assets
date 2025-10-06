% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

int: goal = 10000;
int: years = 20;
float: r = 0.03;

var 0..goal: c;
array[1..years] of var float: acct; % 1-indexed

constraint acct[1] = c;
constraint forall (i in 2..years)
 (acct[i] = acct[i-1]*(1+r) + c);
constraint acct[years] >= goal;

solve minimize c;
output ["c: \(c)\n", "Total contribution: \(c*years)\n"];
