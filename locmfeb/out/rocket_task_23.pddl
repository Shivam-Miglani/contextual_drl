(define
   (problem task_23)
   (:domain rocket)
   (:objects london paris - jfk r2 - r)
   (:init
      (zero_state0)
      (jfk_state0 london)
      (jfk_state0 paris)
      (r_state0 r2))

   (:goal
      (and
      (zero_state0)
      (jfk_state0 london)
      (jfk_state0 paris)
      (r_state0 r2))
)
)
