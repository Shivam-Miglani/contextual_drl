
(define
   (domain rocket)
   (:requirements :typing)
   (:types c jfk r zero)
   (:predicates
      (c_state0 ?v1 - c)
      (c_state1 ?v1 - c ?v2 - r)
      (c_state2 ?v1 - c)
      (jfk_state0 ?v1 - jfk)
      (r_state0 ?v1 - r)
      (zero_state0))

   (:action
   load
   :parameters
   (?C1 - c ?R2 - r ?Jfk3 - jfk)
   :precondition
   (and
      (zero_state0)
      (c_state0 ?C1)
      (r_state0 ?R2)
      (jfk_state0 ?Jfk3))

   :effect
   (and
      (c_state1 ?C1 ?R2)
      (not (c_state0 ?C1)))
)

   (:action
   move
   :parameters
   (?R1 - r ?Jfk2 - jfk ?Jfk3 - jfk)
   :precondition
   (and
      (zero_state0)
      (r_state0 ?R1)
      (jfk_state0 ?Jfk2)
      (jfk_state0 ?Jfk3))

   :effect
   (and
)
)

   (:action
   unload
   :parameters
   (?C1 - c ?R2 - r ?Jfk3 - jfk)
   :precondition
   (and
      (zero_state0)
      (c_state1 ?C1 ?R2)
      (r_state0 ?R2)
      (jfk_state0 ?Jfk3))

   :effect
   (and
      (c_state2 ?C1)
      (not (c_state1 ?C1 ?R2)))
)
)

