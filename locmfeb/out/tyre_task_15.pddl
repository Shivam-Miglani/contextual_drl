(define
   (problem task_15)
   (:domain tyre)
   (:objects boot0 boot1 - boot hub0 hub1 - hub jack0 - jack wheel2 - wheel)
   (:init
      (zero_state0)
      (boot_state0 boot0)
      (boot_state1 boot1)
      (hub_state3 hub0)
      (hub_state2 hub1 jack0)
      (jack_state2 jack0 hub1)
      (wheel_state1 wheel2))

   (:goal
      (and
      (zero_state0)
      (boot_state1 boot0)
      (boot_state1 boot1)
      (hub_state3 hub0)
      (hub_state3 hub1)
      (jack_state4 jack0 boot0)
      (wheel_state2 wheel2 boot0))
)
)
