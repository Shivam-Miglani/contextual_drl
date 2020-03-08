(define	(domain pizza)
	(:requirements :typing)
	(:types dough dough. sauce paprika olives. cheese  it)
	(:predicates
		(dough_fsm0_state0)
		(dough_fsm0_state1)
		(dough._fsm0_state0)
		(dough._fsm0_state1)
		(sauce_fsm0_state0)
		(sauce_fsm0_state1)
		(paprika_fsm0_state0)
		(paprika_fsm0_state1)
		(olives._fsm0_state0)
		(olives._fsm0_state1)
		(cheese_fsm0_state0)
		(cheese_fsm0_state1)
		(_fsm0_state0)
		(_fsm0_state1)
		(it_fsm0_state0)
		(it_fsm0_state1)
		(it_fsm0_state2)
	)
	(:action	deliver
	:parameters	(? -  )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	spread
	:parameters	(?cheese - cheese )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	knead
	:parameters	(?dough. - dough. )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	take
	:parameters	(?it - it )
	:precondition	(and
				(it_fsm0_state1)
	)
	:effect	(and
				(it_fsm0_state1)
	))

	(:action	buy
	:parameters	(?dough - dough )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	put
	:parameters	(?tomato - it ?sauce - sauce )
	:precondition	(and
				(it_fsm0_state1)
	)
	:effect	(and
				(it_fsm0_state1)
	))

)
