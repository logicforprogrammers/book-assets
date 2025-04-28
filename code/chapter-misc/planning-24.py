% This was the example of planning in a previous version of the book.
% This solves the "24" puzzle (https://en.wikipedia.org/wiki/24_(puzzle))
% Language is picat: https://picat-lang.org/

import planner, math.

final([N]) =>
  N =:= 24. % handle floating point

action(S0, S1, Action, ActionCost) =>
  member(X, S0)
  , S0 := delete(S0, X)
  , member(Y, S0)
  , S0 := delete(S0, Y)
  , (
      A = $add(X, Y), S1 = S0 ++ [X + Y]
    ; A = $sub(X, Y), S1 = S0 ++ [X - Y]
    ; A = $mult(X, Y), S1 = S0 ++ [X * Y]
    ; A = $div(X, Y), Y > 0, S1 = S0 ++ [X / Y]
    )
  , Action = {A, S1}
  , ActionCost = 1
  .

main =>
  Start = [3, 3, 8, 8]
  , best_plan(Start, Plan)
  , writeln(Start)
  , foreach(Action in Plan)
      writeln(Action)
    end
  , nl
  .
