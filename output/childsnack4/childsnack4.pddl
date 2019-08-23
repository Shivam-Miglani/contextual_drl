(define	(domain childsnack4)
	(:requirements :typing)
	(:types sandwich-type ingredients tray kitchen sandwich)
	(:predicates
		(sandwich-type_fsm0_state0)
		(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
		(sandwich-type_fsm0_state2)
		(ingredients_fsm0_state0)
		(tray_fsm0_state0)
		(kitchen_fsm0_state0)
		(kitchen_fsm0_state1)
		(sandwich_fsm0_state0)
		(sandwich_fsm0_state1)
		(sandwich_fsm1_state0)
	)
	(:action	move
	:parameters	(?tray - tray )
	:precondition	(and
				(tray_fsm0_state0)
	)
	:effect	(and
				(tray_fsm0_state0)
	))

	(:action	take
	:parameters	(?gluten-free - sandwich-type ?ingredients - ingredients )
	:precondition	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(ingredients_fsm0_state0)
	)
	:effect	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(ingredients_fsm0_state0)
	))

	(:action	serve
	:parameters	(?gluten-free - sandwich-type ?sandwich - sandwich )
	:precondition	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm1_state0)
	)
	:effect	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm1_state0)
	))

	(:action	make
	:parameters	(?gluten-free - sandwich-type ?sandwich - sandwich )
	:precondition	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm1_state0)
	)
	:effect	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm1_state0)
	))

	(:action	put
	:parameters	(?gluten-free - sandwich-type ?sandwich - sandwich )
	:precondition	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm1_state0)
	)
	:effect	(and
				(sandwich-type_fsm0_state0)
				(sandwich-type_fsm0_state1 ?v0 - sandwich ?v1 - sandwich)
				(sandwich-type_fsm0_state2)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm1_state0)
	))

)
