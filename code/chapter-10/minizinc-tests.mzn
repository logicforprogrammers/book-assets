% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

int: T = 10; % number tests 
int: S = 2; % number servers
set of int: Servers = 1..S;
set of int: Tests = 1..T;

array[Tests] of int: test_times = [5, 6, 3, 7, 4, 3, 4, 4, 6, 9];
array[Tests] of int: group = [0, 0, 1, 1, 2, 0, 1, 0, 0, 2];
array[Tests] of var Servers: assignment;

function var int: total_time(var int: s) =
  sum([test_times[t] | t in Tests where assignment[t] = s]);

constraint forall (t1, t2 in Tests) 
  (group[t1] = group[t2] /\ group[t1] != 0 
    -> assignment[t1] = assignment[t2]);

function var int: num_assigned(var int: s) =
  count(assignment, s);

constraint forall (s1, s2 in 1..S) 
  (abs(count(assignment, s1) - count(assignment, s2)) <= 1);

solve minimize max([total_time(s) | s in 1..S]);

output [
    "Server \(s): \([t | t in Tests where assignment[t] = s])"
       ++ " (\(sum([test_times[t] | t in Tests 
                  where assignment[t] = s])))\n" 
    | s in 1..S
];
