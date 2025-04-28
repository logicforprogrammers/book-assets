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

% commit(id, author, [files_changed])
% written this way to be more compact
commit(a0, alice, [file(f1), file(f2), testfile(f2)]).
commit(a1, bob, [file(f1), file(f3), testfile(f1)]).
commit(a2, eve, [file(f1), file(f2), testfile(f1), testfile(f2)]).

% commit_author_file
caf(C, A, F) :-
    commit(C, A, Files),
    member(F, Files).

high_churn(File) :-
    caf(_, A1, File), caf(_, A2, File), caf(_, A3, File),
    A1 @< A2, A2 @< A3. % @< = ordering on atoms

untested_commit(file(File)) :-
    commit(_, _, Files),
    member(file(File), Files),
    \+ member(testfile(File), Files).

% fails_check just calls the check on the file
% Added for descriptivity
fails_check(File, Check) :- call(Check, File).

checks_failed(_, [], []).
checks_failed(File, [Check|Checks], Failed) :- 
  checks_failed(File, Checks, Failed), 
  \+ fails_check(File, Check).

checks_failed(File, [Check|Checks], [Check|Failed]) :- 
  checks_failed(File, Checks, Failed), 
  fails_check(File, Check).

checks_failed(File, Failed) :- 
  checks_failed(File, [high_churn, untested_commit], Failed).

file_suspicion(File, Suspicion) :-
    checks_failed(File, Failed),
    length(Failed, Suspicion).

/** <examples>

*/
