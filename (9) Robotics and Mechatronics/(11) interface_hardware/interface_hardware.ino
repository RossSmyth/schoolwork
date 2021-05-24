/// Week 7 PID Control
/// Interface Hardware
/// Author: Ross Smyth

#include "encoderRead.h"
#include "motorControl.h"
#include "joystickRead.h"

// Init joystick variables
// I am rewriting all my libraries for next week as these were a pain to deal with
float pitch  = 0.0f;
float roll   = 0.0f;
bool  button = false;

// Init encoder variable
float encoder=0.0f;

void setup() {  
  // init serial connection to computer
  Serial.begin(9600);
  while(!Serial);

  // Run setup functions
  setup_encoder();
  joystick_setup();
  motor_setup();

  // Run the hardware verification function
  verification();
}

// not looping anything
void loop() {}

// Checks functionality
void verification() {

  // Test button input
  Serial.println("\nPress joystick button.");
  while(!button){
    joystick_read(&pitch, &roll, &button);
  }
  Serial.println("Button Pressed");

  // Test all joystick axes
  Serial.print("\nMove joystick pitch axis positive");
  while(pitch < 0.5f){ // move it halfway
    joystick_read(&pitch, &roll, &button);
  }
  Serial.println("\nJoystick pitch axis moved positive");

  Serial.print("\nMove joystick pitch axis negative");
  while(pitch > -0.5f){
    joystick_read(&pitch, &roll, &button);
  }
  Serial.println("\nJoystick pitch axis moved negative");

  Serial.print("\nMove joystick roll axis positive");
  while(roll < 0.5f){
    joystick_read(&pitch, &roll, &button);
  }
  Serial.println("\nJoystick roll axis moved positive");

  Serial.print("\nMove joystick roll axis negative");
  while(roll > -0.5f){
    joystick_read(&pitch, &roll, &button);
  }
  Serial.println("\nJoystick roll axis moved negative");

  // Have user rotate the motor shaft to test encoder
  Serial.print("\nMove motor 90 degrees positive");
  while(encoder < 90.0f){
    encoder = read_encoder();
    Serial.println(encoder,DEC);
  }
  Serial.println("\nMotor moved 90 degrees positive");

  // Test moving the motor automatically
  // Just uses a simple on/off controller, almost a bang-bang controller
  // As accuracy isn't needed, just making sure it moves.
  Serial.print("\nMoving motor 90 degrees, please move hands");
  delay(2000);
  
  reset_encoder(); // Reset encoder for the move
  encoder=0;
  
  motor_write(100.0f);
  while(encoder < 90.0f){
    encoder = read_encoder();
  }
  motor_write(0.0f); // Turn off motor
  Serial.println("\nMotor moved 90 degrees");
}
