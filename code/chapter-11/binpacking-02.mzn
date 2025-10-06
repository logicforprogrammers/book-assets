% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

set of int: Items = 1..10;
set of int: Bins = 1..10;
int: N = 20;
array[Items] of int: size = [20, 1, 6, 14, 2, 16, 9, 14, 3, 1]; 
array[Items, Bins] of var 0..1: bin;
array[Bins] of var 0..1: used;

constraint forall (b in Bins)
    (sum (i in Items) (bin[i,b] * size[i]) <= N);

constraint forall (i in Items)
    (sum (b in Bins) (bin[i,b]) = 1);

constraint forall (b in Bins, i in Items)
    (bin[i, b] <= used[b]);

solve minimize sum(used);
