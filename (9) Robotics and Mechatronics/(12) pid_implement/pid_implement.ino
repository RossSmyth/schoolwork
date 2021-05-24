/// Week 7 PID Control
/// Implementing and testing a PID controller
/// Author: Ross Smyth

// Libraries
#include "pidController.h"

// Variables
float motorEffort;

// PID struct. See "pidController.h"
PID testController;

void setup() {

  // Arbitrarily set the time step to 10 milliseconds
  testController.dt = 10; 

   // Init the Serial connection
  Serial.begin(9600);
  while (!Serial);

  // Pass pointer to controller struct to the controller library
  pid_setup(&testController);

  
  // Only P
  testController.Kp = 1.0f;

  reset_controller(); // Reset the controller
  motorEffort = pid_run( 2.0f ); // Test error signal of 2.0 sent to PID
  Serial.print("Error of 1 with P=1, effort=");
  Serial.println(motorEffort, DEC); // Effort output

  // Only I
  testController.Kp = 0.0f;
  testController.Ki = 1.0f;

  reset_controller(); // Reset the controller
  motorEffort = pid_run( 2.0f ); // Test error signal of 2.0 sent to PID
  Serial.print("Error of 1 with I=1, effort=");
  Serial.println(motorEffort, DEC); // Effort output

  // Only D
  testController.Ki = 0.0f;
  testController.Kd = 1.0f;

  reset_controller(); // Reset the controller
  motorEffort = pid_run( 2.0f ); // Test error signal of 2.0 sent to PID
  Serial.print("Error of 1 with D=1, effort=");
  Serial.println(motorEffort, DEC); // Effort output
}

// Nothing to loop
void loop(){}
