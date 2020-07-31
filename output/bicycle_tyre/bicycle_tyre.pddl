(define  (domain bicycle_tyre)
  (:requirements :typing)
  (:types brake wheel wrench cap tube second inner hole alcohol pad area glue finger bit air shape bike tire stem bead)
  (:predicates
    (brake_fsm0_state0)
    (brake_fsm0_state1)
    (wheel_fsm0_state0)
    (wrench_fsm0_state0)
    (wrench_fsm0_state1)
    (cap_fsm0_state0)
    (cap_fsm0_state1)
    (tube_fsm0_state0)
    (tube_fsm0_state1)
    (tube_fsm0_state2)
    (second_fsm0_state0)
    (second_fsm0_state1)
    (inner_fsm0_state0)
    (inner_fsm0_state1)
    (hole_fsm0_state0)
    (alcohol_fsm0_state0)
    (alcohol_fsm0_state1)
    (pad_fsm0_state0)
    (pad_fsm0_state1)
    (area_fsm0_state0)
    (area_fsm0_state1)
    (glue_fsm0_state0)
    (glue_fsm0_state1)
    (finger_fsm0_state0)
    (finger_fsm0_state1)
    (bit_fsm0_state0)
    (bit_fsm0_state1)
    (air_fsm0_state0)
    (air_fsm0_state1)
    (air_fsm0_state2)
    (shape_fsm0_state0)
    (shape_fsm0_state1)
    (bike_fsm0_state0)
    (bike_fsm0_state1)
    (tire_fsm0_state0 ?v0 - stem)
    (tire_fsm0_state1)
    (tire_fsm0_state2)
    (tire_fsm0_state3)
    (tire_fsm0_state4)
    (tire_fsm0_state5)
    (tire_fsm0_state6)
    (tire_fsm0_state7)
    (stem_fsm0_state0)
    (stem_fsm0_state1 ?v0 - tire)
    (stem_fsm0_state2 ?v1 - tire)
    (stem_fsm0_state3)
    (bead_fsm0_state0)
    (bead_fsm0_state1)
    (bead_fsm0_state2)
  )
  (:action  use   :parameters  (?second - second ?tire - tire ?lever - stem )
   :precondition   (and
        (second_fsm0_state0)
        (tire_fsm0_state3)
        (stem_fsm0_state2 ?v1 - tire)
   )
   :effect   (and
        (second_fsm0_state1)
        (tire_fsm0_state2)
        (stem_fsm0_state3)
  ))

  (:action  inflate   :parameters  (?tire - tire )
   :precondition   (and
        (tire_fsm0_state2)
   )
   :effect   (and
        (tire_fsm0_state1)
  ))

  (:action  disconnect   :parameters  (?brake - brake )
   :precondition   (and
        (brake_fsm0_state0)
   )
   :effect   (and
        (brake_fsm0_state1)
  ))

  (:action  flip   :parameters  (?bead - bead ?tire - tire )
   :precondition   (and
        (bead_fsm0_state1)
        (tire_fsm0_state4)
   )
   :effect   (and
        (bead_fsm0_state2)
        (tire_fsm0_state3)
  ))

  (:action  hook   :parameters  (?tire - tire ?lever - stem )
   :precondition   (and
        (tire_fsm0_state0 ?v0 - stem)
        (stem_fsm0_state1 ?v0 - tire)
   )
   :effect   (and
        (tire_fsm0_state4)
        (stem_fsm0_state2 ?v1 - tire)
  ))

  (:action  pull   :parameters  (?inner - inner ?tube - tube )
   :precondition   (and
        (inner_fsm0_state0)
        (tube_fsm0_state2)
   )
   :effect   (and
        (inner_fsm0_state1)
        (tube_fsm0_state0)
  ))

  (:action  clean   :parameters  (?area - area )
   :precondition   (and
        (area_fsm0_state0)
   )
   :effect   (and
        (area_fsm0_state1)
  ))

  (:action  deflate   :parameters  (?tube - tube )
   :precondition   (and
        (tube_fsm0_state1)
   )
   :effect   (and
        (tube_fsm0_state2)
  ))

  (:action  reattach   :parameters  (?bike - bike )
   :precondition   (and
        (bike_fsm0_state0)
   )
   :effect   (and
        (bike_fsm0_state1)
  ))

  (:action  use1   :parameters  (?wrench - wrench )
   :precondition   (and
        (wrench_fsm0_state0)
   )
   :effect   (and
        (wrench_fsm0_state1)
  ))

  (:action  take   :parameters  (?wheel - wheel )
   :precondition   (and
        (wheel_fsm0_state0)
   )
   :effect   (and
        (wheel_fsm0_state0)
  ))

  (:action  run   :parameters  (?finger - finger )
   :precondition   (and
        (finger_fsm0_state0)
   )
   :effect   (and
        (finger_fsm0_state1)
  ))

  (:action  patch   :parameters  (?hole - hole )
   :precondition   (and
        (hole_fsm0_state0)
   )
   :effect   (and
        (hole_fsm0_state0)
  ))

  (:action  work   :parameters  (?tip - bead )
   :precondition   (and
        (bead_fsm0_state2)
   )
   :effect   (and
        (bead_fsm0_state0)
  ))

  (:action  use2   :parameters  (?alcohol - alcohol ?pad - pad )
   :precondition   (and
        (alcohol_fsm0_state0)
        (pad_fsm0_state0)
   )
   :effect   (and
        (alcohol_fsm0_state1)
        (pad_fsm0_state1)
  ))

  (:action  put   :parameters  (?bit - bit ?air - air )
   :precondition   (and
        (bit_fsm0_state0)
        (air_fsm0_state1)
   )
   :effect   (and
        (bit_fsm0_state1)
        (air_fsm0_state2)
  ))

  (:action  pinch   :parameters  (?tire - tire )
   :precondition   (and
        (tire_fsm0_state5)
   )
   :effect   (and
        (tire_fsm0_state7)
  ))

  (:action  unscrew   :parameters  (?valve - tire ?cap - cap )
   :precondition   (and
        (tire_fsm0_state6)
        (cap_fsm0_state0)
   )
   :effect   (and
        (tire_fsm0_state7)
        (cap_fsm0_state1)
  ))

  (:action  apply   :parameters  (?glue - glue )
   :precondition   (and
        (glue_fsm0_state0)
   )
   :effect   (and
        (glue_fsm0_state1)
  ))

  (:action  insert   :parameters  (?tire - tire ?lever - stem )
   :precondition   (and
        (tire_fsm0_state7)
        (stem_fsm0_state0)
   )
   :effect   (and
        (tire_fsm0_state0 ?v0 - stem)
        (stem_fsm0_state1 ?v0 - tire)
  ))

  (:action  give   :parameters  (?air - air ?shape - shape )
   :precondition   (and
        (air_fsm0_state2)
        (shape_fsm0_state0)
   )
   :effect   (and
        (air_fsm0_state0)
        (shape_fsm0_state1)
  ))

)
