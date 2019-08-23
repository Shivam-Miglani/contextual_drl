
(define
   (domain tyre)
   (:requirements :typing)
   (:types boot hub jack nuts wheel wrench zero)
   (:predicates
      (boot_state0 ?v1 - boot)
      (boot_state1 ?v1 - boot)
      (hub_state0 ?v1 - hub ?v2 - jack)
      (hub_state1 ?v1 - hub ?v2 - jack)
      (hub_state2 ?v1 - hub ?v2 - jack)
      (hub_state3 ?v1 - hub)
      (jack_state0 ?v1 - jack ?v2 - hub)
      (jack_state1 ?v1 - jack ?v2 - hub)
      (jack_state2 ?v1 - jack ?v2 - hub)
      (jack_state3 ?v1 - jack)
      (jack_state4 ?v1 - jack ?v2 - boot)
      (vts)
      (nuts_state1 ?v1 - nuts ?v2 - hub)
      (nuts_state2 ?v1 - nuts ?v2 - hub)
      (wheel_state0 ?v1 - wheel ?v2 - hub)
      (wheel_state1 ?v1 - wheel)
      (wheel_state2 ?v1 - wheel ?v2 - boot)
      (wrench_state0 ?v1 - wrench ?v2 - boot)
      (wrench_state1 ?v1 - wrench)
      (zero_state0))

   (:action
   close_container
   :parameters
   (?Boot1 - boot)
   :precondition
   (and
      (zero_state0)
      (boot_state0 ?Boot1))

   :effect
   (and
      (boot_state1 ?Boot1)
      (not (boot_state0 ?Boot1)))
)

   (:action
   do_up
   :parameters
   (?Nuts1 - nuts ?Hub2 - hub ?Wrench4 - wrench ?Jack3 - jack)
   :precondition
   (and
      (zero_state0)
      (nuts_state0 ?Nuts1)
      (hub_state0 ?Hub2 ?Jack3)
      (wrench_state1 ?Wrench4)
      (jack_state0 ?Jack3 ?Hub2))

   :effect
   (and
      (nuts_state1 ?Nuts1 ?Hub2)
      (not (nuts_state0 ?Nuts1))
      (hub_state2 ?Hub2 ?Jack3)
      (not (hub_state0 ?Hub2 ?Jack3))
      (jack_state2 ?Jack3 ?Hub2)
      (not (jack_state0 ?Jack3 ?Hub2)))
)

   (:action
   fetch_jack
   :parameters
   (?Jack1 - jack ?Boot2 - boot)
   :precondition
   (and
      (zero_state0)
      (jack_state4 ?Jack1 ?Boot2)
      (boot_state0 ?Boot2))

   :effect
   (and
      (jack_state3 ?Jack1)
      (not (jack_state4 ?Jack1 ?Boot2)))
)

   (:action
   fetch_wheel
   :parameters
   (?Wheel1 - wheel ?Boot2 - boot)
   :precondition
   (and
      (zero_state0)
      (wheel_state2 ?Wheel1 ?Boot2)
      (boot_state0 ?Boot2))

   :effect
   (and
      (wheel_state1 ?Wheel1)
      (not (wheel_state2 ?Wheel1 ?Boot2)))
)

   (:action
   fetch_wrench
   :parameters
   (?Wrench1 - wrench ?Boot2 - boot)
   :precondition
   (and
      (zero_state0)
      (wrench_state0 ?Wrench1 ?Boot2)
      (boot_state0 ?Boot2))

   :effect
   (and
      (wrench_state1 ?Wrench1)
      (not (wrench_state0 ?Wrench1 ?Boot2)))
)

   (:action
   jack_down
   :parameters
   (?Hub1 - hub ?Jack2 - jack)
   :precondition
   (and
      (zero_state0)
      (hub_state2 ?Hub1 ?Jack2)
      (jack_state2 ?Jack2 ?Hub1))

   :effect
   (and
      (hub_state3 ?Hub1)
      (not (hub_state2 ?Hub1 ?Jack2))
      (jack_state3 ?Jack2)
      (not (jack_state2 ?Jack2 ?Hub1)))
)

   (:action
   jack_up
   :parameters
   (?Hub1 - hub ?Jack2 - jack)
   :precondition
   (and
      (zero_state0)
      (hub_state3 ?Hub1)
      (jack_state3 ?Jack2))

   :effect
   (and
      (hub_state2 ?Hub1 ?Jack2)
      (not (hub_state3 ?Hub1))
      (jack_state2 ?Jack2 ?Hub1)
      (not (jack_state3 ?Jack2)))
)

   (:action
   loosen
   :parameters
   (?Nuts1 - nuts ?Hub2 - hub ?Wrench3 - wrench)
   :precondition
   (and
      (zero_state0)
      (nuts_state2 ?Nuts1 ?Hub2)
      (hub_state3 ?Hub2)
      (wrench_state1 ?Wrench3))

   :effect
   (and
      (nuts_state1 ?Nuts1 ?Hub2)
      (not (nuts_state2 ?Nuts1 ?Hub2)))
)

   (:action
   open_container
   :parameters
   (?Boot1 - boot)
   :precondition
   (and
      (zero_state0)
      (boot_state1 ?Boot1))

   :effect
   (and
      (boot_state0 ?Boot1)
      (not (boot_state1 ?Boot1)))
)

   (:action
   put_on_wheel
   :parameters
   (?Wheel1 - wheel ?Hub2 - hub ?Jack3 - jack)
   :precondition
   (and
      (zero_state0)
      (wheel_state1 ?Wheel1)
      (hub_state1 ?Hub2 ?Jack3)
      (jack_state1 ?Jack3 ?Hub2))

   :effect
   (and
      (wheel_state0 ?Wheel1 ?Hub2)
      (not (wheel_state1 ?Wheel1))
      (hub_state0 ?Hub2 ?Jack3)
      (not (hub_state1 ?Hub2 ?Jack3))
      (jack_state0 ?Jack3 ?Hub2)
      (not (jack_state1 ?Jack3 ?Hub2)))
)

   (:action
   putaway_jack
   :parameters
   (?Jack1 - jack ?Boot2 - boot)
   :precondition
   (and
      (zero_state0)
      (jack_state3 ?Jack1)
      (boot_state0 ?Boot2))

   :effect
   (and
      (jack_state4 ?Jack1 ?Boot2)
      (not (jack_state3 ?Jack1)))
)

   (:action
   putaway_wheel
   :parameters
   (?Wheel1 - wheel ?Boot2 - boot)
   :precondition
   (and
      (zero_state0)
      (wheel_state1 ?Wheel1)
      (boot_state0 ?Boot2))

   :effect
   (and
      (wheel_state2 ?Wheel1 ?Boot2)
      (not (wheel_state1 ?Wheel1)))
)

   (:action
   putaway_wrench
   :parameters
   (?Wrench1 - wrench ?Boot2 - boot)
   :precondition
   (and
      (zero_state0)
      (wrench_state1 ?Wrench1)
      (boot_state0 ?Boot2))

   :effect
   (and
      (wrench_state0 ?Wrench1 ?Boot2)
      (not (wrench_state1 ?Wrench1)))
)

   (:action
   remove_wheel
   :parameters
   (?Wheel1 - wheel ?Hub2 - hub ?Jack3 - jack)
   :precondition
   (and
      (zero_state0)
      (wheel_state0 ?Wheel1 ?Hub2)
      (hub_state0 ?Hub2 ?Jack3)
      (jack_state0 ?Jack3 ?Hub2))

   :effect
   (and
      (wheel_state1 ?Wheel1)
      (not (wheel_state0 ?Wheel1 ?Hub2))
      (hub_state1 ?Hub2 ?Jack3)
      (not (hub_state0 ?Hub2 ?Jack3))
      (jack_state1 ?Jack3 ?Hub2)
      (not (jack_state0 ?Jack3 ?Hub2)))
)

   (:action
   tighten
   :parameters
   (?Nuts1 - nuts ?Hub2 - hub ?Wrench3 - wrench)
   :precondition
   (and
      (zero_state0)
      (nuts_state1 ?Nuts1 ?Hub2)
      (hub_state3 ?Hub2)
      (wrench_state1 ?Wrench3))

   :effect
   (and
      (nuts_state2 ?Nuts1 ?Hub2)
      (not (nuts_state1 ?Nuts1 ?Hub2)))
)

   (:action
   undo
   :parameters
   (?Nuts1 - nuts ?Hub2 - hub ?Wrench4 - wrench ?Jack3 - jack)
   :precondition
   (and
      (zero_state0)
      (nuts_state1 ?Nuts1 ?Hub2)
      (hub_state2 ?Hub2 ?Jack3)
      (wrench_state1 ?Wrench4)
      (jack_state2 ?Jack3 ?Hub2))

   :effect
   (and
      (nuts_state0 ?Nuts1)
      (not (nuts_state1 ?Nuts1 ?Hub2))
      (hub_state0 ?Hub2 ?Jack3)
      (not (hub_state2 ?Hub2 ?Jack3))
      (jack_state0 ?Jack3 ?Hub2)
      (not (jack_state2 ?Jack3 ?Hub2)))
)
)

