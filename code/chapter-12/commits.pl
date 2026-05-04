% SWI-Prolog is a logic programming language.
% Try this online: https://swish.swi-prolog.org/

% parent(X, Y) = X is the parent of Y
% These are all facts. a0, a1, etc. are atoms
parent(a0, a1).
parent(a1, a2).
parent(a2, a3).
parent(a3, a4).
parent(a4, a5).
parent(a1, b1).
parent(b1, b2).
parent(b2, a4).
parent(b2, b3).

% parents are ancestors
ancestor(A, Commit) :- parent(A, Commit).

% parents of ancestors are ancestors
ancestor(A, Commit) :- 
    parent(A, Y),
    ancestor(Y, Commit).

% A rule, defined with :-
% Note it uses two internal variables, P1 and P2
mergecommit(C) :-
    parent(P1, C), 
    parent(P2, C), 
    \+ (P1 = P2). % `\+` is 'not'

branchcommit(C) :-
    parent(C, B1),
    parent(C, B2),
    \+ (B1 = B2).

ancestry(C, C, []).
ancestry(GP, C, [P|Ps]) :- parent(P, C), ancestry(GP, P, Ps).

/** <examples>

?- parent(a1, X).
?- parent(X, a1).
?- ancestor(X, a4).
?- ancestor(X, a5), \+ ancestor(X, b3).

?- mergecommit(C).
*/
