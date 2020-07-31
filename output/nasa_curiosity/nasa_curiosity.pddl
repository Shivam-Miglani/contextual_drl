(define  (domain nasa_curiosity)
  (:requirements :typing)
  (:types weight mast altitude wheel target rock # spacecraft thruster)
  (:predicates
    (weight_fsm0_state0)
    (weight_fsm0_state1)
    (mast_fsm0_state0)
    (mast_fsm0_state1)
    (altitude_fsm0_state0)
    (altitude_fsm0_state1)
    (wheel_fsm0_state0)
    (wheel_fsm0_state1)
    (target_fsm0_state0)
    (target_fsm0_state1)
    (rock_fsm0_state0)
    (rock_fsm0_state1)
    (rock_fsm0_state2)
    (#_fsm0_state0)
    (#_fsm0_state1)
    (#_fsm0_state2)
    (#_fsm0_state3)
    (spacecraft_fsm0_state0)
    (spacecraft_fsm0_state1)
    (spacecraft_fsm0_state2)
    (spacecraft_fsm0_state3)
    (spacecraft_fsm0_state4)
    (thruster_fsm0_state0)
    (thruster_fsm0_state1)
    (thruster_fsm0_state2 ?v0 - spacecraft)
    (thruster_fsm0_state3)
  )
  (:action  use   :parameters  (?thruster - thruster )
   :precondition   (and
        (thruster_fsm0_state0)
   )
   :effect   (and
        (thruster_fsm0_state3)
  ))

  (:action  lower   :parameters  (?wheel - wheel )
   :precondition   (and
        (wheel_fsm0_state0)
   )
   :effect   (and
        (wheel_fsm0_state1)
  ))

  (:action  composition   :parameters  (?target - target )
   :precondition   (and
        (target_fsm0_state0)
   )
   :effect   (and
        (target_fsm0_state1)
  ))

  (:action  spin   :parameters  (?spacecraft - spacecraft )
   :precondition   (and
        (spacecraft_fsm0_state2)
   )
   :effect   (and
        (spacecraft_fsm0_state3)
  ))

  (:action  fire   :parameters  (?landing - spacecraft ?engine - thruster )
   :precondition   (and
        (spacecraft_fsm0_state0)
        (thruster_fsm0_state1)
   )
   :effect   (and
        (spacecraft_fsm0_state3)
        (thruster_fsm0_state2 ?v0 - spacecraft)
  ))

  (:action  get   :parameters  (?# - # )
   :precondition   (and
        (#_fsm0_state1)
   )
   :effect   (and
        (#_fsm0_state2)
  ))

  (:action  discover   :parameters  (?# - # )
   :precondition   (and
        (#_fsm0_state0)
   )
   :effect   (and
        (#_fsm0_state3)
  ))

  (:action  slow   :parameters  (?mach - # )
   :precondition   (and
        (#_fsm0_state2)
   )
   :effect   (and
        (#_fsm0_state0)
  ))

  (:action  grab   :parameters  (?rock - rock )
   :precondition   (and
        (rock_fsm0_state1)
   )
   :effect   (and
        (rock_fsm0_state2)
  ))

  (:action  deliver   :parameters  (?rock - rock )
   :precondition   (and
        (rock_fsm0_state2)
   )
   :effect   (and
        (rock_fsm0_state0)
  ))

  (:action  slow1   :parameters  (?spacecraft - spacecraft ?thruster - thruster )
   :precondition   (and
        (spacecraft_fsm0_state3)
        (thruster_fsm0_state2 ?v0 - spacecraft)
   )
   :effect   (and
        (spacecraft_fsm0_state4)
        (thruster_fsm0_state0)
  ))

  (:action  reach   :parameters  (?altitude - altitude )
   :precondition   (and
        (altitude_fsm0_state0)
   )
   :effect   (and
        (altitude_fsm0_state1)
  ))

  (:action  throw   :parameters  (?weight - weight )
   :precondition   (and
        (weight_fsm0_state0)
   )
   :effect   (and
        (weight_fsm0_state1)
  ))

  (:action  deploy   :parameters  (?parachute - mast )
   :precondition   (and
        (mast_fsm0_state0)
   )
   :effect   (and
        (mast_fsm0_state1)
  ))

  (:action  rebalance   :parameters  (?spacecraft - spacecraft )
   :precondition   (and
        (spacecraft_fsm0_state4)
   )
   :effect   (and
        (spacecraft_fsm0_state1)
  ))

)
