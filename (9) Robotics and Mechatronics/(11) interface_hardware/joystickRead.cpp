#include "joystickRead.h"

// Constants
const int pitchIn = A0; // pitch axis in
const int rollIn  = A1; // pitch axis in
#define buttonIn 7 // push-button in

#define analogResolution 1024 // Resolution of the board's ADC
#define joystickRange    128.0f // Range from the center of the ADC range the joystick sweeps

// Variables
int  rollRaw  = 0; // stores raw roll value
int  pitchRaw = 0; // stores raw pitch value

// Functions

// Initilizes the pin for the joystick button
void joystick_setup() {
  pinMode(buttonIn, INPUT_PULLUP);
}

// Takes pointers to values and sets them to the current state of the joystick.
// Button is a bool of on or off
// The rest are floats that are -1 to 1
void joystick_read(float* pitch, float* roll, bool* button) {
  // Set button to the value of the button.
  *button = !digitalRead(buttonIn);

  // Get the raw integer analog values.
  rollRaw = analogRead(rollIn);
  pitchRaw = analogRead(pitchIn);
  
  // Recenter them so that negative values map to the negative axes
  rollRaw  -= analogResolution >> 1;
  pitchRaw -= analogResolution >> 1;

  // Map to [-1, 1]ish float
  *pitch = pitchRaw / joystickRange;
  *roll  = rollRaw  / joystickRange;
}
