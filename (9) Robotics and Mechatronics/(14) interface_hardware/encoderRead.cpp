#include "Arduino.h"

// Constants
#define EncoderChannel1 2 // pin channel 1 is on
#define EncoderChannel2 3 // pin channel 2 is on
const float anglePerPulse = 0.3515625; // angle pulse per revolution

// Variables
float total_angle = 0; // current shaft angle in degrees
int   count; // Counts since last reading of the encoder

// Functions

// prototypes for the functions
void setup_encoder();
float read_encoder();
void Chan1Rise();

// Sets up the encoder with interrupts and I/O
void setup_encoder() {
  // Set the encoder pin modes
  pinMode(EncoderChannel1, INPUT);
  pinMode(EncoderChannel2, INPUT);
  
  // Attach interrupt. Only look at rising edges of one channel for direction detection
  attachInterrupt(digitalPinToInterrupt(EncoderChannel1), Chan1Rise, RISING);
}

void reset_encoder() {
  noInterrupts();
  
  total_angle = 0;

  interrupts();
}

// Calculates the angle since the last reading
float read_encoder() {
  // Turn interrupts off to be safe.
  noInterrupts();
  
  // Increment angle based upon encoder counts
  total_angle  = total_angle + count * anglePerPulse;

  // Reset counts
  count = 0;
  
  // Turn interrupts back on
  interrupts();
  
  return total_angle;
}

// Check the direction and increments count
// Only increments or decrements counts cause floating point math
// inside of an interrtupt is a bit sketchy.
void Chan1Rise() {
  // check state of other channel
  switch (digitalRead(EncoderChannel2)) {
    case 1 : count++; break; // If high, increment
    case 0 : count--; break; // If low, decrement
  }
}
