(define  (domain tea_domain)
  (:requirements :typing)
  (:types home cafe tea minutes. water milk teabag mug)
  (:predicates
    (home_fsm0_state0)
    (home_fsm0_state1)
    (cafe_fsm0_state0)
    (cafe_fsm0_state1)
    (tea_fsm0_state0)
    (tea_fsm0_state1)
    (minutes._fsm0_state0)
    (minutes._fsm0_state1)
    (water_fsm0_state0)
    (water_fsm0_state1)
    (water_fsm0_state2)
    (milk_fsm0_state0)
    (milk_fsm0_state1)
    (milk_fsm0_state2)
    (teabag_fsm0_state0)
    (teabag_fsm0_state1)
    (teabag_fsm0_state2)
    (mug_fsm0_state0)
    (mug_fsm0_state1)
  )
  (:action  wait   :parameters  (?minutes. - minutes. )
   :precondition   (and
        (minutes._fsm0_state0)
   )
   :effect   (and
        (minutes._fsm0_state1)
  ))

  (:action  start   :parameters  (?home - home )
   :precondition   (and
        (home_fsm0_state0)
   )
   :effect   (and
        (home_fsm0_state1)
  ))

  (:action  buy   :parameters  (?tea - tea )
   :precondition   (and
        (tea_fsm0_state0)
   )
   :effect   (and
        (tea_fsm0_state1)
  ))

  (:action  add   :parameters  (?water - water )
   :precondition   (and
        (water_fsm0_state1)
   )
   :effect   (and
        (water_fsm0_state2)
  ))

  (:action  mix   :parameters  (?teabag - teabag ?water - water ?milk - milk )
   :precondition   (and
        (teabag_fsm0_state2)
        (water_fsm0_state2)
        (milk_fsm0_state2)
   )
   :effect   (and
        (teabag_fsm0_state0)
        (water_fsm0_state0)
        (milk_fsm0_state0)
  ))

  (:action  dip   :parameters  (?teabag - teabag ?mug - mug )
   :precondition   (and
        (teabag_fsm0_state1)
        (mug_fsm0_state0)
   )
   :effect   (and
        (teabag_fsm0_state2)
        (mug_fsm0_state1)
  ))

  (:action  walk   :parameters  (?cafe - cafe )
   :precondition   (and
        (cafe_fsm0_state0)
   )
   :effect   (and
        (cafe_fsm0_state1)
  ))

  (:action  pour   :parameters  (?milk - milk )
   :precondition   (and
        (milk_fsm0_state1)
   )
   :effect   (and
        (milk_fsm0_state2)
  ))

)
