(define
	(domain rocket_locmfeb)
	(:requirements :typing)
	(:types rocket cargo location)
	(:predicates
		(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
		(cargo_fsm0_state0 ?v0 - location ?v2 - rocket)
		(cargo_fsm0_state1 ?v1 - location ?v3 - rocket)
		(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
		(location_fsm0_state1)
		(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	(:action
	load
	:parameters
	(?c1 - cargo ?r1 - rocket ?lyon - location )
	:precondition
	(and
				(cargo_fsm0_state0 ?v0 - location ?v2 - rocket)
				(cargo_fsm0_state1 ?v1 - location ?v3 - rocket)
				(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
				(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
				(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	)
	:effect
	(and
				(cargo_fsm0_state0 ?v0 - location ?v2 - rocket)
				(cargo_fsm0_state1 ?v1 - location ?v3 - rocket)
				(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
				(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
				(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	))
	(:action
	move
	:parameters
	(?r2 - rocket ?paris - location ?london - location )
	:precondition
	(and
				(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
				(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
				(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	)
	:effect
	(and
				(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
				(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
				(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	))
	(:action
	unload
	:parameters
	(?c1 - cargo ?r1 - rocket ?lyon - location )
	:precondition
	(and
				(cargo_fsm0_state0 ?v0 - location ?v2 - rocket)
				(cargo_fsm0_state1 ?v1 - location ?v3 - rocket)
				(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
				(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
				(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	)
	:effect
	(and
				(cargo_fsm0_state0 ?v0 - location ?v2 - rocket)
				(cargo_fsm0_state1 ?v1 - location ?v3 - rocket)
				(rocket_fsm0_state0 ?v0 - location ?v1 - location ?v1 - location ?v3 - location ?v4 - location ?v5 - location ?v6 - location ?v1 - location ?v8 - cargo ?v9 - location ?v10 - location ?v9 - location ?v12 - cargo ?v10 - location ?v14 - cargo ?v15 - location ?v0 - location ?v15 - location ?v1 - location ?v19 - cargo)
				(location_fsm0_state0 ?v0 - rocket ?v1 - cargo ?v2 - cargo ?v3 - rocket ?v4 - rocket ?v5 - rocket ?v6 - rocket ?v7 - rocket ?v8 - cargo ?v9 - cargo)
				(location_fsm1_state0 ?v0 - rocket ?v1 - cargo ?v2 - rocket ?v3 - rocket ?v4 - location ?v5 - rocket ?v6 - rocket ?v7 - location ?v8 - rocket ?v9 - location ?v10 - cargo ?v11 - rocket ?v12 - cargo ?v13 - rocket ?v14 - rocket ?v15 - rocket ?v16 - rocket ?v17 - cargo)
	))
