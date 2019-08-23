(define	(domain fire_alarm1)
	(:requirements :typing)
	(:types experiments valuables wallets doors heat walking building nearest exit 911 name location pre-determined assembly area there safety personnel)
	(:predicates
		(experiments_fsm0_state0)
		(experiments_fsm0_state1)
		(valuables_fsm0_state0)
		(valuables_fsm0_state1)
		(valuables_fsm0_state2)
		(wallets_fsm0_state0)
		(wallets_fsm0_state1)
		(doors_fsm0_state0)
		(doors_fsm0_state1)
		(doors_fsm0_state2)
		(heat_fsm0_state0)
		(heat_fsm0_state1)
		(walking_fsm0_state0)
		(walking_fsm0_state1)
		(building_fsm0_state0)
		(building_fsm0_state1)
		(nearest_fsm0_state0)
		(nearest_fsm0_state1)
		(exit_fsm0_state0)
		(exit_fsm0_state1)
		(911_fsm0_state0)
		(911_fsm0_state1)
		(name_fsm0_state0)
		(name_fsm0_state1)
		(location_fsm0_state0)
		(location_fsm0_state1)
		(pre-determined_fsm0_state0)
		(pre-determined_fsm0_state1)
		(assembly_fsm0_state0)
		(assembly_fsm0_state1)
		(area_fsm0_state0)
		(area_fsm0_state1)
		(there_fsm0_state0)
		(there_fsm0_state1)
		(safety_fsm0_state0)
		(safety_fsm0_state1)
		(personnel_fsm0_state0)
		(personnel_fsm0_state1)
	)
	(:action	provide
	:parameters	(?name - name ?location - location )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	call
	:parameters	(?911 - 911 )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	take
	:parameters	(?valuables - valuables )
	:precondition	(and
				(valuables_fsm0_state2)
	)
	:effect	(and
				(valuables_fsm0_state2)
	))

	(:action	turn-off
	:parameters	(?experiments - experiments )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	secure
	:parameters	(?valuables - valuables ?wallets - wallets )
	:precondition	(and
				(valuables_fsm0_state2)
	)
	:effect	(and
				(valuables_fsm0_state2)
	))

	(:action	using
	:parameters	(?nearest - nearest ?exit - exit )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	proceed
	:parameters	(?pre-determined - pre-determined ?assembly - assembly ?area - area )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	inform
	:parameters	(?safety - safety ?personnel - personnel )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	check
	:parameters	(?doors - doors ?heat - heat )
	:precondition	(and
				(doors_fsm0_state0)
	)
	:effect	(and
				(doors_fsm0_state0)
	))

	(:action	close
	:parameters	(?doors - doors )
	:precondition	(and
				(doors_fsm0_state0)
	)
	:effect	(and
				(doors_fsm0_state0)
	))

	(:action	avoid
	:parameters	(?walking - walking )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	remain
	:parameters	(?there - there )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	evacuate
	:parameters	(?building - building )
	:precondition	(and
	)
	:effect	(and
	))

)
