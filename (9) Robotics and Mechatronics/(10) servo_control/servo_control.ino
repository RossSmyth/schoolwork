/// Week 7 PID Control
/// Servo Control of DC Motor
/// Author: Ross Smyth

// Libraries
#include "encoderRead.h"
#include "motorControl.h"
#include "pidController.h"
#include "joystickRead.h"

/// Definitions
// Should move the definitions and initilizations to a header next time as this is getting long
// I rewrote all my libraries so they are more maintainable and less of a mess so you can look forward to that

// Structure for handling the joystick data
struct joystickState {
  float pitch;
  float roll;
  bool  button;
};

/// Constants

// List pins for sanity
// Encoder  on D2, D3
// Motor    on D4, D6
// Joystick on A0, A1, D1

#define smallInput 0.03921 // joystick deadzone, (~10/255)

/// Variables

// The angle to set to. Either -180 or 180.
float referenceAngle;

// Effort to set the motor to
float motorEffort;

// For tracking each step in time
unsigned long stepTime; // ms

// The current measured angle
float angle = 0.0f;

// PID struct. See "pidController.h"
PID testController;

// Init the struct with zeros
struct joystickState userInput = {0};


/// Functions

void setup() {
  // Arbitrarily set the time step to 10 milliseconds
  testController.dt = 10; 
  
  // Init the Serial connection
  Serial.begin(9600);
  while (!Serial);
  // Set timeout to a reasonable time to wait for user input
  Serial.setTimeout(10000);

  // Wait for input
  setPIDValues(); // Then set initial PID gains

  // Run the setup functions
  setup_encoder();
  motor_setup();
  joystick_setup();
  
  pid_setup(&testController); // Pass the controller struct pointer to the library

  Serial.println("Note that this only reads the pitch axis on A0\n"); //info
}

void loop() {
  // Look for if button is pushed or not
  switch (userInput.button)  {
    case true : setPIDValues(); break; // If so go to setting the PID values
    default   : controlLoop(); break;  // If not keeping on controlling the motor
  }
}

// Sets the PID values and clears the state of the system
// This is to reset for testing another control system.
void setPIDValues() {
  reset_encoder(); // Reset encoder accumulater
  angle = 0.0f; // reset angle
  
  motor_write( 0.0f ); // Set motor to 0
  motorEffort = 0.0f; // Set motor variables to 0
  
  // Print message for gains init
  // Format is "Kp  Ki  Kd" which are tab seperated and floats.
  Serial.println("Please give initial space-seperated PID gains");
  
  while(Serial.available() <= 0);
  // Parse the three floats that should be sent.
  testController.Kp = Serial.parseFloat();
  testController.Ki = Serial.parseFloat();
  testController.Kd = Serial.parseFloat();

  // Reset the button. This may or may not actually be true, but reentering to this function would be silly.
  userInput.button = false;
}

// The control loop that runs each iteration
void controlLoop() {
    // Begin timing this step
    stepTime = millis();
    
    // Read the encoder angle
    angle = read_encoder();

    // Check to see what the reference angle actually is based upon input
    referenceAngle = readInput();
    
    // Update the PID controller
    motorEffort = pid_run( referenceAngle -  angle);

    // Set motor speed
    motor_write(motorEffort);
    
    // Print the angle and the reference for the serial plotter
    Serial.print(angle, DEC);
    Serial.print(" ");
    Serial.print(referenceAngle, DEC);
    
    // Wait for time step to be finished
    while (stepTime <= testController.dt);
    return;
}

// This function looks at the joystick and sets the reference value accordingly
float readInput() {
  // Set the userInput struct with the joystick values
  joystick_read(&userInput.pitch, &userInput.roll, &userInput.button);

  // Check for the conditions
  if (userInput.pitch < smallInput and userInput.pitch > -smallInput) {
    // if within the deadzone return 0
    return 0.0f;
  } else if (userInput.pitch < 0) {
    // If less than zero (already checked if in deadzone) return -180 
    return -180.0f;
  } else {
    // If greater than zero return +180
    return 180.0f;
  }
}
