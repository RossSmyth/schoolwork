// Smyth Week 9 Lab
// Stepper Motor

// Includes
#include <Stepper.h>

// Constants

// Motor pins
#define STEPPER_1 2
#define STEPPER_2 3
#define STEPPER_3 4
#define STEPPER_4 5

#define STEPS_PER_ROTATION 2048

// Variables
Stepper stepperMotor = Stepper(STEPS_PER_ROTATION, STEPPER_1, STEPPER_2, STEPPER_3, STEPPER_4);

// Functions
void setup() {
  stepperMotor.setSpeed(20);
  // Rotate it one rotatoin
  stepperMotor.step(STEPS_PER_ROTATION);
}

// Nothing to loop
void loop() {}
