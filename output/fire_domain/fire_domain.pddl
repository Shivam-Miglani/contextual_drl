(define  (domain fire_domain)
  (:requirements :typing)
  (:types experiment valuable wallet door walking building nearest exit 911 name location pre-determined assembly area there safety personnel)
  (:predicates
    (experiment_fsm0_state0)
    (experiment_fsm0_state1)    (valuable_fsm0_state0)    (valuable_fsm0_state1)    (valuable_fsm0_state2)
    (wallet_fsm0_state0)    (wallet_fsm0_state1)    (door_fsm0_state0)    (door_fsm0_state1)
    (door_fsm0_state2)    (walking_fsm0_state0)    (walking_fsm0_state1)    (building_fsm0_state0)
    (building_fsm0_state1)    (nearest_fsm0_state0)    (nearest_fsm0_state1)    (exit_fsm0_state0)
    (exit_fsm0_state1)    (911_fsm0_state0)    (911_fsm0_state1)    (name_fsm0_state0)
    (name_fsm0_state1)    (location_fsm0_state0)    (location_fsm0_state1)    (pre-determined_fsm0_state0)
    (pre-determined_fsm0_state1)    (assembly_fsm0_state0)    (assembly_fsm0_state1)    (area_fsm0_state0)
    (area_fsm0_state1)    (there_fsm0_state0)    (there_fsm0_state1)    (safety_fsm0_state0)
    (safety_fsm0_state1)    (personnel_fsm0_state0)    (personnel_fsm0_state1)  )
  (:action  take   :parameters  (?valuable - valuable )
   :precondition   (and
        (valuable_fsm0_state2)
   )
   :effect   (and
        (valuable_fsm0_state2)
  ))
  (:action  proceed   :parameters  (?pre-determined - pre-determined ?assembly - assembly ?area - area )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  use   :parameters  (?nearest - nearest ?exit - exit )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  provide   :parameters  (?name - name ?location - location )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  inform   :parameters  (?safety - safety ?personnel - personnel )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  avoid   :parameters  (?walking - walking )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  secure   :parameters  (?valuable - valuable ?wallet - wallet )
   :precondition   (and
        (valuable_fsm0_state2)
   )
   :effect   (and
        (valuable_fsm0_state2)
  ))
  (:action  call   :parameters  (?911 - 911 )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  turnoff   :parameters  (?experiment - experiment )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  close   :parameters  (?door - door )
   :precondition   (and
        (door_fsm0_state1)
   )
   :effect   (and
        (door_fsm0_state1)
  ))
  (:action  check   :parameters  (?door - door )
   :precondition   (and
        (door_fsm0_state1)
   )
   :effect   (and
        (door_fsm0_state1)
  ))
  (:action  evacuate   :parameters  (?building - building )
   :precondition   (and
   )
   :effect   (and
  ))
  (:action  remain   :parameters  (?there - there )
   :precondition   (and
   )
   :effect   (and
  ))
)
