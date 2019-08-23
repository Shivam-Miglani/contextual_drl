
generate_tasks(Pops):-
	% Cheating way to turn 'fake' variables into variables
	% (If you don't like grubby programming tricks, look away now)
        %format_to_chars("~w",[Pops],PC),read_from_chars(PC,Pops1),
        format(atom(PC),"~w",[Pops]),atom_to_term(PC,Pops1,_),
	%write('Pops1'=Pops1),nl,
	sequence_task(Label,Steps,_,_),
	setof(Ob,Srt^object_in_sequence_blind(Label,Ob,Srt),Obs),
	%once(write_list(Obs)),
	findall(ob(Ob,_,_),member(Ob,Obs),ObStatesInit),
	findall(ob(Ob,_,_),member(Ob,Obs),ObStatesGoal),
	reverse(Steps,RvsSteps),
	generate_task(Steps,ObStatesInit,Pops1,LHS*(LHS=>_  )),
	generate_task(RvsSteps,ObStatesGoal,Pops1,RHS*(_  =>RHS)),
	zero_state(Steps,Pops1,Zinit=>_),
	zero_state(RvsSteps,Pops1,_=>Zgoal),
	%write('Zinit'=Zinit),nl,
	%write('Zgoal'=Zgoal),nl,
	%nl,write(init),nl,once(write_list(ObStatesInit)),
	%nl,write(goal),nl,once(write_list(ObStatesGoal)),
	domain(Domain),
	pddl_task(Domain,Label,ObStatesInit,Zinit,ObStatesGoal,Zgoal,PddlTask),
	output_pddl_task(Domain,Label,PddlTask),
	fail.
generate_tasks(_).

generate_task([],_,_,_).
generate_task([Step|Steps],ObStates,Pops,Template):-
	matching_op(Pops,Step,_,Trs),
	set_arg_states(Trs,ObStates,Template),
	generate_task(Steps,ObStates,Pops,Template).

matching_op([Op0|_],Step,Ztr,Trs1):-
	\+ \+ Op0=operator(Step,_,_,_), % Test unifiable, but don't unify.
	!,
	copy_term(Op0,Op1),
	Op1=operator(Step,_,Ztr,Trs1).
matching_op([_|Pops],Step,Ztr,Trs1):-
	matching_op(Pops,Step,Ztr,Trs1).

% Final arg is a template in which Term contains State, 
% e.g. LHS*(LHS=>_), or RHS*(_=>RHS)
% (and State contains Arg)
set_arg_states([],_,_).
set_arg_states([Tr|Trs],ObStates,Template):-
	copy_term(Template,T1), % copy template before binding it
	T1=State*Term,
	Tr=tr(Arg:Srt,Term),
	(memberchk(ob(Arg,Srt,State),ObStates) -> true ; true),
	set_arg_states(Trs,ObStates,Template).

% The zero object has a transition at every step, so we only need
% to look at the first (or last)
zero_state([Step|_],Pops,Ztr):-
	matching_op(Pops,Step,Ztr,_).

%-----------------------------------------------------------------------------
% PDDL formatting of task description
%-----------------------------------------------------------------------------

% Problem name
% Object states
% Initial state
%   Statics
%   Object states
% Goal state

pddl_task(Domain,Prob,ObStatesInit,Zinit,ObStatesGoal,Zgoal,PddlTask):-
	format(atom(ProbName),"task_~w",[Prob]),
	pddl_ob_decls(ObStatesInit,PddlObs),
	pddl_preds([Zinit*[],Zgoal*[]],[PZinit,PZgoal]),
	pddl_fact_list(ObStatesInit,PddlInitDyn),
	pddl_fact_list(ObStatesGoal,PddlGoal),
	pddl_all_static_instances(PddlStatics),
	append(PddlStatics,PddlInitDyn,PddlInit),

	PddlTask=
          [define,[problem,ProbName],
	    [':domain',Domain],
            [':objects'|PddlObs],
            [':init',PZinit|PddlInit],
            [':goal',[and,PZgoal|PddlGoal]] ].
 
pddl_ob_decls1([],[]).
pddl_ob_decls1([ob(Ob,Srt,_)|ObStates],[Ob,'-',Srt|PddlObs]):-
	pddl_ob_decls1(ObStates,PddlObs).

pddl_ob_decls(ObStates,PddlObs):-
	setof(Srt,Ob^State^member(ob(Ob,Srt,State),ObStates),Srts),
	pddl_ob_srts(Srts,ObStates,PddlObs).

pddl_ob_srts([],_,[]).
pddl_ob_srts([Srt|Srts],ObStates,SrtDecls):-
	findall(Ob,member(ob(Ob,Srt,_),ObStates),SrtObs),
	append(SrtObs,[-,Srt|SrtDecls1],SrtDecls),
	pddl_ob_srts(Srts,ObStates,SrtDecls1).

pddl_fact_list([],[]).
pddl_fact_list([ob(_Ob,_Srt,State)|ObStates],[PddlFact|PddlFacts]):-
	State=..PddlFact,
	pddl_fact_list(ObStates,PddlFacts).

%-----------------------------------------------------------------------------
%-----------------------------------------------------------------------------

output_pddl_task(Domain,Label,PddlTask):-
	format(atom(File),"out/~w_task_~w.pddl",[Domain,Label]),
	format("Writing task file ~w~n",[File]),
	tell(File),
	write_thing(PddlTask),
	told.
