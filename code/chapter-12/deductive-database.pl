% SWI-Prolog is a logic programming language.
% Try this online: https://swish.swi-prolog.org/

% file(f1) = "the file f1"
% testfile(f1) = "the file that tests file f1"
% commit(id, author, [files_changed])
commit(a0, alice, [file(f1), file(f2), testfile(f2)]).
commit(a1, bob, [file(f1), file(f3), testfile(f1)]).
commit(a2, eve, [file(f1), file(f2), testfile(f1), testfile(f2)]).

% helper rule commit_author_file
% true iff author A changed filed F as part of commit C
caf(C, A, F) :-
    commit(C, A, Files), % Variable Files unifies to a list
    member(F, Files). % F is a value of that list

high_churn(File) :-
    caf(_, A1, File), caf(_, A2, File), caf(_, A3, File),
    A1 @< A2, A2 @< A3. % `@<` compares atoms. 
                        % easy way to make them distinct 

untested_commit(file(File)) :-
    commit(_, _, Files),
    member(file(File), Files),
    \+ member(testfile(File), Files).

% helper rule to use in `file_problems` setof's `Goal`
% note the rule definition uses both atoms and variables
has_problem(high_churn, File) :- high_churn(File).
has_problem(untested_commit, File) :- untested_commit(File).

file_problems(File, Problems) :-
    setof(Problem, has_problem(Problem, File), Problems).

file_suspicion(File, Suspicion) :-
    % set Problems to list of file problems
    file_problems(File, Problems), 
    % make Suspicion = length of Problems
    length(Problems, Suspicion). 

/** <examples>
?-	caf(_, alice, testfile(F)).
?- commit(C, _, _Files), member(file(_F), _Files), \+ member(testfile(_F), _Files).
?- file_suspicion(F, S).
?- file_problems(file(f3), P).
?- file_problems(F, P).
*/
