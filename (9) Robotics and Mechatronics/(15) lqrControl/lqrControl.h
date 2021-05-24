// Main program header
// Library includes
#include "encoderRead.h"
#include "motorControl.h"
#include "ssControl.h"

/*
 * * * * * * * * * * * * * * * * * * * * * * * Constants
 */ 

// Encoder channels and angle per pulse.
#define encoderChan1 2
#define encoderChan2 3
#define encoderAPP   0.3515625f

// Motor channels
#define motorChan1 5
#define motorChan2 6

// From voltage to the 8-bit PWM output 255/6. This may not be correct but I'm not sure.
// I'll measure in lab.
#define motorConvert 42.5f

// Time step, 50 Hz
#define timeStep 20 // ms

// Filter constant for first-order low-pass filter
// This would need more analyzing of the sensor's output so this is a guess
#define filterConst 0.8f


// K vector that calculates the control effort from the state
// This will be calculated in MATLAB. const as it won't change
// floating-point is slow on the AVR arch since there isn't an FPU
// So I hope this can run fast enough. I'll test it later.
const float contK[2] = {3.9872f, 0.3357f};

const float referenceState[2][1] = { {180.0f}, 
                                     {  0.0f} };

/*
 * * * * * * * * * * * * * * * * * * * * * * * Variables
 */ 

// Init structs for libraries
struct ENCODER* motorEncoder;
struct MOTOR*   motor;

// State vector init to zero
float state[2][1] = { {0.0f}, 
                      {0.0f} };

// init a variable for storing the previous velocity for filtering
float prevVelocity;

// init the motor effort variable
float motorVolt;

unsigned long timer;
