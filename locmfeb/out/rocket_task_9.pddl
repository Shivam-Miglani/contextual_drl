(define
   (problem task_9)
   (:domain rocket)
   (:objects c1 c2 c3 - c london lyon paris - jfk r1 r2 - r)
   (:init
      (zero_state0)
      (c_state0 c1)
      (c_state0 c2)
      (c_state0 c3)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))

   (:goal
      (and
      (zero_state0)
      (c_state1 c1 r1)
      (c_state1 c2 r1)
      (c_state1 c3 r1)
      (jfk_state0 london)
      (jfk_state0 lyon)
      (jfk_state0 paris)
      (r_state0 r1)
      (r_state0 r2))
)
)
