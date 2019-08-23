(define (domain tyre)
  (:requirements :strips :equality :typing)

  (:types  container nuts hub pump wheel wrench jack)


  (:predicates
    (closed ?container1 - container)
    (open ?container1 - container)
    (tight ?nuts1 - nuts ?hub1 - hub)
    (loose ?nuts1 - nuts ?hub1 - hub)
    (have_nuts ?nuts1 - nuts)
    (on_ground ?hub1 - hub)
    (fastened ?hub1 - hub)
    (jacked_up ?hub1 - hub ?jack1 - jack)
    (free ?hub1 - hub)
    (unfastened ?hub1 - hub)
    (have_pump ?pump1 - pump)
    (pump_in ?pump1 - pump ?container1 - container)
    (have_wheel ?wheel1 - wheel)
    (wheel_in ?wheel1 - wheel ?container1 - container)
    (wheel_on ?wheel1 - wheel ?hub1 - hub)
    (have_wrench ?wrench1 - wrench)
    (wrench_in ?wrench1 - wrench ?container1 - container)
    (have_jack ?jack1 - jack)
    (jack_in_use ?jack1 - jack ?hub1 - hub)
    (jack_in ?jack1 - jack ?container1 - container)
  )
  (:action open_container
       :parameters ( ?C - container)
       :precondition 
            (closed ?C)
       :effect (and 
            (not (closed ?C))
            (open ?C)
        )
    )
  (:action close_container
       :parameters ( ?C - container)
       :precondition 
            (open ?C)
       :effect (and 
            (not (open ?C))
            (closed ?C)
        )
    )
  (:action fetch_jack
       :parameters ( ?C - container ?J - jack)
       :precondition (and 
            (open ?C)
            (jack_in ?J ?C)
       )
       :effect (and 
            (not (jack_in ?J ?C))
            (have_jack ?J)
        )
    )
  (:action fetch_wheel
       :parameters ( ?C - container ?W - wheel)
       :precondition (and 
            (open ?C)
            (wheel_in ?W ?C)
       )
       :effect (and 
            (not (wheel_in ?W ?C))
            (have_wheel ?W)
        )
    )
  (:action fetch_wrench
       :parameters ( ?C - container ?W - wrench)
       :precondition (and 
            (open ?C)
            (wrench_in ?W ?C)
       )
       :effect (and 
            (not (wrench_in ?W ?C))
            (have_wrench ?W)
        )
    )
  (:action fetch_pump
       :parameters ( ?C - container ?P - pump)
       :precondition (and 
            (open ?C)
            (pump_in ?P ?C)
       )
       :effect (and 
            (not (pump_in ?P ?C))
            (have_pump ?P)
        )
    )
  (:action putaway_wheel
       :parameters ( ?C - container ?W - wheel)
       :precondition (and 
            (open ?C)
            (have_wheel ?W)
       )
       :effect (and 
            (not (have_wheel ?W))
            (wheel_in ?W ?C)
        )
    )
  (:action putaway_wrench
       :parameters ( ?C - container ?W - wrench)
       :precondition (and 
            (open ?C)
            (have_wrench ?W)
       )
       :effect (and 
            (not (have_wrench ?W))
            (wrench_in ?W ?C)
        )
    )
  (:action putaway_jack
       :parameters ( ?C - container ?J - jack)
       :precondition (and 
            (open ?C)
            (have_jack ?J)
       )
       :effect (and 
            (not (have_jack ?J))
            (jack_in ?J ?C)
        )
    )
  (:action putaway_pump
       :parameters ( ?C - container ?P - pump)
       :precondition (and 
            (open ?C)
            (have_pump ?P)
       )
       :effect (and 
            (not (have_pump ?P))
            (pump_in ?P ?C)
        )
    )
  (:action loosen
       :parameters ( ?W - wrench ?H - hub ?N - nuts)
       :precondition (and 
            (have_wrench ?W)
            (on_ground ?H)
            (fastened ?H)
            (tight ?N ?H)
       )
       :effect (and 
            (not (tight ?N ?H))
            (loose ?N ?H)
        )
    )
  (:action tighten
       :parameters ( ?W - wrench ?H - hub ?N - nuts)
       :precondition (and 
            (have_wrench ?W)
            (on_ground ?H)
            (fastened ?H)
            (loose ?N ?H)
       )
       :effect (and 
            (not (loose ?N ?H))
            (tight ?N ?H)
        )
    )
  (:action jack_up
       :parameters ( ?H - hub ?J - jack)
       :precondition (and 
            (on_ground ?H)
            (fastened ?H)
            (have_jack ?J)
       )
       :effect (and 
            (not (on_ground ?H))
            (not (have_jack ?J))
            (jacked_up ?H ?J)
            (jack_in_use ?J ?H)
        )
    )
  (:action jack_down
       :parameters ( ?H - hub ?J - jack)
       :precondition (and 
            (jacked_up ?H ?J)
            (fastened ?H)
            (jack_in_use ?J ?H)
       )
       :effect (and 
            (not (jacked_up ?H ?J))
            (not (jack_in_use ?J ?H))
            (on_ground ?H)
            (have_jack ?J)
        )
    )
  (:action do_up
       :parameters ( ?W - wrench ?H - hub ?J - jack ?N - nuts)
       :precondition (and 
            (have_wrench ?W)
            (unfastened ?H)
            (jacked_up ?H ?J)
            (have_nuts ?N)
       )
       :effect (and 
            (not (unfastened ?H))
            (not (have_nuts ?N))
            (fastened ?H)
            (loose ?N ?H)
        )
    )
  (:action remove_wheel
       :parameters ( ?W - wheel ?H - hub ?J - jack)
       :precondition (and 
            (wheel_on ?W ?H)
            (unfastened ?H)
            (jacked_up ?H ?J)
       )
       :effect (and 
            (not (wheel_on ?W ?H))
            (have_wheel ?W)
            (free ?H)
        )
    )
  (:action put_on_wheel
       :parameters ( ?W - wheel ?H - hub ?J - jack)
       :precondition (and 
            (have_wheel ?W)
            (free ?H)
            (jacked_up ?H ?J)
            (unfastened ?H)
       )
       :effect (and 
            (not (have_wheel ?W))
            (not (free ?H))
            (wheel_on ?W ?H)
        )
    )
  (:action undo
       :parameters ( ?W - wrench ?H - hub ?J - jack ?N - nuts)
       :precondition (and 
            (have_wrench ?W)
            (jacked_up ?H ?J)
            (fastened ?H)
            (loose ?N ?H)
       )
       :effect (and 
            (not (fastened ?H))
            (not (loose ?N ?H))
            (unfastened ?H)
            (have_nuts ?N)
        )
    )
  )
)
