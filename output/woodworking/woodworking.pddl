(define	(domain woodworking)
	(:requirements :typing)
	(:types planing colour cost plane piece wood)
	(:predicates
		(planing_fsm0_state0)
		(colour_fsm0_state0)
		(cost_fsm0_state0)
		(plane_fsm0_state0 ?v0 - cost)
		(piece_fsm0_state0)
		(piece_fsm0_state1)
		(wood_fsm0_state0 ?v0 - piece)
)
	(:action	take
	:parameters	(?piece - piece )
	:precondition	(and
				(piece_fsm0_state0)
				(piece_fsm0_state1)
	)
	:effect	(and
				(piece_fsm0_state0)
				(piece_fsm0_state1)
	))

	(:action	glaze
	:parameters	(?piece - piece ?wood - wood )
	:precondition	(and
				(piece_fsm0_state0)
				(piece_fsm0_state1)
				(wood_fsm0_state0 ?v0 - piece)
	)
	:effect	(and
				(piece_fsm0_state0)
				(piece_fsm0_state1)
				(wood_fsm0_state0 ?v0 - piece)
	))

	(:action	do
	:parameters	(?planing - planing )
	:precondition	(and
				(planing_fsm0_state0)
	)
	:effect	(and
				(planing_fsm0_state0)
	))

	(:action	increase
	:parameters	(?cost - cost ?plane - plane )
	:precondition	(and
				(cost_fsm0_state0)
				(plane_fsm0_state0 ?v0 - cost)
	)
	:effect	(and
				(cost_fsm0_state0)
				(plane_fsm0_state0 ?v0 - cost)
	))

	(:action	use
	:parameters	(?colour - colour )
	:precondition	(and
				(colour_fsm0_state0)
	)
	:effect	(and
				(colour_fsm0_state0)
	))

)
