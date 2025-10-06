% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

set of int: Items = 1..10;
set of int: Bins = 1..3;
int: N = 20;
array[Items] of int: size = [20, 1, 6, 14, 2, 16, 9, 14, 3, 1]; 
array[Items] of var Bins: bin;

constraint forall (b in Bins)
  (sum (i in Items) 
    (if bin[i] = b then size[i] else 0 endif) <= N
  );

solve satisfy;
