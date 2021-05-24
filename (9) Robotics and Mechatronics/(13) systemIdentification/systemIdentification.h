// Main program header

#ifndef HEADER_SYSTEMIDENTIFICATION
#define HEADER_SYSTEMIDENTIFICATION

#include "Arduino.h"
#include "motorControl.h"
#include "encoderRead.h"
// Header for the main program code.

/*
* * * * * * * * * * * * * * * * ** * * * * * Defintions
* 
* None this time
*/ 

/*
* * * * * * * * * * * * * * * * ** * * * * * Constants
*/ 

// Motor I/O
#define motorChan1 5
#define motorChan2 6
#define motorVtoPWM 41.5f // 6V to 255 PWM

// Encoder I/O
#define encoderChan1 2
#define encoderChan2 3
#define encoderAPP   0.3515625f // Encoder angle per pulse.

// Step time
#define stepTime 1000 // milliseconds

// Step voltage 
#define stepVolt 1.0f

// Sampling rate
#define samplePeriod 20 // milliseconds

/*
* * * * * * * * * * * * * * * * ** * * * * * Variables
*/ 

// Init motor and encoder structs
struct MOTOR*   motor;
struct ENCODER* encoder;

// So many timers.
unsigned long timer = 0;         // This timer is the each "sub-maneuver"
unsigned long maneuverTime = 0;  // This timer is the total maneuver timer that is output over serial.
unsigned long loopTime;          // This times each loop to ensure that the specified sample rate is reached.

// I wrote a module for setting up timer interrupts so that may make an apperance next time.

#endif
