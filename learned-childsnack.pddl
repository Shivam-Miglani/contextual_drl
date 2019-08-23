(define
	(domain childsnack4)
	(:requirements :typing)
	(:types gluten-free ingredients sandwich tray)
	(:predicates
		(gluten-free_fsm0_state0 ?v1 - sandwich)
		(gluten-free_fsm0_state1 ?v0 - sandwich)
		(gluten-free_fsm0_state2)
		(gluten-free_fsm0_state3)
		(ingredients_fsm0_state0)
		(sandwich_fsm0_state0)
		(sandwich_fsm0_state1)
		(sandwich_fsm0_state2)
		(tray_fsm0_state0)
	(:action
	move
	:parameters
	(?tray - tray )
	:precondition
	(and
				(tray_fsm0_state0)
	)
	:effect
	(and
				(tray_fsm0_state0)
	))
	(:action
	take
	:parameters
	(?gluten-free - gluten-free ?ingredients - ingredients )
	:precondition
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(ingredients_fsm0_state0)
	)
	:effect
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(ingredients_fsm0_state0)
	))
	(:action
	serve
	:parameters
	(?gluten-free - gluten-free ?sandwich - sandwich )
	:precondition
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm0_state2)
	)
	:effect
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm0_state2)
	))
	(:action
	make
	:parameters
	(?gluten-free - gluten-free ?sandwich - sandwich )
	:precondition
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm0_state2)
	)
	:effect
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm0_state2)
	))
	(:action
	put
	:parameters
	(?gluten-free - gluten-free ?sandwich - sandwich )
	:precondition
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm0_state2)
	)
	:effect
	(and
				(gluten-free_fsm0_state0 ?v1 - sandwich)
				(gluten-free_fsm0_state1 ?v0 - sandwich)
				(gluten-free_fsm0_state2)
				(gluten-free_fsm0_state3)
				(sandwich_fsm0_state0)
				(sandwich_fsm0_state1)
				(sandwich_fsm0_state2)
	))
