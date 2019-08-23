
(define (domain rocket)
  (:requirements :strips :equality :typing)

  (:types  rocket location cargo)


  (:predicates
    (at ?cargo1 - cargo ?location1 - location)
    (position ?rocket1 - rocket ?location1 - location)
    (fuel_empty ?rocket1 - rocket)
    (fuel_full ?rocket1 - rocket)
    (in ?cargo1 - cargo ?rocket1 - rocket)
  )
  (:action move
       :parameters ( ?R - rocket ?A - location ?B - location)
       :precondition (and 
            (position ?R ?A)
            (fuel_full ?R)
            (not (= ?A ?B))
       )
       :effect (and 
            (not (position ?R ?A))
            (not (fuel_full ?R))
            (position ?R ?B)
            (fuel_empty ?R)
        )
    )
  (:action load
       :parameters ( ?R - rocket ?A - location ?C - cargo)
       :precondition (and 
            (position ?R ?A)
            (at ?C ?A)
       )
       :effect (and 
            (not (at ?C ?A))
            (in ?C ?R)
        )
    )
  (:action unload
       :parameters ( ?R - rocket ?A - location ?C - cargo)
       :precondition (and 
            (position ?R ?A)
            (in ?C ?R)
       )
       :effect (and 
            (not (in ?C ?R))
            (at ?C ?A)
        )
    )
  )
