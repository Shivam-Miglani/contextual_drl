(define  (domain childsnack_domain)
  (:requirements :typing)
  (:types gluten-free sandwich kitchen)
  (:predicates
    (gluten-free_fsm0_state0 ?v0 - sandwich)
    (sandwich_fsm0_state0)
    (sandwich_fsm0_state1)
    (sandwich_fsm0_state2 ?v0 - gluten-free)
    (sandwich_fsm0_state3)
    (sandwich_fsm1_state0)
    (sandwich_fsm1_state1)
    (sandwich_fsm1_state2)
    (sandwich_fsm1_state3)
    (sandwich_fsm1_state4 ?v0 - gluten-free)
    (sandwich_fsm2_state0 ?v0 - gluten-free)
    (sandwich_fsm2_state1)
    (kitchen_fsm0_state0)
  )
  (:action  make   :parameters  (?sandwich - sandwich )
   :precondition   (and
        (sandwich_fsm1_state1)
   )
   :effect   (and
        (sandwich_fsm1_state2)
  ))

  (:action  put   :parameters  (?sandwich - sandwich )
   :precondition   (and
        (sandwich_fsm0_state2 ?v0 - gluten-free)
        (sandwich_fsm2_state0 ?v0 - gluten-free)
   )
   :effect   (and
        (sandwich_fsm0_state3)
        (sandwich_fsm2_state1)
  ))

  (:action  move   :parameters  (?tray - kitchen )
   :precondition   (and
        (kitchen_fsm0_state0)
   )
   :effect   (and
        (kitchen_fsm0_state0)
  ))

  (:action  put1   :parameters  (?gluten-free - gluten-free ?sandwich - sandwich )
   :precondition   (and
        (gluten-free_fsm0_state0 ?v0 - sandwich)
        (sandwich_fsm0_state2 ?v0 - gluten-free)
        (sandwich_fsm1_state4 ?v0 - gluten-free)
   )
   :effect   (and
        (gluten-free_fsm0_state0 ?v0 - sandwich)
        (sandwich_fsm0_state0)
        (sandwich_fsm1_state0)
  ))

  (:action  make1   :parameters  (?gluten-free - gluten-free ?sandwich - sandwich )
   :precondition   (and
        (gluten-free_fsm0_state0 ?v0 - sandwich)
        (sandwich_fsm0_state1)
        (sandwich_fsm1_state3)
        (sandwich_fsm2_state1)
   )
   :effect   (and
        (gluten-free_fsm0_state0 ?v0 - sandwich)
        (sandwich_fsm0_state2 ?v0 - gluten-free)
        (sandwich_fsm1_state4 ?v0 - gluten-free)
        (sandwich_fsm2_state0 ?v0 - gluten-free)
  ))

  (:action  serve   :parameters  (?sandwich - sandwich )
   :precondition   (and
        (sandwich_fsm2_state1)
   )
   :effect   (and
        (sandwich_fsm2_state1)
  ))

)
