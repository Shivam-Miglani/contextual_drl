;;********************Learned PDDL domain******************
(define  (domain nasa_curiosity)
  (:requirements :typing)
  (:types spacecraft atmosphere cruise weight landing engine foot wheel descent laser kind target rock red planet preparation)
  (:predicates
    (spacecraft_fsm0_state0)
    (spacecraft_fsm0_state1)    (spacecraft_fsm0_state2)    (atmosphere_fsm0_state0)    (atmosphere_fsm0_state1)
    (cruise_fsm0_state0)    (cruise_fsm0_state1)    (weight_fsm0_state0)    (weight_fsm0_state1)
    (landing_fsm0_state0)    (landing_fsm0_state1 ?v0 - engine)    (landing_fsm0_state2)    (engine_fsm0_state0 ?v0 - landing)
    (engine_fsm0_state1)    (engine_fsm0_state2)    (foot_fsm0_state0)    (foot_fsm0_state1)
    (wheel_fsm0_state0)    (wheel_fsm0_state1)    (descent_fsm0_state0)    (descent_fsm0_state1)
    (laser_fsm0_state0)    (laser_fsm0_state1)    (kind_fsm0_state0)    (kind_fsm0_state1)
    (target_fsm0_state0)    (target_fsm0_state1)    (target_fsm0_state2)    (rock_fsm0_state0)
    (rock_fsm0_state1)    (rock_fsm0_state2)    (red_fsm0_state0)    (red_fsm0_state1)
    (planet_fsm0_state0)    (planet_fsm0_state1)    (preparation_fsm0_state0)    (preparation_fsm0_state1)
    (preparation_fsm0_state2)    (preparation_fsm0_state3)    (preparation_fsm0_state4)    (preparation_fsm0_state5)
    (preparation_fsm0_state6)  )
  (:action  entry   :parameters  (?# - preparation )
   :precondition   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
   )
   :effect   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
  ))

  (:action  deploy   :parameters  (?# - preparation )
   :precondition   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
   )
   :effect   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
  ))

  (:action  deliver   :parameters  (?rock - rock )
   :precondition   (and
        (rock_fsm0_state1)
   )
   :effect   (and
        (rock_fsm0_state1)
  ))

  (:action  hit   :parameters  (?atmosphere - atmosphere ?cruise - cruise )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  slow   :parameters  (?# - preparation )
   :precondition   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
   )
   :effect   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
  ))

  (:action  detect   :parameters  (?descent - descent )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  descend   :parameters  (?foot - foot )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  throw   :parameters  (?weight - weight )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  fire   :parameters  (?landing - landing ?engine - engine )
   :precondition   (and
        (landing_fsm0_state1 ?v0 - engine)
        (engine_fsm0_state0 ?v0 - landing)
   )
   :effect   (and
        (landing_fsm0_state1 ?v0 - engine)
        (engine_fsm0_state0 ?v0 - landing)
  ))

  (:action  explore   :parameters  (?red - red ?planet - planet )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  composition   :parameters  (?target - target )
   :precondition   (and
        (target_fsm0_state1)
   )
   :effect   (and
        (target_fsm0_state1)
  ))

  (:action  grab   :parameters  (?rock - rock )
   :precondition   (and
        (rock_fsm0_state1)
   )
   :effect   (and
        (rock_fsm0_state1)
  ))

  (:action  understand   :parameters  (?kind - kind )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  lower   :parameters  (?wheel - wheel )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  land   :parameters  (?# - preparation )
   :precondition   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
   )
   :effect   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
  ))

  (:action  rebalance   :parameters  (?spacecraft - spacecraft )
   :precondition   (and
        (spacecraft_fsm0_state1)
   )
   :effect   (and
        (spacecraft_fsm0_state1)
  ))

  (:action  drive   :parameters  (?# - preparation )
   :precondition   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
   )
   :effect   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
  ))

  (:action  inspect   :parameters  (?target - target )
   :precondition   (and
        (target_fsm0_state1)
   )
   :effect   (and
        (target_fsm0_state1)
  ))

  (:action  line   :parameters  (?parachute - preparation )
   :precondition   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
   )
   :effect   (and
        (preparation_fsm0_state0)
        (preparation_fsm0_state3)
        (preparation_fsm0_state4)
        (preparation_fsm0_state5)
  ))

  (:action  shoot   :parameters  (?laser - laser )
   :precondition   (and
   )
   :effect   (and
  ))

  (:action  spin   :parameters  (?spacecraft - spacecraft )
   :precondition   (and
        (spacecraft_fsm0_state1)
   )
   :effect   (and
        (spacecraft_fsm0_state1)
  ))

  (:action  slow1   :parameters  (?landing - landing ?engine - engine )
   :precondition   (and
        (landing_fsm0_state1 ?v0 - engine)
        (engine_fsm0_state0 ?v0 - landing)
   )
   :effect   (and
        (landing_fsm0_state1 ?v0 - engine)
        (engine_fsm0_state0 ?v0 - landing)
  ))

)