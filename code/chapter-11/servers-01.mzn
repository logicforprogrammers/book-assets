% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

set of int: Servers = 1..3;

array[Servers] of var 0..100: num;
array[Servers] of int: reqs = [460, 900, 500];
array[Servers] of int: cost = [3, 5, 6];

int: reqs_goal = 7500;

var int: total_reqs = sum (s in Servers) (reqs[s] * num[s]);
var int: total_cost = sum (s in Servers) (num[s] * cost[s]);

constraint total_reqs >= reqs_goal;
solve minimize total_cost;

output ["\(num)\n", "reqs=\(total_reqs)\n", "\(total_cost)\n"];
