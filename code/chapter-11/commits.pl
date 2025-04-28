% This file uses SWI-Prolog. 
% Try this online: https://swish.swi-prolog.org/

% parent(X, Y) = X is the parent of Y
parent(a0, a1).
parent(a1, a2).
parent(a2, a3).
parent(a3, a4).
parent(a4, a5).
parent(a1, b1).
parent(b1, b2).
parent(b2, a4).
parent(b2, b3).

ancestor(A, Commit) :- parent(A, Commit).
ancestor(A, Commit) :- 
    parent(A, Y),
    ancestor(Y, Commit).

mergecommit(C) :-
    parent(P1, C),
    parent(P2, C),
    \+ (P1 = P2). % \+ is 'not'

branchcommit(C) :-
    parent(C, B1),
    parent(C, B2),
    \+ (P1 = P2).

ancestry(C, C, []).
ancestry(GP, C, [P|Ps]) :- parent(P, C), ancestry(GP, P, Ps).

/** <examples>

?- parent(a1, X).
?- parent(X, a1).
?- ancestor(X, a4).
?- ancestor(X, a5), \+ ancestor(X, b3).

?- mergecommit(C).
*/
