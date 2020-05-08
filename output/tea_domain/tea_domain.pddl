(define  (domain tea_domain)
  (:requirements :typing)
  (:types home cafe tea minute hand water milk teabag)
  (:predicates
    (home_fsm0_state0)
    (home_fsm0_state1)    (cafe_fsm0_state0)    (cafe_fsm0_state1)    (tea_fsm0_state0)
    (tea_fsm0_state1)    (minute_fsm0_state0)    (minute_fsm0_state1)    (hand_fsm0_state0)
    (hand_fsm0_state1)    (water_fsm0_state0)    (water_fsm0_state1)    (water_fsm0_state2)
    (milk_fsm0_state0)    (milk_fsm0_state1)    (milk_fsm0_state2)    (teabag_fsm0_state0)
    (teabag_fsm0_state1)    (teabag_fsm0_state2)  )
  (:action  walk   :parameters  (?cafe - cafe )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  start   :parameters  (?home - home )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  wait   :parameters  (?minute - minute )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  mix   :parameters  (?teabag - teabag ?water - water ?milk - milk )
   :precondition   (and
        (teabag_fsm0_state1)
        (water_fsm0_state1)
        (milk_fsm0_state0)
   )
   :effect   (and
        (teabag_fsm0_state1)
        (water_fsm0_state1)
        (milk_fsm0_state0)
  ))
  (:action  buy   :parameters  (?tea - tea )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  add   :parameters  (?water - water )
   :precondition   (and
        (water_fsm0_state1)
   )
   :effect   (and
        (water_fsm0_state1)
  ))
  (:action  clean   :parameters  (?hand - hand )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  pour   :parameters  (?milk - milk )
   :precondition   (and
        (milk_fsm0_state0)
   )
   :effect   (and
        (milk_fsm0_state0)
  ))
  (:action  dip   :parameters  (?teabag - teabag )
   :precondition   (and
        (teabag_fsm0_state1)
   )
   :effect   (and
        (teabag_fsm0_state1)
  ))
)
