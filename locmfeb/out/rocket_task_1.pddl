(define
   (problem task_1)
   (:domain rocket)
   (:objects c1 c2 c4 - c london lyon paris - jfk r1 r2 - r)
   (:init
      (zero_state0)
      (c_state0 c1)
      (c_state0 c2)
      (c_state0 c4)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))

   (:goal
      (and
      (zero_state0)
      (c_state2 c1)
      (c_state2 c2)
      (c_state1 c4 r1)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))
)
)
