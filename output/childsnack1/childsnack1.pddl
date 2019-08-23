(define
	(domain childsnack1)
	(:requirements :typing)
	(:types bread content tray child bread content child sandw kitchen)
	(:predicates
		(bread_fsm0_state0)
		(bread_fsm0_state1)
		(content_fsm0_state0)
		(content_fsm0_state1)
		(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
		(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
		(child_fsm0_state0)
		(child_fsm0_state1)
		(bread_fsm0_state0)
		(bread_fsm0_state1)
		(content_fsm0_state0)
		(content_fsm0_state1)
		(child_fsm0_state0)
		(child_fsm0_state1)
		(sandw_fsm0_state0)
		(sandw_fsm0_state1)
		(sandw_fsm0_state2)
		(sandw_fsm0_state3)
		(sandw_fsm0_state4)
		(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
		(kitchen_fsm0_state0)
		(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
		(kitchen_fsm0_state2)
		(kitchen_fsm1_state0)
		(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
		(kitchen_fsm1_state2)
		(kitchen_fsm1_state3)
		(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	(:action
	make_sandwich_no_gluten
	:parameters
	(?sandw8 - sandw ?bread2 - bread ?content3 - content )
	:precondition
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
	)
	:effect
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
	))
	(:action
	serve_sandwich_no_gluten
	:parameters
	(?sandw8 - sandw ?child5 - child ?tray2 - tray ?table1 - kitchen )
	:precondition
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
				(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
				(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
				(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	)
	:effect
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
				(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
				(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
				(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	))
	(:action
	serve_sandwich
	:parameters
	(?sandw6 - sandw ?child2 - child ?tray2 - tray ?table1 - kitchen )
	:precondition
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
				(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
				(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
				(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	)
	:effect
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
				(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
				(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
				(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	))
	(:action
	make_sandwich
	:parameters
	(?sandw6 - sandw ?bread1 - bread ?content1 - content )
	:precondition
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
	)
	:effect
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
	))
	(:action
	move_tray
	:parameters
	(?tray2 - tray ?kitchen - kitchen ?table1 - kitchen )
	:precondition
	(and
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
				(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
				(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
				(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	)
	:effect
	(and
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
				(kitchen_fsm0_state1 ?v0 - tray ?v1 - kitchen ?v2 - tray ?v3 - tray)
				(kitchen_fsm1_state1 ?v0 - tray ?v1 - tray)
				(kitchen_fsm2_state0 ?v0 - tray ?v1 - kitchen ?v2 - kitchen ?v3 - tray ?v4 - tray ?v5 - kitchen ?v6 - tray ?v7 - tray ?v8 - tray ?v9 - tray)
	))
	(:action
	put_on_tray
	:parameters
	(?sandw8 - sandw ?tray2 - tray )
	:precondition
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
	)
	:effect
	(and
				(sandw_fsm0_state2)
				(sandw_fsm0_state5 ?v0 - tray ?v1 - tray)
				(tray_fsm0_state0 ?v1 - kitchen ?v4 - kitchen ?v4 - kitchen ?v1 - kitchen)
				(tray_fsm0_state1 ?v0 - kitchen ?v2 - kitchen ?v0 - kitchen ?v2 - kitchen)
	))
