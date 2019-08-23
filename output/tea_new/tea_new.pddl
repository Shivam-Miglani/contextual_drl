(define	(domain tea_new)
	(:requirements :typing)
	(:types home cafe tea 15 minutes hands water milk teabag)
	(:predicates
		(home_fsm0_state0)
		(home_fsm0_state1)
		(cafe_fsm0_state0)
		(cafe_fsm0_state1)
		(tea_fsm0_state0)
		(tea_fsm0_state1)
		(15 minutes_fsm0_state0)
		(15 minutes_fsm0_state1)
		(hands_fsm0_state0)
		(hands_fsm0_state1)
		(water_fsm0_state0)
		(water_fsm0_state1)
		(water_fsm0_state2)
		(milk_fsm0_state0)
		(milk_fsm0_state1)
		(milk_fsm0_state2)
		(teabag_fsm0_state0)
		(teabag_fsm0_state1)
		(teabag_fsm0_state2)
	)
	(:action	dip
	:parameters	(?teabag - teabag )
	:precondition	(and
				(teabag_fsm0_state1)
	)
	:effect	(and
				(teabag_fsm0_state1)
	))

	(:action	mix
	:parameters	(?teabag - teabag ?water - water ?milk - milk )
	:precondition	(and
				(teabag_fsm0_state1)
				(water_fsm0_state1)
				(milk_fsm0_state1)
	)
	:effect	(and
				(teabag_fsm0_state1)
				(water_fsm0_state1)
				(milk_fsm0_state1)
	))

	(:action	add
	:parameters	(?water - water )
	:precondition	(and
				(water_fsm0_state1)
	)
	:effect	(and
				(water_fsm0_state1)
	))

	(:action	start
	:parameters	(?home - home )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	wait
	:parameters	(?15 minutes - 15 minutes )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	reach
	:parameters	(?cafe - cafe )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	clean
	:parameters	(?hands - hands )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	pour
	:parameters	(?milk - milk )
	:precondition	(and
				(milk_fsm0_state1)
	)
	:effect	(and
				(milk_fsm0_state1)
	))

	(:action	buy
	:parameters	(?tea - tea )
	:precondition	(and
	)
	:effect	(and
	))

)
