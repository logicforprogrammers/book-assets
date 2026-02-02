% Clingo is an answer set programming language.
% Try this online: https://potassco.org/clingo-preview/



task(1..5). % task(1). task(2). etc.

worker(w1; w2). % worker(w1). worker(w2).
task_time(1,3;2,1;3,4;4,5;5,9). % task_time(1, 3). etc.

group(2..4, g1). % tasks 2,3,4 in group 1 
group_conflict(5, g1). % task 5 conflicts with g1

% Each task is assigned to exactly one worker
{ assigned(T, W): worker(W) } == 1 :- task(T).

% T is assigned to W if T2 is assigned to W and T, T2 share a group
% Each task is assigned to one worker 
%  => assigns whole group on same worker
assigned(T, W) :- assigned(T2, W), group(T, G), group(T2, G).

% Integrity constraint: CANNOT be the case that two tasks, 
% where one is in group G and the other conflicts with G, 
% share a worker.
:- assigned(T, W), assigned(T2, W), 
   group(T, G), group_conflict(T2, G).

% Total time each worker takes to complete all tasks
time(W, N) :- worker(W), 
  N = #sum{ Time, W, T: assigned(T, W), task_time(T, Time) }.

% Worst time is longest time any worker takes
worst(N) :- N = #max{X: time(_, X)}. 
#minimize {N: worst(N)}.
#show assigned/2.
#show time/2.
