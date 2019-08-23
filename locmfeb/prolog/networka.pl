

:-op(500,fx,@).
:-op(500,fx,?).
:-op(510,xfy,=>). % object transition
:-op(512,xfy,:). % object transition

%:- include('ex/tyre.pl').
:-include('ex/rocket.pl').
%  :-include('ex/ace_freecell.pl').
% :-include('ex/ace_freecell_solved.pl').
% :-include('ex/blocks.pl')
% :-include('ex/blocks_04.pl')
% :-include('ex/freecell.pl')
% :-include('ex/freecell_win.pl')
% :-include('ex/IPC3_freecell.pl')
% :-include('ex/pipes_notankage_nontemporal.pl')


/*
Extract set of action transitions
 e.g. put_on_one_block-1, put_on_one_block-2

For each action transition, record a tuple
  tr(name,arg,sort,lhs_state,rhs_state),
  where lhs_state and rhs_state are initially variables

for each Object
  current state = initial substate of object
  for each step in sequence
    if object changes in step
      current state = lhs of action
*/

/*
Phase 2

For each sort
 For each state
  For each pair <incoming-outgoing>
   Hypothesise possible connections 
*/


go:-
	findall(L,sequence_task(L,_,_,_),Ls),
	once(t1(Ls)).

go(Max,Steps):-
	findall(L,(sequence_task(L,_,_,_),L=<Max),Ls),
	findall(Ln,(sequence_task(L,Seq,_,_),L=<Max,length(Seq,Ln)),Ns),
	sumlist(Ns,Steps),
	t1(Ls).

% variable names Obs/Obz Trs/Trz Srts/Strz
%   excludes/includes zero analysis
t1(Incs):-
%	setof(Ob-Srt,
%	        Label^(member(Label,Incs),
%                       object_in_sequence_from_init(Label,Ob,Srt)),
%		 Obs),
	setof(Ob,
	        Label^(member(Label,Incs),
                      object_in_sequence_blind(Label,Ob,Srt)),
		 Obs0),
	% snc zero ob
        findall(Ob-Srt,member(Ob,Obs0),Obs),
%        findall(Ob-Srt,member(Ob,Obs0),Obs),
	Obz=['zero0'-'zero'|Obs],
%        process_obs(Obs,Incs,Trs),
	write('Obz'=Obz),nl,
	process_obs(Obz,Incs,Trz),
	once(suffix([],Trz)),
	write('Trz'=Trz),nl,
	bind_sorts_by_obs(Obs,97), % "a"=[97]
%	bind_sorts(Trs,97),
	setof(Srt,Nm^Pos^LHS^RHS^(member(tr(Nm,Pos,Srt,LHS,RHS),Trz)),Srtz),
	delete(Srtz,zero,Srts),
	write('Srts'=Srts),nl,
	write('Srtz'=Srtz),nl,
	bind_states_for_sorts(Srtz,Trz),
	findall(Tr,(member(Tr,Trz),Tr=tr(_,_,Srt,_,_),Srt\='zero'),Trs),
	setof(St,A^P^St1^(member(tr(A,P,zero,St,St1),Trz);
                          member(tr(A,P,zero,St1,St),Trz)),ZeroSts),
	(ZeroSts=[_]->Trz1=Trs;Trz1=Trz),
        write('Trz'=Trz),nl,
        write('Trs'=Trs),nl,
        write('Obs'=Obs),nl,
	findall(S-Os,(member(S,Srtz),findall(Ob,member(Ob-S,Obz),Os)),SrtTab),
%	findall(S-Os,(member(S,Srts),findall(Ob,member(Ob-S,Obs),Os)),SrtTab),
	write('SrtTab'=SrtTab),nl,
	reprocess_sorts(Srts,Obs,Incs,Trs,Tppmis,SSVs),
	write('SSVs'=SSVs),nl,
	phase3_sorts(Tppmis,SSVs,Trs,Obs,Incs, P3s),
	write('%%%%%%%%%%%%%P3s'=P3s),
	generate_operators(Trz,SSVs,Tppmis,P3s,Pops),
	generate_tasks(Pops),
	draw_fsm(Trz1,SSVs, P3s),
	true.

% Objects from sequence, no sort info available
object_in_sequence_blind(Label,Ob,_Srt):-
	sequence_task(Label,Seq,_Goal,_Init),
	member(Act,Seq),
	Act =.. [_|Args],
	member(Ob,Args).

% Objects from init declaration - using sort info
object_in_sequence_from_init(Label,Ob,Srt):-
	sequence_task(Label,_Seqs,_Goal,Init),
	member(ss(Srt,Ob,_),Init).

process_obs([],_,_).
process_obs([Ob-Srt|Obs],Incs,Trs):-
	process_sequences(Incs,Ob,Srt,Trs),
	process_obs(Obs,Incs,Trs).
	
process_sequences([],_Ob,_Srt,_Trs).
process_sequences([Label|Incs],Ob,Srt,Trs):-
	sequence_task(Label,Seq,_Goal,_Init),
	process_actions(Seq,Ob,Srt,_,_,Trs),
	process_sequences(Incs,Ob,Srt,Trs).

process_actions([],_Ob,_Srt,SS,SS,_Trs).
process_actions([Act|Acts],Ob,Srt,SS0,SS2,Trs):-
	Act =.. [Name|Args],
	%nth(Pos,Args,Ob),
	Argz=['zero0'|Args],
	nth0(Pos,Argz,Ob),
%	(nth(Pos,Args,Ob);nth(Pos,Args,@Ob)),
	!, % Object changes in action
	memberchk(tr(Name,Pos,Srt,SS0,SS1),Trs),
	process_actions(Acts,Ob,Srt,SS1,SS2,Trs).
process_actions([_|Acts],Ob,Srt,SS0,SS1,Trs):-
	% object didn't occur in action
	process_actions(Acts,Ob,Srt,SS0,SS1,Trs).

% Attempt to name sorts after objects
bind_sorts_by_obs([],_).
bind_sorts_by_obs([Ob-Srt|Obs],N):-
	var(Srt),
	!,
	name(Ob,Obstr),
	prune_name(Obstr,Obstr1),
%	name(Srt,[N|Obstr1]), % safe - guarantees uniqueness
	name(Srt,Obstr1),   % unsafe - readable
	N1 is N+1,
	bind_sorts_by_obs(Obs,N1).
bind_sorts_by_obs([_|Obs],N):-
	bind_sorts_by_obs(Obs,N).

prune_name([C|Cs0],[C|Cs1]):-
	((C >= 65, C =< 90) ; (C >=97, C=<122)), % A-Z,a-z
	!,
	prune_name(Cs0,Cs1).
prune_name(_,[]).



% Name sorts a, b, c, ...
bind_sorts([],_).
bind_sorts([Tr|Trs],Ch0):-
	Tr=tr(_,_,Srt,_,_),
	var(Srt),
	!,
	name(Srt,[Ch0]),
	Ch1 is Ch0+1,
	bind_sorts(Trs,Ch1).
bind_sorts([_|Trs],Ch):-
	bind_sorts(Trs,Ch).

bind_states_for_sorts([],_).
bind_states_for_sorts([Srt|Srts],Trs):-
	bind_states(Trs,0,Srt),
	bind_states_for_sorts(Srts,Trs).

bind_states([],_,_).
bind_states([Tr|Trs],N0,Srt):-
	Tr=tr(_,_,Srt,LHS,RHS),
	!, % The right sort!
	bind_var(LHS,Srt,N0,N1),
	bind_var(RHS,Srt,N1,N2),
	bind_states(Trs,N2,Srt).
bind_states([_|Trs],N0,Srt):-
	bind_states(Trs,N0,Srt).

bind_var(St,Srt,N0,N1):-
	St=Srt-N0,
	!, 
	N1 is N0+1.
bind_var(_,_,N,N). % St already bound

%------------------------------------------------------------------------------
% transition pair parameter match instance

some_tppmi(Trs,Srt1,Tp):-
	member(tr(Op1,Pos1,Srt1,_St0 ,St1),Trs),
	member(tr(Op2,Pos2,Srt1,St1, _St2  ),Trs),

	% (St0=St1,St1=St2)->(
	% Make sure there is at least one transition out to another state
	memberchk(tr(_,_,_,St1,St3),Trs),St3\=St1,

	write(Op1),write(', '),write(Op2),nl,

	% ignore transitions to same state (possibly)
	% ignore same-transition pairs (tighter than above constraint) 
        % also questionable!
	% Removed 31/7/09 for ace_freecell problem
        % put_on_card_in_homecell -> put_on_card_in_homecell 
        %   (different args) problem.
	%Op1 \= Op2,

	member(tr(Op1,Pos3,Srt2,_,_),Trs), % Another arg of Op1
	Pos1 \= Pos3,
	member(tr(Op2,Pos4,Srt2,_,_),Trs), % Another arg of Op2
	Pos4 \= Pos2,

	Tp=tppmi(St1,Srt2, Pos1,Pos2, Op1-Pos3,Op2-Pos4, _,_V),

	write(Tp),nl.

%------------------------------------------------------------------------------
% Phase 2 - generate sets of parameter matches 
%------------------------------------------------------------------------------

reprocess_sorts([],_,_,_,[],[]).
reprocess_sorts([Srt|Srts],Obs,Incs,Trs,[Srt-Tppmis1|Stppmis],[Srt-SVs|SSVs]):-
	findall(Tp,some_tppmi(Trs,Srt,Tp),Tppmis),
	length(Tppmis,N),format("**** length tppmis=~w~n",[N]),
	%write('Tppmis'=Tppmis),nl,nl,
	reprocess_obs(Obs,Srt,Incs,Trs,Tppmis),
	filter_tppmis(Tppmis,Tppmis1),
	reduce_state_vars(Tppmis1,SVs),
	portray_tppmis(Tppmis1),
	write(SVs),nl,
	reprocess_sorts(Srts,Obs,Incs,Trs,Stppmis,SSVs).

reprocess_obs([],_,_,_,_).
reprocess_obs([Ob-Srt|Obs],Srt,Incs,Trs,Tppmis):-
	!, % Right sort
	reprocess_sequences(Incs,Ob,Srt,Trs,Tppmis),
	reprocess_obs(Obs,Srt,Incs,Trs,Tppmis).
reprocess_obs([_|Obs],Srt,Incs,Trs,Tppmis):-
	reprocess_obs(Obs,Srt,Incs,Trs,Tppmis).
	
reprocess_sequences([],_Ob,_Srt,_Trs,_).
reprocess_sequences([Label|Incs],Ob,Srt,Trs,Tppmis):-
%	format("sort=~w, seq=~w~n",[Ob,Label]),
	sequence_task(Label,Seq,_Goal,_Init),
	reprocess_actions(Seq,null,Ob,Srt,Trs,Tppmis),
	%format("sort=~w, seq=~w done~n",[Ob,Label]),
	reprocess_sequences(Incs,Ob,Srt,Trs,Tppmis).

% For Ob, step through action list
%   check pairs of actions Act0,Act1 for compatibility with 
%   precomputed Tppmi clauses.
% Act0 is last action (e.g. pickup(b1,g1)) that mentioned Ob
reprocess_actions([],_,_,_,_,_).
reprocess_actions([Act1|Acts],Act0,Ob,Srt,Trs,Tppmis):-
	Act1 =.. [_|Args],
	%format("Checking action ~w~n",[Act1]),
%	format("Comparing Ob=~w, Act1=~w, Act0=~w~n",[Ob,Act1,Act0]),
	(nth(Pos,Args,Ob);nth(Pos,Args,@Ob)),
	!, % Object changes in action
%	write('*'),
	test_tppmis(Tppmis,Act0,Act1),
	reprocess_actions(Acts,Act1,Ob,Srt,Trs,Tppmis).
reprocess_actions([_|Acts],Act0,Ob,Srt,Trs,Tppmis):-
%	write('.'),
	% object didn't occur in action
	reprocess_actions(Acts,Act0,Ob,Srt,Trs,Tppmis).

% Find matching Tppmi, if it is refuted bind its Valid variable
test_tppmis( [], _, _ ).
test_tppmis( [Tppmi|Tppmis], Act1, Act2 ):-
%	format("Checking ~w~n",[Tppmi]),
	Tppmi=tppmi(_,_, _PP1,_PP2, Nm1-P1,Nm2-P2, Seen,Valid),
%	format("Checked OK~n",[]),
	functor(Act1,Nm1,_),
	functor(Act2,Nm2,_), % Action names match
	!, 
	arg(P1,Act1,Ob1),
	arg(P2,Act2,Ob2),
	test_tppmi_args(Ob1,Ob2,Seen,Valid), % Do objects match?
%	(nonvar(Valid) -> format("*** Reject ~w~n",[Tppmi]); true),
	test_tppmis( Tppmis, Act1, Act2 ).
test_tppmis( [_|Tppmis], Act1, Act2 ):-
	test_tppmis( Tppmis, Act1, Act2 ).

test_tppmi_args(Ob,Ob,true,_Valid):-
	% Match - leave Valid unbound
	%       - bind seen to 'true'
	!.
test_tppmi_args(_,_,_,fail).
	% Refuted - bind to 'fail'


portray_tppmis([]).
portray_tppmis([Tppmi|Tppmis]):-
	Tppmi=tppmi(_,_, _,_, _,_, _,Valid),
%	nonvar(Valid),
	Valid == fail,
	!,
	write('Rejected '),write(Tppmi),nl,
	portray_tppmis(Tppmis).
portray_tppmis([Tppmi|Tppmis]):-
	write('Confirmed '),write(Tppmi),nl,
	portray_tppmis(Tppmis).

% Not used
filter_tppmis([],[]).
filter_tppmis([Tppmi|Tppmis0],[Tppmi|Tppmis1]):-
	Tppmi=tppmi(_,_, _,_, _,_, Seen,Valid),
	Seen == true,
	Valid \== fail,
	!,
	filter_tppmis(Tppmis0,Tppmis1).
filter_tppmis([T|Tppmis0],Tppmis1):-
	write('Rejected'=T),nl,
	filter_tppmis(Tppmis0,Tppmis1).
	


%------------------------------------------------------------------------------
% Two tppmis with same incoming transition argument
%  => unify variable
%
% Two tppmis with same outgoing transition argument
%  => unify variable
%
% Two tppmis which are self-arcs of to&from same state
%------------------------------------------------------------------------------

reduce_state_vars(Tppmis,SVs):-
	match_tppmis(Tppmis),
	collect_state_vars(Tppmis,1,SVs).

match_tppmis([]).
match_tppmis([T|Tppmis]):-
	match_rest_tppmis(Tppmis,T),
	match_tppmis(Tppmis).

match_rest_tppmis([],_).
match_rest_tppmis([T1|Tppmis],T0):-
	match_incoming(T0,T1),
	match_outgoing(T0,T1),
	match_self_pair(T0,T1),
	match_rest_tppmis(Tppmis,T0).

match_incoming(T0,T1):-
	T0=tppmi(St,_, _,_, Tr,_, _,V0),
	V0 \== fail,   % succeed when V0 is unbound  
	T1=tppmi(St,_, _,_, Tr,_ ,_,V1),
	V1 \== fail,
	!,
	V0=V1,
%	format("Unified ~w ~w~n",[T0,T1]),
	true.
match_incoming(_,_).

match_outgoing(T0,T1):-
	T0=tppmi(St,_, _,_, _,Tr, _,V0),
	V0 \== fail,   % succeed when V0 is unbound  
	T1=tppmi(St,_, _,_, _,Tr, _,V1),
	V1 \== fail,
	!,
	V0=V1.
match_outgoing(_,_).

match_self_pair(T0,T1):-
	T0=tppmi(St,Srt, _,_, Tr1,Tr2, _,V0),
	V0 \== fail,   % succeed when V0 is unbound  
	T1=tppmi(St,Srt, _,_, Tr2,Tr1, _,V1),
	V1 \== fail,
	!,
	V0=V1.
match_self_pair(_,_).

	

collect_state_vars([],_,[]).
collect_state_vars([Tppmi|Tppmis],N,SVs):-
	Tppmi=tppmi(_,_, _,_, _,_, _,V0),
	nonvar(V0),
	!,  % Already bound to name or 'fail'
	collect_state_vars(Tppmis,N,SVs).
collect_state_vars([Tppmi|Tppmis],N,[V0|SVs]):-
	Tppmi=tppmi(St,Srt, _,_, _,_, _,V0),
	V0=v(St,Srt,N),
	N1 is N+1,
	collect_state_vars(Tppmis,N1,SVs).

%------------------------------------------------------------------------------
%------------------------------------------------------------------------------

draw_fsm(Trs,SSVs, P3s):-
	setof(SS0,A^B^C^D^member(tr(A,B,C,SS0,D),Trs),Sts),
	write('Draw FSM Sts'=Sts),nl,
%	write('SSVs'=SSVs),nl,
	findall(node(St,SVs),
%	        (member(St,Sts),state_parameter(St,SSVs,SVs)),
	        (member(St,Sts),(state_parameter_prp(St,SSVs,P3s,SVs)->true;SVs=[])),
%	        (member(St,Sts),SVs=[]),
                Nodes),
	write('Nodes'=Nodes),nl,
	dot_graph(Trs,Nodes).

%state_parameters(Trs,SSVs,Nodes):-
%	findall(node(St,SVs),
%	        (member(St,Sts),state_parameter(St,SSVs,SVs)),
%                Nodes).

state_parameter(St,SSVs,SVs1):-
	St=Srt-_,
	memberchk(Srt-SVs,SSVs),
	findall(v(St,Srt1,N),member(v(St,Srt1,N),SVs),SVs1).

% for forming op - throw in a blank variable
state_parameter_op(St,SSVs,SVs1):-
	St=Srt-_,
	memberchk(Srt-SVs,SSVs),
	findall(v(St,Srt1,N,_),member(v(St,Srt1,N),SVs),SVs1).

state_parameter_prp1(St,SSVs,P3s,SVs2):-
	state_parameter_prp(St,SSVs,P3s,SVs1),
	findall(v(St1,Srt,N,_),member(v(St1,Srt,N),SVs1),SVs2).

state_parameter_prp(St,SSVs,P3s,SVs1):-
	St=Srt-_,
	memberchk(Srt-SVs,SSVs),
	memberchk(p3(Srt,Vsets,_EqHyps),P3s),
	findall(Var,
           (Var=v(St,_,_),
            member(Var,SVs),
	    % Don't include var if its Vset has been falsified
	    \+ memberchk(vset(Var,_,_,false),Vsets)),
           SVs1).

	
	
	
