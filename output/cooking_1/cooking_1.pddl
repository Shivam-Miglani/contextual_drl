(define	(domain cooking_1)
	(:requirements :typing)
	(:types cream mushroom soup salt pepper onion cheese bacon hash mixture it eggs dish recipe everything garlic flavor heat unknown)
	(:predicates
		(cream_fsm0_state0)
		(cream_fsm0_state1)
		(cream_fsm0_state2 ?v0 - salt ?v1 - soup ?v2 - pepper ?v3 - onion ?v4 - mushroom ?v5 - cream ?v6 - cheese)
		(mushroom_fsm0_state0)
		(mushroom_fsm0_state1)
		(soup_fsm0_state0)
		(soup_fsm0_state1)
		(salt_fsm0_state0)
		(salt_fsm0_state1)
		(pepper_fsm0_state0)
		(pepper_fsm0_state1)
		(onion_fsm0_state0)
		(onion_fsm0_state1)
		(cheese_fsm0_state0)
		(cheese_fsm0_state1)
		(bacon_fsm0_state0)
		(bacon_fsm0_state1)
		(hash_fsm0_state0)
		(hash_fsm0_state1)
		(mixture_fsm0_state0)
		(mixture_fsm0_state1)
		(it_fsm0_state0)
		(it_fsm0_state1)
		(eggs_fsm0_state0)
		(eggs_fsm0_state1)
		(dish_fsm0_state0)
		(dish_fsm0_state1)
		(recipe_fsm0_state0)
		(recipe_fsm0_state1)
		(everything_fsm0_state0)
		(everything_fsm0_state1)
		(garlic_fsm0_state0)
		(garlic_fsm0_state1)
		(flavor_fsm0_state0)
		(flavor_fsm0_state1)
		(heat_fsm0_state0)
		(heat_fsm0_state1)
		(heat_fsm0_state2)
	)
	(:action	cooked
	:parameters	(?dish - dish )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	enjoy
	:parameters	(? - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	mixing
	:parameters	(?cream - cream ?mushroom - mushroom ?soup - soup ?cream - cream ?salt - salt ?pepper - pepper ?onion - onion ?cheese - cheese )
	:precondition	(and
				(cream_fsm0_state2 ?v0 - salt ?v1 - soup ?v2 - pepper ?v3 - onion ?v4 - mushroom ?v5 - cream ?v6 - cheese)
	)
	:effect	(and
				(cream_fsm0_state2 ?v0 - salt ?v1 - soup ?v2 - pepper ?v3 - onion ?v4 - mushroom ?v5 - cream ?v6 - cheese)
	))

	(:action	use
	:parameters	(?vegetables - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	put
	:parameters	(?cover - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	add
	:parameters	(?browns - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	combined
	:parameters	(? - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	change
	:parameters	(? - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	served
	:parameters	(?eggs - eggs )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	spray
	:parameters	(?cooker - heat )
	:precondition	(and
				(heat_fsm0_state0)
				(heat_fsm0_state2)
	)
	:effect	(and
				(heat_fsm0_state0)
				(heat_fsm0_state2)
	))

	(:action	serve
	:parameters	(? - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	do
	:parameters	(?everything - everything )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	adding
	:parameters	(?garlic - garlic )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	pour
	:parameters	(?hash - hash ?mixture - mixture )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	turn
	:parameters	(?cooker - heat )
	:precondition	(and
				(heat_fsm0_state0)
				(heat_fsm0_state2)
	)
	:effect	(and
				(heat_fsm0_state0)
				(heat_fsm0_state2)
	))

	(:action	keep
	:parameters	(? - unknown )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	play
	:parameters	(?recipe - recipe )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	leave
	:parameters	(?cooker - heat )
	:precondition	(and
				(heat_fsm0_state0)
				(heat_fsm0_state2)
	)
	:effect	(and
				(heat_fsm0_state0)
				(heat_fsm0_state2)
	))

	(:action	switching
	:parameters	(?flavor - flavor )
	:precondition	(and
	)
	:effect	(and
	))

	(:action	mix
	:parameters	(? - unknown )
	:precondition	(and
	)
	:effect	(and
	))

)
