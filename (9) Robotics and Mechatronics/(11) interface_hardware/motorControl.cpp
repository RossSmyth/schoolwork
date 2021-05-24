#include "motorControl.h"

// Constants
#define motorIN1 5 // Driver IN1 pin
#define motorIN2 6 // Driver IN2 pin
#define userConvert 2.55 // Convert from user input to bits

// Variables
int motorSpeed = 0; // speed from 0 to 255
bool motorDir = false; // direction forwards or reverse

void motor_setup() {
  // Initilize pins for motor PWM control
  pinMode(motorIN1, OUTPUT);
  pinMode(motorIN2, OUTPUT);
}

// This function sets motor speed
void motor_write(float effort) {
  // Convert from 0 to 100 to 0 to 255
  effort = effort * userConvert;

  // Cast to int
  motorSpeed = (int)abs(effort);

  // Set to true for forwards when greater than zero
  motorDir = (effort > 0);
  
    if (!motorSpeed) {
    // If speed is zero, both are low
    analogWrite(motorIN1, 0);
    analogWrite(motorIN2, 0);
  } else if (motorDir) {
    // If positive have IN1 be PWM
    analogWrite(motorIN1, motorSpeed);
    // and have IN2 be low
    analogWrite(motorIN2, 0);
  } else {
    // Negative IN1 is low
    analogWrite(motorIN1, 0);
    // and IN2 is PWM
    analogWrite(motorIN2, motorSpeed);
  }
}
