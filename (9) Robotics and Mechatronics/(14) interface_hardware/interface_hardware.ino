/// Week 8 Interface Hardware
/// Servo Control of DC Motor
/// Author: Ross Smyth

// Libraries
#include "encoderRead.h"
#include "motorControl.h"
#include "pidController.h"
#include "joystickRead.h"

/// Definitions

// Structure for the joystick data
struct joystickState {
  float pitch;
  float roll;
  bool button;
};

/// Constants

// List pins for sanity
// Encoder  on D2, D3
// Motor    on D4, D6
// Joystick on A0, A1, D1

#define smallInput 0.03921 // joystick deadzone, (~5/255)

/// Variables

// The angle to set to. Either -180 or 180.
const float referenceAngle = 180.0f;

// Effort to set the motor to
float motorEffort;

// For tracking each step in time
unsigned long stepTime; // ms

// The current measured angle
float angle = 0;

// PID struct. See "pidController.h"
PID testController;

// Init the struct with zeros
struct joystickState userInput = {0};


/// Functions

void setup() {
  
  // Init the Serial connection
  Serial.begin(9600);
  while (!Serial);

  // Run the setup functions
  setup_encoder();
  motor_setup();
  joystick_setup();

  // Arbitrarily set the time step to 10 milliseconds
  testController.dt = 10; 
  
  pid_setup(&testController); // Pass the controller struct pointer to the library

  // Sets gains from lab 7
  testController.Kp = 1;
  testController.Ki = 2;
  testController.Kd = 0.05;

  // Set the labels for serial plotter
  Serial.println("Motor_Angle Reference");
}

void loop() {
  controlLoop();
}

// The control loop that runs each iteration
void controlLoop() {

    // Begin timing this step
    stepTime = millis();
    
    // Read the encoder angle
    angle = read_encoder();
    
    // Update the PID controller
    motorEffort = pid_run( referenceAngle -  angle);

    // Set motor speed
    motor_write(motorEffort);

    Serial.print(angle, DEC);
    Serial.print(" ");
    Serial.println(referenceAngle, DEC);
    
    // Wait for time step to be finished
    while (stepTime <= testController.dt) {stepTime = millis();};
}
