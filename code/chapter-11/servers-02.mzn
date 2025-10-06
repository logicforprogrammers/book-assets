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

output ["\(num)\n", "reqs=\(total_reqs), disk=\(total_disk)\n", "\(total_cost)\n"];

% we can place new constraints anywhere
array[Servers] of int: disk = [256, 256, 1536];
int: disk_goal = 5000;
var int: total_disk = sum (s in Servers) (disk[s] * num[s]);
constraint total_disk >= disk_goal;

array[Servers] of int: limit = [0, 6, 0];
constraint forall (s in Servers) 
  (limit[s] > 0 -> num[s] <= limit[s]);
