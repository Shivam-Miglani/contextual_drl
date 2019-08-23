
% PROPAGATE CODE MOSTLY DISABLED IN THIS VERSION
%   - ALL PARAMETER FLAWS LEAD TO POISONED VSETS WITH NO TESTING OF SEQUENCE

phase3_sorts([],_,_,_,_,[]).
phase3_sorts([Srt-Tppmiset|Tppmis],SSVs,Trs,Obs,Incs, [p3(Srt,Vsets,EqHyps1)|P3s]):-
	write('Srt'=Srt),nl,
	memberchk(Srt-Vars,SSVs),
	write('Vars'=Vars),nl,
%	findall(vset(Var,Sts,Trs1,_OK),
	findall(vset(Var,Sts,Trs1,false), % Poison all vsets!
	        process_anoms(Trs,Vars,Tppmiset,Var,Sts,Trs1),
                Vsets),
	write('Vsets'=Vsets),nl,
	EqHyps1=[],
	nl,portray_vsets(Vsets),nl,
	phase3_sorts(Tppmis,SSVs,Trs,Obs,Incs,P3s).

process_anoms(Trs,SSVs,Tppmis,Var,Sts,Trs1):-
	state_var_anomaly(Trs,SSVs,Tppmis,An),
	write(An),nl,
	An=anom(Var,Tr),
	write('#######################anomaly'=An),nl,
	Tr=tr(_,_,_,St0,St1),
	extra_vars(St0-Tr,Trs,SSVs, [St1],Sts, [],Trs1).

% Poison a vset if, for some transition in the vset,
%   there is a corresponding transition between same states
%   which isn't in the vset (?)
poison_vsets([],_).
poison_vsets([Vset|Vsets],Trs0):-
	Vset=vset(_Var,_Sts,Trs1,OK),
	member(tr(_,_,_,St0,St1),Trs1),
	Tr0=tr(_,_,_,St0,St1),
	member(Tr0,Trs0),
	\+memberchk(Tr0,Trs1),
	!,
	format("%%%%%%%%%%%%%%%%%%%% Poisoning ~w~n",[Vset]),
	OK=false,
	poison_vsets(Vsets,Trs0).
poison_vsets([_|Vsets],Trs):-
	poison_vsets(Vsets,Trs).
	

% State variable anomaly:
%   State has some variable V
%     there are transitions into state which do not set V

state_var_anomaly(Trs,Vars,Tppmis1,anom(Var,Tr)):-
	Var=v(St1,_VSrt,_Vn),
	member(Var,Vars), % Var=v(St1,VSrt,Vn)
	Tr=tr(Act0,Argn,_Srt,_St0,St1), % Tr is some transition to St1
	member(Tr,Trs), 
	% Template for some transition to St1, through Act0-Argn, setting Var
	Tppmi=tppmi(St1,_Srt1,Argn,_,Act0-_,_Act1-_,true,Var),
	\+memberchk(Tppmi,Tppmis1).

/*
Follow transitions backwards and collect connected nodes
*/
extra_vars(St1-Tr1,_,_, Sts,Sts, Trs,[Tr1|Trs]):-
	memberchk(St1,Sts),
	!.
extra_vars(St1-Tr1,Trs,SSVs, Sts0,Sts1, Trs0,Trs1):-
	write(St1),nl,
	findall(St0-Tr,
	        (Tr=tr(_,_,_,St0,St1),
		 member(Tr,Trs)),
		Sts),
	extra_vars_list(Sts,Trs,SSVs, [St1|Sts0],Sts1, [Tr1|Trs0],Trs1).

extra_vars_list([],_Trs,_SSVs, Sts,Sts, Trs,Trs).
extra_vars_list([St|Sts],Trs,SSVs, Sts0,Sts2, Trs0,Trs2):-
	extra_vars(St,Trs,SSVs, Sts0,Sts1, Trs0,Trs1),
	extra_vars_list(Sts,Trs,SSVs, Sts1,Sts2, Trs1,Trs2).

% Half-step from transition into St1, setting value of Var as Op1-Pos3
% (nomenclature refers to LHS of pair of transitions)
make_tppmis_lhs(Tppmiset,Tpplhs1):-
	findall(p2lhs(St1,Srt2,Pos1,Op1-Pos3,Var),
                member(tppmi(St1,Srt2, Pos1,_Pos2, Op1-Pos3,_, true,Var),
	               Tppmiset),
                Tpplhs),
	sort(Tpplhs,Tpplhs1),
        write_list(Tpplhs1).
% Half-step from St1 into transition, checking value Op2-Pos4 matches Var
make_tppmis_rhs(Tppmiset,Tpprhs1):-
	findall(p2rhs(St1,Srt2,Pos2,Op2-Pos4,Var),
                member(tppmi(St1,Srt2, _Pos1,Pos2, _Tr1,Op2-Pos4, true,Var),
	               Tppmiset),
                Tpprhs),
	sort(Tpprhs,Tpprhs1),
        write_list(Tpprhs1).


%------------------------------------------------------------------------------
% Hypothesise matches between the variables proposed in phase 2
%                                 and those proposed in phase 3    
%------------------------------------------------------------------------------

p2_p3_eq_hyps(Vars,Vsets,EqHyps):-
	write('Varsf'=Vars),nl,
	write('Vsets'=Vsets),nl,
	findall(EqHyp,p2_p3_eq_hyp(Vars,Vsets,EqHyp),EqHyps).

% V1 is the 'seed' variable which is propagated in P3
%   - it is used as a unique identifier for the Vset,
%   therefore the states in V0 and V1 might not match,
%   but the equality hypothesis relates to St0, state for V0.
p2_p3_eq_hyp(Vars,Vsets,eqhyp(Var0=Var1,_)):-
	member(Var0,Vars),
	%write('Var0'=Var0),nl,
	Var0=v(St0,Srt,_N0), % Variable from phase 2
	%write('Var0'=Var0),nl,
	Var1=v(_St1,Srt,_N1), % Propagated variable, same sort
	Vset=vset(Var1,Sts,_Trs,_OK),    
	member(Vset,Vsets),
	%write('Vset'=Vset),nl,
	Var0 \== Var1,
	memberchk(St0,Sts).   % Variables occur in same state

/*
given for O:
  old state of O
  
For action a 
  if action contains object o
     if some state variable fails lhs check of a transition
       fail the corresponding vset.
     Follow object to new state
       use tppmirhs to set any p2 state variables
     Use p3 transitions to copy any p3 state variables
     Test any equality hyps between p3 and p2 variables
     
Problem:  
  a wrong phase 3 vset will show up as a violation of a p2 transition,
   so we need the complete transtitions, not just RHS of transition.

*/

phase3_test(Srt,Incs,Obs,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps):-
	p3_process_obs(Obs,Srt,Incs,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps).

p3_process_obs([],_,_,_, _,_,_,_,_).
p3_process_obs([Ob-Srt|Obs],Srt,Incs,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps):-
%	Srt=hub,
	% Sort matches
	!,
	p3_process_sequences(Incs,Ob,Srt,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps),
	p3_process_obs(Obs,Srt,Incs,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps).
p3_process_obs([_|Obs],Srt,Incs,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps):-
	% Sort doesn't match
	p3_process_obs(Obs,Srt,Incs,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps).
	
p3_process_sequences([],_Ob,_Srt,_Trs, _,_,_,_,_).
p3_process_sequences([Label|Incs],Ob,Srt,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps):-
	sequence_task(Label,Seq,_Goal,_Init),
	format("************ Sequence ~w~n",[Label]),
	p3_process_actions(Seq,Ob,Srt,_,[],Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps),
	p3_process_sequences(Incs,Ob,Srt,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps).

p3_process_actions([],_Ob,_Srt,_SS,_,_Trs, _,_,_,_,_).
p3_process_actions([Act|Acts],Ob,Srt,SS0,SS0Vars,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps):-
	Act =.. [Name|Args],
	%
	% snc zero ob change 
	%Args0=['#zero'|Args]
	%(nth0(Pos,Args,Ob);nth0(Pos,Args,@Ob)),
	(nth(Pos,Args,Ob);nth(Pos,Args,@Ob)),
	!, % Object changes in action
	memberchk(tr(Name,Pos,Srt,SS0,SS1),Trs),
	format("Ob=~w, Act=~w, Tr=~w~w, ~w->~w ~w~n",[Ob,Act,Name,Pos,SS0,SS1,SS1Vars2]),
	% Check state variables using tppmis_rhs
	check_state_vars1(Tpprhs,SS0,Name,Args,Pos,SS0Vars,Vsets),
	% Update state variables using tppmis_lhs
	set_state_vars(Tpplhs,SS1,Name,Args,Pos,SS1Vars0),
	% Update state variables using Vsets
	set_hidden_state_vars(Vsets,Name-Pos,SS0,SS1,SS0Vars,SS1Vars1),
	% Check P2-P3 Equality Hypotheses
	check_eqhyps(EqHyps,SS1Vars0,SS1Vars1),
	append(SS1Vars0,SS1Vars1,SS1Vars2),
	check_for_clashes(SS1Vars0,SS1Vars1),
	p3_process_actions(Acts,Ob,Srt,SS1,SS1Vars2,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps).
p3_process_actions([_|Acts],Ob,Srt,SS0,SS0Vars,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps):-
	% object didn't occur in action
	p3_process_actions(Acts,Ob,Srt,SS0,SS0Vars,Trs, Vars,Tpplhs,Tpprhs,Vsets,EqHyps).


set_state_vars(Tpplhs,SS1,ActName,Args,Pos1,SS1Vars):-
	findall(VV=Ob1,
	        (member(p2lhs(SS1,_,Pos1,ActName-Pos3,VV),Tpplhs),
		 nth(Pos3,Args,Ob1)),
	        SS1Vars).

% This test needs to loop over Tpprhs, I suppose
% If the test fails, then what?	

check_state_vars1([],_,_,_,_,_,_).
check_state_vars1([Tpr|Tpprhs],SS1,Actname,Args,Pos1,SS1Vars,Vsets):-
%	write(Tpr=p2rhs(SS1,_,Pos1,Actname-Pos4,VV)),nl,
	Tpr=p2rhs(SS1,_,Pos1,Actname-Pos4,VV),
	memberchk(vset(VV,_,_,OK),Vsets),
	write(Tpr),nl,
	nth(Pos4,Args,Ob),
	format("Checking ~w~n",[VV=Ob]),
	memberchk(VV=Ob1,SS1Vars),
	!,
	format("... found ~w",[Ob1]),
	(Ob=Ob1 -> OK=_ ; OK=false),
	format("... OK=~w~n",[OK]),
	check_state_vars1(Tpprhs,SS1,Actname,Args,Pos1,SS1Vars,Vsets).
check_state_vars1([_|Tpprhs],SS1,Actname,Args,Pos1,SS1Vars,Vsets):-
	% Tpr doesn't match (e.g. wrong action)
	% or the state variable is not set (e.g. not yet set in sequence).
	check_state_vars1(Tpprhs,SS1,Actname,Args,Pos1,SS1Vars,Vsets).

%check_state_vars(Tpprhs,SS1,ActName,Args,Pos1,SS1Vars):-
%	member(p2rhs(SS1,_,Pos1,ActName-Pos4,VV),Tpprhs),
%	nth(Pos4,Args,Ob),
%	format("Checking ~w~n",[VV=Ob]),
%	memberchk(VV=Ob1,SS1Vars),
%	format("... found ~w",[Ob1]),
%	Ob=Ob1,
%	format("... OK~n",[]),
%	fail.
%check_state_vars(_,_,_,_,_,_).

% Don't distinguish vars set in different ways!
%  (you can tell which ones are "native" from the names
% Hidden state vars are set when:
%   New state is in vset
%   Transition is in vset
set_hidden_state_vars(Vsets,Actname-Pos,SS0,SS1,SS0Vars,SS1Vars):-
	findall(
	 SS1Var,
	 set_hidden_state_var(Vsets,Actname-Pos,SS0,SS1,SS0Vars,SS1Var),
	 SS1Vars).

set_hidden_state_var(Vsets,Actname-Pos,SS0,SS1,SS0Vars,Var=Val):-
	member(vset(Var,_Sts,Trs,_),Vsets),
	memberchk(tr(Actname,Pos,_Srt,SS0,SS1),Trs),
	memberchk(Var=Val,SS0Vars),
	format("***** Setting hidden ~w=~w~n",[Var,Val]).

check_eqhyps([],_,_).
check_eqhyps([eqhyp(V0=V1,OK)|EqHyps],SS1Vars0,SS1Vars1):-
	memberchk(V0=Ob0,SS1Vars0),
	memberchk(V1=Ob1,SS1Vars1),
	!,
	(Ob0=Ob1 -> OK=_ ; OK=false),
	check_eqhyps(EqHyps,SS1Vars0,SS1Vars1).
check_eqhyps([_|EqHyps],SS1Vars0,SS1Vars1):-
	check_eqhyps(EqHyps,SS1Vars0,SS1Vars1).

% Doesn't filter any more
% just fixes last arg to true/false
filter_vsets([],[]).
filter_vsets([Vset|Vsets0],[Vset|Vsets1]):-
	Vset=vset(_Var,_Sts,_Trs,true),
	!,
	filter_vsets(Vsets0,Vsets1).
filter_vsets([Vset|Vsets0],[Vset|Vsets1]):-
	filter_vsets(Vsets0,Vsets1).

filter_eqhyps([],_,[]).
filter_eqhyps([EqHyp|EqHyps0],Vsets,[Var0=Var1|EqHyps1]):-
	EqHyp=eqhyp(Var0=Var1,true),
	memberchk(vset(Var1,_,_,true),Vsets),
	!,
	filter_eqhyps(EqHyps0,Vsets,EqHyps1).
filter_eqhyps([_|EqHyps0],Vsets,EqHyps1):-
	filter_eqhyps(EqHyps0,Vsets,EqHyps1).

portray_vsets([]).
portray_vsets([Vset|Vsets]):-
	Vset=vset(Var,Sts,_,OK),
	OK \== false,
	!,
	format("~w~n",[vset(Var,Sts,'_','_true')]),
	portray_vsets(Vsets).
portray_vsets([Vset|Vsets]):-
	Vset=vset(Var,Sts,_,OK),
	format("~w~n",[vset(Var,Sts,'_',OK)]),
	portray_vsets(Vsets).
	
t2:-
	sequence_task(N,Seq0,_,_),
	%J=hub0,
	append(_,[put_on_wheel(W1,_,J)|Seq1],Seq0),
	append(_,[jack_down(_,J)|Seq2],Seq1),
	append(_,[remove_wheel(W2,_,J)|_Seq3],Seq2),
	W1 \== W2,
	write(N),nl.

check_for_clashes(SS1Vars0,SS1Vars1):-
%	member(VV=Ob0,SS1Vars1),
	member(VV=Ob0,SS1Vars0),
	%format("**************** thing ~w=~w~n",[VV,Ob0]),
	memberchk(VV=Ob1,SS1Vars1),
	Ob0 \= Ob1,
	format("**************** clash ~w=~w, =~w~n",[VV,Ob0,Ob1]),
	!,
	break.
check_for_clashes(_,_).
