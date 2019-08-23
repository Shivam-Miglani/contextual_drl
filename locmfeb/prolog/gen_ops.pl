
generate_operators(Trs,SSVs,STppmis,P3s,Pops):-
	setof(A,N^Srt^S0^S1^member(tr(A,N,Srt,S0,S1),Trs),Acts),
	%filter_stppmis(STppmis0,P3s,STppmis),
	gen_ops(Acts,Trs,SSVs,STppmis,P3s, Pops, AllPreds),
	%pocl2ocl(Pops,Ops),
	once(suffix([],AllPreds)),
	sort(AllPreds,AllPreds1),
	write('AllPreds'=AllPreds1),nl,
	write_pddl_domain(AllPreds1,Pops).

% Some of the Tppmis have been discredited after Phase3 
% and should be filtered out
filter_stppmis([],_,[]).
filter_stppmis([Srt-Tppmis0|STppmis0],P3s,[Srt-Tppmis1|STppmis1]):-
	memberchk(p3(Srt,Vsets,EqHyps),P3s),
	filter_tppmis(Tppmis0,Srt,Vsets,EqHyps,Tppmis1),
	filter_stppmis(STppmis0,P3s,STppmis1).

filter_tppmis([],_,_,_,[]).
filter_tppmis([Tppmi|Tppmis0],Srt,Vsets,EqHyps,Tppmis1):-
	Tppmi=tppmi(_St,_Srt, _,_, _,_, _,VarTup),
	%format("CHECKING ~w~n",[VarTup]),
        member(vset(VarTup,_,_,Cond),Vsets),
	%write('Cond'=Cond),nl,
	Cond==false,
	\+memberchk(VarTup=_Var1,EqHyps),
	!, 
	%format("FILTERED ~w~n",[VarTup]),
	filter_tppmis(Tppmis0,Srt,Vsets,EqHyps,Tppmis1).
filter_tppmis([Tppmi|Tppmis0],Srt,Vsets,EqHyps,[Tppmi|Tppmis1]):-
	filter_tppmis(Tppmis0,Srt,Vsets,EqHyps,Tppmis1).


gen_ops([],_,_,_,_, [],_).
gen_ops([A|As],Trs,SSVs,STppmis,P3s, [Op|Ops], AllPreds):-
	nl,write(a=A),nl,
	zero_trans(A,Trs,AllPreds, ZeroTr),
	gen_trans(1,A,Trs,SSVs,OpTrs,Args,LHSvs,RHSvs,P3s,AllPreds),
	%format("LHSvs=~w~n",[LHSvs]),
	%format("RHSvs=~w~n",[RHSvs]),
	%write('Args'=Args),nl,
	add_equality_constraints(STppmis,A,Args,LHSvs,RHSvs),
	bind_arg_names1(Args,1,_,OpTrs,OclTrs,VarTab),
	once(suffix([],VarTab)),
	extra_args(Args,VarTab,Extras0),
	sort(Extras0,Extras), % remove duplicates caused by equality
	Header=..[A|Args],
	Op=operator(Header,Extras,ZeroTr,OclTrs),
	format("operator(~w,~n",[Header]),
	write_trs(OclTrs),
	write(').'),nl,nl,
%	write('OpTrs'=OpTrs),nl,
	gen_ops(As,Trs,SSVs,STppmis,P3s, Ops,AllPreds).

zero_trans(A,Trs,AllPreds, OpTr):-
	member(tr(A,0,zero,S0,S1),Trs),
	!,
	OpTr=S0=>S1,
	record_preds(S0*[],AllPreds),
	record_preds(S1*[],AllPreds).

gen_trans(N,A,Trs,SSVs, [OpTr|OpTrs],[_|Hargs], [Args0|LHSvs],[Args1|RHSvs], P3s, AllPreds):-
	N1 is N+1,
	member(tr(A,N,Srt,S0,S1),Trs),
	!,
	state_parameter_prp1(S0,SSVs,P3s,Args0),
	state_parameter_prp1(S1,SSVs,P3s,Args1),
	merge_vars(Args0,Index),
	merge_vars(Args1,Index),
% 2 lines below commented out on destruction of propagation 28 Nov 09
	memberchk(p3(Srt,_,EqHyps),P3s),
	impose_p3_equalities(EqHyps,Index),
	OpTr=S0*Args0=>S1*Args1,
	record_preds(S0*Args0,AllPreds),
	record_preds(S1*Args1,AllPreds),
	gen_trans(N1,A,Trs,SSVs, OpTrs,Hargs, LHSvs,RHSvs, P3s,AllPreds).
gen_trans(_,_,_,_, [],[], [],[], _,_).

record_preds(St*Args,AllPreds):-	
	findall(Srt,member(v(_,Srt,_,_),Args),ArgSrts),
	memberchk(St*ArgSrts,AllPreds).

% Catch extra arguments that aren't in the header
% Args = Args in header
% VarTab = All args seen
extra_args(Args,VarTab,Extras):-
	findall(V-Srt,
	       (member(v(_St,Srt,_ID,V),VarTab),
                \+memberchk(V,Args)),
		Extras).

% Compile list of vars - purpose is to force unification where possible.
merge_vars([],_).
merge_vars([V|Vs],Index):-
	memberchk(V,Index),
	merge_vars(Vs,Index).

% Unify prolog vars for equivalent vars. 
impose_p3_equalities([],_).
impose_p3_equalities([V0=V1|EqHyps],Index):-
	V0=v(St0,Vsrt,N0),
	V1=v(St1,Vsrt,N1),
	memberchk(v(St0,Vsrt,N0,Var),Index ),
	memberchk(v(St1,Vsrt,N1,Var),Index ),
	impose_p3_equalities(EqHyps,Index).
	
add_equality_constraints([],_,_ ,_,_).
add_equality_constraints([_Srt-Tppmis|STppmis],A,Args,LHSvs,RHSvs):-
	add_eq_const(Tppmis,A,Args,LHSvs,RHSvs),
	add_equality_constraints(STppmis,A,Args,LHSvs,RHSvs).

add_eq_const([],_,_,_,_).
add_eq_const([Tppmi|Tppmis],A,Args,LHSvs,RHSvs):-
	add_lhs_eq_const(Tppmi,A,Args,LHSvs),
	add_rhs_eq_const(Tppmi,A,Args,RHSvs),
	add_eq_const(Tppmis,A,Args,LHSvs,RHSvs).

add_lhs_eq_const(T,A,Args,LHSvs):-
	T=tppmi(St,_Srt, _,PP2, _,A-P, _,VarTup), % (St) LHS => Tr2
	VarTup \= fail,
	nth(PP2,LHSvs,ArgStParams),
	VarTup=v(St,Srt2,N),
	memberchk(v(St,Srt2,N,Var1),ArgStParams), 
	!,
	nth(P,Args,Var2),
%	write('LHS A-P'=A-P),nl,write(Var1=Var2),nl,
%	write(T),nl,
	Var1=Var2,
	true.
add_lhs_eq_const(_,_,_,_).

add_rhs_eq_const(T,A,Args,RHSvs):-
	T=tppmi(St,_Srt, PP1,_, A-P,_, _,VarTup), % Tr1 => RHS (St)
	VarTup \= fail,
	nth(PP1,RHSvs,ArgStParams),
	VarTup=v(St,Srt2,N),
	memberchk(v(St,Srt2,N,Var1),ArgStParams),
	!,
	nth(P,Args,Var2),
%	write('RHS A-P'=A-P),nl,write(Var1=Var2),nl,
%	write(T),nl,
	Var1=Var2,
	true.
add_rhs_eq_const(_,_,_,_).

% Should be called form_ocl_and_bind_more_variables
bind_arg_names1([],_,_,_,[],_).
bind_arg_names1([Arg|Args],N0,N4,[OpTr|OpTrs],[OclTr|OclTrs],VarTab):-
	OpTr=(Srt-Stn0)*Sps0=>(Srt-Stn1)*Sps1,
%	write('OpTr'=OpTr),nl,
	attempt_make_name(Srt,N0,N1,Arg),
	ocl_args(Sps0,N1,N2,OclArgs0,VarTab),
	ocl_args(Sps1,N2,N3,OclArgs1,VarTab),

	name_append('_state',Stn0,Stf0n),
	name_append('_state',Stn1,Stf1n),

	name_append(Srt,Stf0n,Stf0),
	name_append(Srt,Stf1n,Stf1),
	S0 =..[Stf0,Arg|OclArgs0],
	S1 =..[Stf1,Arg|OclArgs1],
%	S0 =..[Stf0|OclArgs0],
%	S1 =..[Stf1|OclArgs1],
%	OclTr=sc(Srt,Arg,S0=>S1),
	OclTr=tr(Arg:Srt,S0=>S1),
	%write(OclTr),nl,
	bind_arg_names1(Args,N3,N4,OpTrs,OclTrs,VarTab).

% VarTab is for collecting refs to *all* vars, including those not in header
ocl_args([],N,N,[],_).
ocl_args([Vtup|Vtups],N0,N2,[V|Args],VarTab):-
	Vtup=v(_St,Srt,_ID,V),
	attempt_make_name(Srt,N0,N1,V),
	memberchk(Vtup,VarTab), % Should always succeed
	ocl_args(Vtups,N1,N2,Args,VarTab).

attempt_make_name(Srt,N0,N1,Name):-
	var(Name),
	!,
	make_name(Srt,N0,N1,Name).
attempt_make_name(_,N,N,_).

make_name(Srt,N0,N1,Name):-
	name(Srt,[C0|SrtStr]),
	upcase(C0,C1),
	name(N0,NStr),
	append(SrtStr,NStr,NameStr),
	N1 is N0+1,
	name(Name,[C1|NameStr]).

name_append(X,Y,Z):-
	name(X,XS),
	name(Y,YS),
	append(XS,YS,ZS),
	name(Z,ZS).

% Create an atom beginning with uppercase. 
% (can be re-read as variable).
fake_variable( Na0, Na1 ):-
	name( Na0, [C0|Ns] ),
	upcase( C0, C1 ),
	name( Na1, [C1|Ns] ).

upcase( C0, C1 ):-
	name(azA,[Ca,Cz,CA]),
	C0 >= Ca,
	C0 =< Cz,!,
	C1 is C0-Ca+CA.
upcase( C, C ).

write_list(L):-
	write('['),nl,
	write_list1(L).
write_list1([]).
write_list1([H]):-
	!,
	format("   ~w~n]~n",[H]).
write_list1([H|T]):-
	format("   ~w,~n",[H]),
	write_list1(T).

write_trs(L):-
	write('['),nl,
	write_trs1(L).

write_trs1([]).
write_trs1([H]):-
	!,
	write_transition(H),
	format("~n]",[]).
write_trs1([H|T]):-
	write_transition(H),
	write(')'),nl,
	write_trs1(T).

write_transition(Tr):-
	Tr=tr(Srt:Var,LHS=>RHS),
	format(" tr(~w:~w,~n",[Srt,Var]),
	format("  ~w => ~n",[LHS]),
	format("  ~w",[RHS]).

%------------------------------------------------------------------------------
% convert operator from pidgin OCL to proper OCL
%------------------------------------------------------------------------------

pocl2ocl([],[]).
pocl2ocl([Pop|Pops],[Op|Ops]):-
	Pop=operator(Header,_Extras,Ptrs),
	Op=operator(Header,[],Trs,[]),
	trs2ocl(Ptrs,Trs),
	nl,write('Op'=Op),nl,
	pocl2ocl(Pops,Ops).

trs2ocl([],[]).
trs2ocl([Ptr|Ptrs],[Tr|Trs]):-
	Ptr=tr(Var:Srt,LHS=>RHS),
	Tr=sc(Srt,Var,[LHS]=>[RHS]),
	trs2ocl(Ptrs,Trs).

%------------------------------------------------------------------------------
%------------------------------------------------------------------------------

write_pddl_domain(AllPreds,Pops):-
	domain(DomainName),
	format_to_atom(File,"out/~w_dom.pddl",[DomainName]),
	format("Writing PDDL ops to file ~w~n",[File]),
	tell(File),
	pddl_domain(DomainName,AllPreds,Pops,Domain),
	nl,write_thing(Domain),nl,
	told.

pddl_domain(DomainName,AllPreds,Pops,Domain):-
	pocl2pddl_ops(Pops,PddlOps),
	pddl_preds(AllPreds,PddlPreds),
	pddl_static_preds(Pops,PddlStaticPreds),
	append(PddlStaticPreds,PddlPreds,PddlPreds1),
	setof(Srt,N^Args^member((Srt-N)*Args,AllPreds),Srts),
	Domain=
          [define,[domain,DomainName],
             [':requirements',':typing'],
             [':types'|Srts],
	     [':predicates'|PddlPreds1]
	     |PddlOps].
	   
% 2nd arg redundant - statics are asserted facts
pocl2pddl_ops([],[]).
pocl2pddl_ops([Pop|Pops],[Op|Ops]):-
	Pop=operator(Header,Extras,ZeroTr,Ptrs),
	Op=[':action',ActName,
	    ':parameters',AllParams,
	    ':precondition',[and|AllPrecs],
            ':effect',[and|Effs]],
	Header=..[ActName|_],
	findall(SPrec,(static(SPrec0,Header),pddl_pred(SPrec0,SPrec)),SPrecs),
	trs2pddl(Ptrs,Params,Precs,Effs0),
	zerotr2pddl(ZeroTr,ZeroPrec,ZeroEffs),
	append(ZeroEffs,Effs0,Effs),
	append(SPrecs,[ZeroPrec|Precs],AllPrecs),
	pddl_extra_args(Extras,PddlExtras),
	append(Params,PddlExtras,AllParams),
	pocl2pddl_ops(Pops,Ops).

zerotr2pddl(LHS=>LHS,[LHSp],[]):-
	!,
	LHS=zero-N,
	format_to_atom(LHSp,"zero_state~w",[N]).
zerotr2pddl(LHS=>RHS,[LHSp],[[RHSp],[not,[LHSp]]]):-
	LHS=zero-L,
	RHS=zero-R,
	format_to_atom(LHSp,"zero_state~w",[L]),
	format_to_atom(RHSp,"zero_state~w",[R]).

trs2pddl([],[],[],[]).
trs2pddl([Ptr|Ptrs],[?Var,'-',Srt|Args],[Prec|Precs],Effs):-
	Ptr=tr(Var:Srt,LHS=>LHS),
	!,
	pddl_pred(LHS,Prec),
	trs2pddl(Ptrs,Args,Precs,Effs).
trs2pddl([Ptr|Ptrs],[?Var,'-',Srt|Args],[Prec|Precs],[Eff,[not,Prec]|Effs]):-
	Ptr=tr(Var:Srt,LHS=>RHS),
	pddl_pred(LHS,Prec),
	pddl_pred(RHS,Eff),
	trs2pddl(Ptrs,Args,Precs,Effs).

pddl_extra_args([],[]).
pddl_extra_args([Var-Srt|Extras0],[?Var,-,Srt|Extras1]):-
	pddl_extra_args(Extras0,Extras1).

pddl_pred(OclPred,[Func|Args1]):-
	OclPred =.. [Func|Args0],
	pddl_args(Args0,Args1).

pddl_args([],[]).
pddl_args([Arg|Args0],[?Arg|Args1]):-
	pddl_args(Args0,Args1).

%------------------------------------------------------------------------------
%------------------------------------------------------------------------------

pddl_preds([],[]).
pddl_preds([(zero-N)*[]|Sts],[[P]|Preds]):-
	!,
	format_to_atom(P,"zero_state~w",[N]),
	pddl_preds(Sts,Preds).
pddl_preds([(Srt-N)*Args|Sts],[[P|Args1]|Preds]):-
	format_to_atom(P,"~w_state~w",[Srt,N]),
	pddl_pred_args([Srt|Args],1,Args1),
	pddl_preds(Sts,Preds).

pddl_pred_args([],_,[]).
pddl_pred_args([Srt|Srts],N,[?V,'-',Srt|PddlArgs]):-
	name(N,NumName),
	name(V,[118|NumName]), % 118='v'
	N1 is N+1,
	pddl_pred_args(Srts,N1,PddlArgs).

% Predicate declarations for the statics
%  - we have to go from static declaration to
%    action header, to action body to find sorts of args
%
% Decls bound to something like:
%   [[stackable,?v1,-,card,?v2,-,card],[next,?v1,-,card,?v2,-,card]]
pddl_static_preds(Pops,Decls):-
	findall(Decl,
	        (static(Template,Header),
		 Template=..[Pred|PredArgs],
	         memberchk(operator(Header,_,_,Ptrs),Pops),
		 static_pred_args(PredArgs,Ptrs,Srts),
		 pddl_pred_args(Srts,1,SortedVars),
	         Decl=[Pred|SortedVars]
                ),
                Decls).

static_pred_args([],_,[]).
static_pred_args([PA|PAs],Ptrs,[Srt|Srts]):-
	matching_arg_sort(Ptrs,PA,Srt),
	static_pred_args(PAs,Ptrs,Srts).

% When predicate arg matches operator arg, take sort of operator arg
matching_arg_sort([tr(Var:Srt0,_)|_],PA,Srt1):-
	Var == PA, % Already identical (don't unify)
	!,
	Srt1=Srt0.
matching_arg_sort([_|Ptrs],PA,Srt):-
	matching_arg_sort(Ptrs,PA,Srt).


%------------------------------------------------------------------------------
% Output lisp list
%------------------------------------------------------------------------------

write_thing(L):-
	L=[_|_],
	!,
	write_some_list(L).
write_thing(T):-
	write(T).

write_some_list([H|T]):-
	% For certain constructs, write outer list (with newlines)
	memberchk(H,[define,':action']),
	!,
	write('('),
	write(H),nl,
	write_outer_list(T,'   '),
	write(')'),nl.
write_some_list([H|T]):-
	% For certain constructs, write outer list (with newlines) 
        % and more indent
	memberchk(H,[':predicates',and,':init',':goal']),
	!,
	write('('),write(H),nl,
	write_outer_list(T,'      '),
	write(')'),nl.
write_some_list(L):-
	write('('),
	write_inner_list(L),
	write(')').
	
write_outer_list([],_Indent).
write_outer_list([H],Indent):-
	!,
	write(Indent),
	write_thing(H).
write_outer_list([H|L],Indent):-
	write(Indent),
	write_thing(H),nl,
	write_outer_list(L,Indent).

write_inner_list([]).
write_inner_list([H]):-
	!,
	write_thing(H).
write_inner_list([H|L]):-
	write_thing(H),
	write(' '),
	write_inner_list(L).

