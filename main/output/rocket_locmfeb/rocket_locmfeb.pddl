(define
	(domain rocket_locmfeb)
	(:requirements :typing)
	(:types r c lyon)
	(:predicates
		(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
		(c_fsm0_state0 ?v1 - lyon ?v2 - r)
		(c_fsm0_state1 ?v0 - r ?v3 - lyon)
		(lyon_fsm0_state0)
		(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
		(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	(:action
	move
	:parameters
	(?r2 - r ?paris - lyon ?london - lyon )
	:precondition
	(and
				(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
				(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
				(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	)
	:effect
	(and
				(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
				(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
				(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	))
	(:action
	unload
	:parameters
	(?c1 - c ?r1 - r ?lyon - lyon )
	:precondition
	(and
				(c_fsm0_state0 ?v1 - lyon ?v2 - r)
				(c_fsm0_state1 ?v0 - r ?v3 - lyon)
				(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
				(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
				(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	)
	:effect
	(and
				(c_fsm0_state0 ?v1 - lyon ?v2 - r)
				(c_fsm0_state1 ?v0 - r ?v3 - lyon)
				(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
				(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
				(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	))
	(:action
	load
	:parameters
	(?c1 - c ?r1 - r ?lyon - lyon )
	:precondition
	(and
				(c_fsm0_state0 ?v1 - lyon ?v2 - r)
				(c_fsm0_state1 ?v0 - r ?v3 - lyon)
				(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
				(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
				(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	)
	:effect
	(and
				(c_fsm0_state0 ?v1 - lyon ?v2 - r)
				(c_fsm0_state1 ?v0 - r ?v3 - lyon)
				(r_fsm0_state0 ?v0 - c ?v1 - c ?v2 - lyon ?v3 - lyon ?v3 - lyon ?v5 - lyon ?v6 - lyon ?v7 - lyon ?v6 - lyon ?v9 - lyon ?v10 - lyon ?v7 - lyon ?v9 - lyon ?v13 - lyon ?v2 - lyon ?v15 - c ?v9 - lyon ?v17 - c ?v9 - lyon ?v19 - lyon)
				(lyon_fsm0_state1 ?v0 - c ?v1 - r ?v2 - c ?v3 - c ?v4 - r ?v5 - r ?v6 - r ?v7 - r ?v8 - c ?v9 - r)
				(lyon_fsm1_state0 ?v0 - r ?v1 - r ?v2 - r ?v3 - lyon ?v4 - c ?v5 - c ?v6 - lyon ?v7 - r ?v8 - c ?v9 - lyon ?v10 - c ?v11 - r ?v12 - r ?v13 - r ?v14 - r ?v15 - r ?v16 - r ?v17 - r)
	))
