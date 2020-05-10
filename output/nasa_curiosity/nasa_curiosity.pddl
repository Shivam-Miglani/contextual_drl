(define  (domain nasa_curiosity)
  (:requirements :typing)
  (:types weight mast altitude wheel target rock landing engine #)
  (:predicates
    (weight_fsm0_state0)
    (weight_fsm0_state1)    (mast_fsm0_state0)    (mast_fsm0_state1)    (altitude_fsm0_state0)
    (altitude_fsm0_state1)    (wheel_fsm0_state0)    (wheel_fsm0_state1)    (target_fsm0_state0)
    (target_fsm0_state1)    (target_fsm0_state2)    (rock_fsm0_state0)    (rock_fsm0_state1)
    (rock_fsm0_state2)    (landing_fsm0_state0)    (landing_fsm0_state1)    (landing_fsm0_state2 ?v0 - engine)
    (landing_fsm0_state3)    (landing_fsm0_state4)    (engine_fsm0_state0 ?v0 - landing)    (engine_fsm0_state1)
    (engine_fsm0_state2)    (engine_fsm0_state3)    (#_fsm0_state0)    (#_fsm0_state1)
    (#_fsm0_state2)  )
  (:action  lower   :parameters  (?wheel - wheel )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  rebalance   :parameters  (?spacecraft - landing )
   :precondition   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
   )
   :effect   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
  ))
  (:action  use   :parameters  (?thruster - engine )
   :precondition   (and
        (engine_fsm0_state0 ?v0 - landing)
        (engine_fsm0_state3)
   )
   :effect   (and
        (engine_fsm0_state0 ?v0 - landing)
        (engine_fsm0_state3)
  ))
  (:action  grab   :parameters  (?rock - rock )
   :precondition   (and
        (rock_fsm0_state2)
   )
   :effect   (and
        (rock_fsm0_state2)
  ))
  (:action  deliver   :parameters  (?rock - rock )
   :precondition   (and
        (rock_fsm0_state2)
   )
   :effect   (and
        (rock_fsm0_state2)
  ))
  (:action  slow   :parameters  (?mach - # )
   :precondition   (and
        (#_fsm0_state1)
   )
   :effect   (and
        (#_fsm0_state1)
  ))
  (:action  spin   :parameters  (?spacecraft - landing )
   :precondition   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
   )
   :effect   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
  ))
  (:action  slow1   :parameters  (?spacecraft - landing ?thruster - engine )
   :precondition   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
        (engine_fsm0_state0 ?v0 - landing)
        (engine_fsm0_state3)
   )
   :effect   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
        (engine_fsm0_state0 ?v0 - landing)
        (engine_fsm0_state3)
  ))
  (:action  deploy   :parameters  (?parachute - mast )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  throw   :parameters  (?weight - weight )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  discover   :parameters  (?# - # )
   :precondition   (and
        (#_fsm0_state1)
   )
   :effect   (and
        (#_fsm0_state1)
  ))
  (:action  reach   :parameters  (?altitude - altitude )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  fire   :parameters  (?landing - landing ?engine - engine )
   :precondition   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
        (engine_fsm0_state0 ?v0 - landing)
        (engine_fsm0_state3)
   )
   :effect   (and
        (landing_fsm0_state2 ?v0 - engine)
        (landing_fsm0_state3)
        (engine_fsm0_state0 ?v0 - landing)
        (engine_fsm0_state3)
  ))
  (:action  inspect   :parameters  (?target - target )
   :precondition   (and
        (target_fsm0_state1)
   )
   :effect   (and
        (target_fsm0_state1)
  ))
  (:action  composition   :parameters  (?target - target )
   :precondition   (and
        (target_fsm0_state1)
   )
   :effect   (and
        (target_fsm0_state1)
  ))
)
