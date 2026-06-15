% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

set of int: Items = 1..10;
set of int: Bins = 1..3;
int: BinCapacity = 20;
array[Items] of int: size = [20, 1, 6, 14, 2, 16, 9, 14, 3, 1]; 
array[Items] of var Bins: bin; % bin[2] = 1 -> item 2 in bin 1

% the sum of the items in every bin should not exceed BinCapacity
% MiniZinc writes `all x in set: P(x)` as 
%     `forall (x in set) (P(x))`
constraint forall (b in Bins)
  (sum (i in Items) 
    % add only the items in that bin to get the bin's total
    % if-then-else makes this a nonlinear constraint
    (if bin[i] = b then size[i] else 0 endif) <= BinCapacity 
  );

solve satisfy;
