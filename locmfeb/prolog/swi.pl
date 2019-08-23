
:-use_module(library(lists)).
%:-use_module(library(charsio)).

nth(A,B,C):-nth1(A,B,C).
suffix(X,Y):-append(_,X,Y).

format_to_atom(A,FmStr,Args):-
	format(atom(A), FmStr, Args).

system(Command):-
	shell(Command).
