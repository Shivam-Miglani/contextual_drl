

dot_infile('graph/graph.dot').
dot_outfile('graph/graph.ps').

dot_graph(Edges,Nodes):-
	dot_infile(Dot_infile),
	dot_outfile(Dot_outfile),
	tell(Dot_infile),
	dot_preamble,
%	dot_draw(Nodes,Edges),
	dot_nodes(Nodes),
	dot_edges(Edges),
	dot_postamble,
	told,
	dot_call(Dot_infile,Dot_outfile).

dot_preamble:-
	write('digraph genstates {'),nl,
	write('size="7.5,10"'),nl,
	write('rankdir = LR'),nl.

dot_postamble:-
   write('}'), nl.

dot_call( Dot_infile, Dot_outfile ):-
	format_to_atom(Call1,"dot -Tps ~w -o ~w",[Dot_infile,Dot_outfile]),
	system(Call1),
	format_to_atom(Call2,"gv ~w &",[Dot_outfile]),
	system(Call2).

dot_nodes( [] ).
dot_nodes( [node(Srt-Sid,SVs)|Ns] ):-
	findall(PSrt,member(v(_,PSrt,_),SVs),PSrts),
%	PSrts=SVs,
	format( "~w~w [label=\"~w~w\\n~w\"]~n",[Srt,Sid,Srt,Sid,PSrts] ),
%	format( "~w~w [label=\"~w~w\"]~n",[Srt,Sid,Srt,Sid] ),
	dot_nodes( Ns ).


/*
dot_nodes( [] ).
dot_nodes( [N-[L|_]|Ns] ):-
%	dot_box_colour(L,Col),
%	dot_box_shape(Type,Shape),
%	dot_box_bookend(Type,Start,End),
%	dot_font_colour(L,FCol),
	%format( "node_~w [shape=record,color=~w,fontcolor=~w,label=\"",[N1,Col,FCol] ),
%	format( "node_~w [shape=record,label=\"",[N1] ),
	L=ss(_,Ob,L1),
	format( "node_~w [shape=record,label=\"",[N] ),
	write('{'),
	%write(Start),
	format( "~w|", [Ob] ),
	dot_node_label( L1 ),
	%write(End),
	write('}'),
	format("\"];~n",[]), 
	dot_nodes( Ns ).
*/

dot_box_colour([L],red):-
	init(and(Ls)),
	memberchk(L,Ls),!.
dot_box_colour( _, black ).
dot_font_colour([L],blue):-
	goal(and(Ls)),
	memberchk(L,Ls),!.
dot_font_colour( _, black ).

%dot_box_shape( fa, box):-!.
%dot_box_shape( lc, ellipse):-!.
dot_box_bookend( fa, '|',' ').
dot_box_bookend( lc, ' ','|').

dot_node_label( [] ).
dot_node_label( [Lit|Lits] ):-
	write(Lit),
	dot_maybe_cr( Lits ),
	dot_node_label( Lits ).

dot_maybe_cr( [] ).
dot_maybe_cr( [_|_] ):- write('\\n').

dot_edges( Edges ):-
	member(tr(Act,Arg,_Srt,S0-N0,S1-N1),Edges),
	%format( "node_~w -> node_~w [color=~w];~n", [N1,N2,Colour] ),
	%format( "~w -> ~w [label=~w~w];~n", [LHS,RHS,Act,Arg] ),
	format( "~w~w -> ~w~w [label=\"~w.~w\"];~n", [S0,N0,S1,N1,Act,Arg] ),
%	format( "~w~w -> ~w~w -> ~w~w;~n", [S0,N0,Act,Arg,S1,N1] ),
	fail.
dot_edges( _ ).	

