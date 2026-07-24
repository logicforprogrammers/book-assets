% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

set of int: Items = 1..10;
set of int: Bins = Items; % also 1..10
int: BinCapacity = 20;
array[Items] of int: size = [20, 1, 6, 14, 2, 16, 9, 14, 3, 1]; 
array[Items, Bins] of var 0..1: in_bin;
array[Bins] of var 0..1: bin_used;

constraint forall (b in Bins)
    (sum (i in Items) (in_bin[i,b] * size[i]) <= BinCapacity);

constraint forall (i in Items)
    (sum (b in Bins) (in_bin[i,b]) = 1);

constraint forall (b in Bins, i in Items)
    (bin_used[b] >= in_bin[i, b]);

% bin_used[1] + bin_used[2] + ...
solve minimize sum(bin_used);
