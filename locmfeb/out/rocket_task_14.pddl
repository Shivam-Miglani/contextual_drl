(define
   (problem task_14)
   (:domain rocket)
   (:objects c2 - c london lyon paris - jfk r1 r2 - r)
   (:init
      (zero_state0)
      (c_state0 c2)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))

   (:goal
      (and
      (zero_state0)
      (c_state1 c2 r1)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))
)
)
