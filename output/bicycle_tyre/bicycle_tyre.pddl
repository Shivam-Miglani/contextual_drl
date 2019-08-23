(define
	(domain bicycle_tyre)
	(:requirements :typing)
	(:types wheel hands cap tube inner area glue patch fingers air  bike alcohol bead stem)
	(:predicates
		(wheel_fsm0_state0)
		(hands_fsm0_state0)
		(hands_fsm0_state1)
		(cap_fsm0_state0)
		(cap_fsm0_state1)
		(tube_fsm0_state0)
		(tube_fsm0_state1)
		(tube_fsm0_state2)
		(inner_fsm0_state0)
		(inner_fsm0_state1)
		(area_fsm0_state0)
		(area_fsm0_state1)
		(glue_fsm0_state0)
		(glue_fsm0_state1)
		(glue_fsm0_state2)
		(patch_fsm0_state0)
		(patch_fsm0_state1)
		(fingers_fsm0_state0)
		(fingers_fsm0_state1)
		(air_fsm0_state0)
		(air_fsm0_state1)
		(_fsm0_state0)
		(_fsm0_state1)
		(bike_fsm0_state0)
		(bike_fsm0_state1)
		(alcohol_fsm0_state0)
		(alcohol_fsm0_state1 ?v0 - stem)
		(alcohol_fsm0_state2)
		(alcohol_fsm0_state3)
		(alcohol_fsm0_state4)
		(alcohol_fsm0_state5)
		(alcohol_fsm0_state6)
		(alcohol_fsm0_state7)
		(bead_fsm0_state0)
		(bead_fsm0_state1)
		(bead_fsm0_state2)
		(stem_fsm0_state0)
		(stem_fsm0_state1)
		(stem_fsm0_state2 ?v0 - alcohol)
		(stem_fsm0_state3 ?v1 - alcohol)
	(:action
	deflate
	:parameters
	(?tube - tube )
	:precondition
	(and
				(tube_fsm0_state1)
	)
	:effect
	(and
				(tube_fsm0_state1)
	))
	(:action
	insert
	:parameters
	(?tire - alcohol ?lever - stem )
	:precondition
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
				(stem_fsm0_state2 ?v0 - alcohol)
				(stem_fsm0_state3 ?v1 - alcohol)
	)
	:effect
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
				(stem_fsm0_state2 ?v0 - alcohol)
				(stem_fsm0_state3 ?v1 - alcohol)
	))
	(:action
	run
	:parameters
	(?fingers - fingers )
	:precondition
	(and
	)
	:effect
	(and
	))
	(:action
	apply
	:parameters
	(?glue - glue ?patch - patch )
	:precondition
	(and
				(glue_fsm0_state1)
	)
	:effect
	(and
				(glue_fsm0_state1)
	))
	(:action
	using
	:parameters
	(?wrench - hands )
	:precondition
	(and
	)
	:effect
	(and
	))
	(:action
	hook
	:parameters
	(?tire - alcohol ?lever - stem )
	:precondition
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
				(stem_fsm0_state2 ?v0 - alcohol)
				(stem_fsm0_state3 ?v1 - alcohol)
	)
	:effect
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
				(stem_fsm0_state2 ?v0 - alcohol)
				(stem_fsm0_state3 ?v1 - alcohol)
	))
	(:action
	moving
	:parameters
	(? -  )
	:precondition
	(and
	)
	:effect
	(and
	))
	(:action
	inflate
	:parameters
	(?tire - alcohol )
	:precondition
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	)
	:effect
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	))
	(:action
	pinch
	:parameters
	(?tire - alcohol )
	:precondition
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	)
	:effect
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	))
	(:action
	pull
	:parameters
	(?inner - inner ?tube - tube )
	:precondition
	(and
				(tube_fsm0_state1)
	)
	:effect
	(and
				(tube_fsm0_state1)
	))
	(:action
	put
	:parameters
	(?air - air )
	:precondition
	(and
	)
	:effect
	(and
	))
	(:action
	unscrew
	:parameters
	(?valve - alcohol ?cap - cap )
	:precondition
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	)
	:effect
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	))
	(:action
	use
	:parameters
	(?tire - alcohol ?lever - stem )
	:precondition
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
				(stem_fsm0_state2 ?v0 - alcohol)
				(stem_fsm0_state3 ?v1 - alcohol)
	)
	:effect
	(and
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
				(stem_fsm0_state2 ?v0 - alcohol)
				(stem_fsm0_state3 ?v1 - alcohol)
	))
	(:action
	work
	:parameters
	(?tip - bead )
	:precondition
	(and
				(bead_fsm0_state0)
	)
	:effect
	(and
				(bead_fsm0_state0)
	))
	(:action
	reattach
	:parameters
	(?bike - bike )
	:precondition
	(and
	)
	:effect
	(and
	))
	(:action
	clean
	:parameters
	(?area - area )
	:precondition
	(and
	)
	:effect
	(and
	))
	(:action
	flip
	:parameters
	(?bead - bead ?tire - alcohol )
	:precondition
	(and
				(bead_fsm0_state0)
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	)
	:effect
	(and
				(bead_fsm0_state0)
				(alcohol_fsm0_state0)
				(alcohol_fsm0_state1 ?v0 - stem)
				(alcohol_fsm0_state2)
				(alcohol_fsm0_state5)
				(alcohol_fsm0_state7)
	))
	(:action
	patch
	:parameters
	(?glue - glue )
	:precondition
	(and
				(glue_fsm0_state1)
	)
	:effect
	(and
				(glue_fsm0_state1)
	))
	(:action
	take
	:parameters
	(?wheel - wheel )
	:precondition
	(and
				(wheel_fsm0_state0)
	)
	:effect
	(and
				(wheel_fsm0_state0)
	))
