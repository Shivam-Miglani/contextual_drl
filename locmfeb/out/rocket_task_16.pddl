(define
   (problem task_16)
   (:domain rocket)
   (:objects jfk london lyon paris - jfk r1 r2 - r)
   (:init
      (zero_state0)
      (jfk_state0 jfk)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))

   (:goal
      (and
      (zero_state0)
      (jfk_state0 jfk)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))
)
)
