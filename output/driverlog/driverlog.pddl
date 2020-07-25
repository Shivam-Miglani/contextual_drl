(define  (domain driverlog)
  (:requirements :typing)
  (:types Driver Truck Package Location)
  (:predicates
    (Driver_fsm0_state0 ?v0 - Package ?v3 - Location)
    (Driver_fsm0_state1)
    (Truck_fsm0_state0 ?v0 - Package)
    (Truck_fsm0_state1)
    (Package_fsm0_state0)
    (Package_fsm0_state1 ?v0 - Driver ?v1 - Location)
    (Package_fsm1_state0 ?v1 - Location)
    (Package_fsm1_state1 ?v0 - Location)
    (Package_fsm2_state0 ?v0 - Location)
    (Package_fsm2_state1 ?v1 - Location)
    (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
    (Location_fsm0_state0 ?v0 - Package)
    (Location_fsm0_state1)
    (Location_fsm0_state2)
    (Location_fsm0_state3 ?v1 - Package)
    (Location_fsm1_state0)
    (Location_fsm1_state1 ?v0 - Driver)
    (Location_fsm1_state2)
    (Location_fsm1_state3)
    (Location_fsm1_state4)
    (Location_fsm2_state0 ?v2 - Package)
    (Location_fsm2_state1)
    (Location_fsm2_state2 ?v0 - Package)
    (Location_fsm3_state0 ?v1 - Package)
    (Location_fsm3_state1)
    (Location_fsm3_state2 ?v0 - Package)
    (Location_fsm4_state0)
    (Location_fsm4_state1)
    (Location_fsm4_state2 ?v1 - Driver)
    (Location_fsm5_state0 ?v0 - Driver)
    (Location_fsm5_state1)
    (Location_fsm5_state2)
    (Location_fsm5_state3 ?v1 - Package)
    (Location_fsm6_state0)
    (Location_fsm6_state1)
    (Location_fsm6_state2)
    (Location_fsm6_state3)
    (Location_fsm6_state4)
    (Location_fsm7_state0)
    (Location_fsm7_state1 ?v1 - Package)
    (Location_fsm7_state2 ?v0 - Package)
    (Location_fsm8_state0)
    (Location_fsm8_state1)
    (Location_fsm8_state2 ?v1 - Package)
    (Location_fsm8_state3 ?v0 - Package)
    (Location_fsm9_state0 ?v0 - Package)
    (Location_fsm9_state1)
    (Location_fsm9_state2)
    (Location_fsm9_state3)
    (Location_fsm10_state0)
    (Location_fsm10_state1 ?v0 - Package)
    (Location_fsm10_state2 ?v1 - Package)
    (Location_fsm11_state0)
  )
  (:action  disembarktruck   :parameters  (?driver1 - Driver ?truck1 - Package ?s1 - Location )
   :precondition   (and
        (Driver_fsm0_state0 ?v0 - Package ?v3 - Location)
        (Package_fsm0_state1 ?v0 - Driver ?v1 - Location)
        (Package_fsm1_state1 ?v0 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm0_state0 ?v0 - Package)
        (Location_fsm1_state3)
        (Location_fsm3_state0 ?v1 - Package)
        (Location_fsm10_state1 ?v0 - Package)
        (Location_fsm11_state0)
   )
   :effect   (and
        (Driver_fsm0_state1)
        (Package_fsm0_state0)
        (Package_fsm1_state0 ?v1 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm0_state3 ?v1 - Package)
        (Location_fsm1_state4)
        (Location_fsm3_state2 ?v0 - Package)
        (Location_fsm10_state2 ?v1 - Package)
        (Location_fsm11_state0)
  ))

  (:action  boardtruck   :parameters  (?driver1 - Driver ?truck1 - Package ?s0 - Location )
   :precondition   (and
        (Driver_fsm0_state1)
        (Package_fsm0_state0)
        (Package_fsm2_state0 ?v0 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm2_state0 ?v2 - Package)
        (Location_fsm6_state2)
        (Location_fsm7_state2 ?v0 - Package)
        (Location_fsm8_state3 ?v0 - Package)
        (Location_fsm11_state0)
   )
   :effect   (and
        (Driver_fsm0_state0 ?v0 - Package ?v3 - Location)
        (Package_fsm0_state1 ?v0 - Driver ?v1 - Location)
        (Package_fsm2_state1 ?v1 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm2_state2 ?v0 - Package)
        (Location_fsm6_state3)
        (Location_fsm7_state1 ?v1 - Package)
        (Location_fsm8_state2 ?v1 - Package)
        (Location_fsm11_state0)
  ))

  (:action  loadtruck   :parameters  (?package5 - Truck ?truck3 - Package ?s3 - Location )
   :precondition   (and
        (Truck_fsm0_state1)
        (Package_fsm2_state1 ?v1 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm2_state2 ?v0 - Package)
        (Location_fsm3_state2 ?v0 - Package)
        (Location_fsm9_state0 ?v0 - Package)
        (Location_fsm10_state2 ?v1 - Package)
        (Location_fsm11_state0)
   )
   :effect   (and
        (Truck_fsm0_state0 ?v0 - Package)
        (Package_fsm2_state0 ?v0 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm2_state0 ?v2 - Package)
        (Location_fsm3_state0 ?v1 - Package)
        (Location_fsm9_state1)
        (Location_fsm10_state1 ?v0 - Package)
        (Location_fsm11_state0)
  ))

  (:action  unloadtruck   :parameters  (?package5 - Truck ?truck3 - Package ?s3 - Location )
   :precondition   (and
        (Truck_fsm0_state0 ?v0 - Package)
        (Package_fsm1_state0 ?v1 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm0_state3 ?v1 - Package)
        (Location_fsm5_state2)
        (Location_fsm7_state1 ?v1 - Package)
        (Location_fsm8_state2 ?v1 - Package)
        (Location_fsm11_state0)
   )
   :effect   (and
        (Truck_fsm0_state1)
        (Package_fsm1_state1 ?v0 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm0_state0 ?v0 - Package)
        (Location_fsm5_state3 ?v1 - Package)
        (Location_fsm7_state2 ?v0 - Package)
        (Location_fsm8_state3 ?v0 - Package)
        (Location_fsm11_state0)
  ))

  (:action  drivetruck   :parameters  (?truck1 - Package ?s0 - Location ?s1 - Location ?driver1 - Driver )
   :precondition   (and
        (Package_fsm0_state1 ?v0 - Driver ?v1 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm1_state0)
        (Location_fsm2_state1)
        (Location_fsm3_state0 ?v1 - Package)
        (Location_fsm4_state0)
        (Location_fsm5_state3 ?v1 - Package)
        (Location_fsm6_state1)
        (Location_fsm7_state0)
        (Location_fsm9_state3)
        (Location_fsm11_state0)
        (Driver_fsm0_state0 ?v0 - Package ?v3 - Location)
        (Driver_fsm0_state1)
   )
   :effect   (and
        (Package_fsm0_state1 ?v0 - Driver ?v1 - Location)
        (Package_fsm3_state0 ?v0 - Location ?v1 - Truck ?v3 - Driver)
        (Location_fsm1_state1 ?v0 - Driver)
        (Location_fsm2_state2 ?v0 - Package)
        (Location_fsm3_state1)
        (Location_fsm4_state1)
        (Location_fsm5_state0 ?v0 - Driver)
        (Location_fsm6_state4)
        (Location_fsm7_state1 ?v1 - Package)
        (Location_fsm9_state0 ?v0 - Package)
        (Location_fsm11_state0)
        (Driver_fsm0_state0 ?v0 - Package ?v3 - Location)
        (Driver_fsm0_state1)
  ))

  (:action  walk   :parameters  (?driver1 - Driver ?s2 - Location ?p1-2 - Location )
   :precondition   (and
        (Driver_fsm0_state1)
        (Location_fsm0_state1)
        (Location_fsm1_state1 ?v0 - Driver)
        (Location_fsm4_state1)
        (Location_fsm4_state2 ?v1 - Driver)
        (Location_fsm5_state0 ?v0 - Driver)
        (Location_fsm6_state0)
        (Location_fsm8_state0)
        (Location_fsm9_state2)
        (Location_fsm10_state2 ?v1 - Package)
        (Location_fsm11_state0)
   )
   :effect   (and
        (Driver_fsm0_state1)
        (Location_fsm0_state2)
        (Location_fsm1_state2)
        (Location_fsm4_state2 ?v1 - Driver)
        (Location_fsm4_state1)
        (Location_fsm5_state1)
        (Location_fsm6_state1)
        (Location_fsm8_state1)
        (Location_fsm9_state3)
        (Location_fsm10_state0)
        (Location_fsm11_state0)
  ))

)