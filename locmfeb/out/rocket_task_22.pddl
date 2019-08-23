(define
   (problem task_22)
   (:domain rocket)
   (:objects jfk london paris - jfk r2 - r)
   (:init
      (zero_state0)
      (jfk_state0 jfk)
      (jfk_state0 london)
      (jfk_state0 paris)
      (r_state0 r2))

   (:goal
      (and
      (zero_state0)
      (jfk_state0 jfk)
      (jfk_state0 london)
      (jfk_state0 paris)
      (r_state0 r2))
)
)
