
%------------------------------------------------------------------------------
%Statics would be declared like this:
%static( stackable(C1,C2), put_on_card_in_column(C1,C2,_) ).
%static( next(C1,C2),      put_on_card_in_homecell(C1,C2,_) ).
%------------------------------------------------------------------------------

%static( stackable(C1,C2), put_on_card_in_column(C1,C2) ).
%static( next(C1,C2),      put_on_card_in_homecell(C2,C1,_) ).
%static( first(C1),        put_in_empty_homecell(C1,_) ).

static(_,_):-fail.

% Note: doesn't use any restriction on which sequences to use
all_static_instances(Precs):-
	findall(Prec,static_instance(Prec),Precs).
	
static_instance(Prec):-
	static(Prec,Header),
	sequence_task(_,Steps,_,_),
	member(Header,Steps).

pddl_all_static_instances(PddlPrecs1):-
	findall(PddlPrec,(static_instance(Prec),Prec=..PddlPrec),PddlPrecs),
	sort(PddlPrecs,PddlPrecs1).
	

process_statics(Statics):-
	findall(s(Header,Prec,Instances),
           (static(Prec,Header),
            process_static(Prec,Header,Instances)),
           Statics).

% s( Header, Pair, Instances ).
process_static(Prec,Header,Instances):-
	% Prec and header share some unbound variables
	findall(Prec, 
                (sequence_task(_N,Seq,_,_),member(Header,Seq)),
                Instances0),
	sort(Instances0,Instances).

dump_statics:-
	static(Prec,Header),
	process_static(Prec,Header,Instances),
	nl,write(Header),nl,
	write_dot(Instances),nl.

write_dot(Instances):-
	member(Fact,Instances),
	Fact=..[Pred,Arg1,Arg2],
	format("~w -> ~w [label=~w];~n",[Arg1,Arg2,Pred]),
	fail.

