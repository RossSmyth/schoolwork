#include "Arduino.h"
#include "pidController.h"

// Constants

// Variables
PID* pidParams;

float integral;
float prevErr;
float effort;

// Functions

// Assigns the struct pointer to the user's PID struct
// This means it can be edited in user-land and propogate to the library
void pid_setup(PID* userPIDParams) {
  pidParams = userPIDParams;
}

void reset_controller() {
  integral = 0;
  prevErr  = 0;
  effort   = 0;
}

// This function takes in the error and outputs a controller effort
float pid_run( float error ) {

  // Accumulate more error. Convert to seconds.
  integral += (pidParams->dt * 0.001) * error;

  // Calculate the effort to output [Kp*e + Ki*integral(e) + Kd*diff(e)]
  effort = pidParams->Kp * error + 
           pidParams->Ki * integral + 
           pidParams->Kd * (error - prevErr) / (pidParams->dt * 0.001);

  // Set the previous error
  prevErr = error;

  // return
  return effort;
}
