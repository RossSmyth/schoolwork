/// Week 8 Model-Based Control
/// Model Based Controller
/// Author: Ross Smyth

#include "lqrControl.h"

// I may make a Kalman filter library before I do the lab. Or not.

// This sets a function to the AVR arch's reset vector.
// Essentially a software reset of the board.
void(* resetFunc) (void) = 0;

void setup() {
  // init serial connection to computer
  Serial.begin(250000);
  while(!Serial);

  // Init encoder and struct
  motorEncoder = setupEncoder(encoderChan1, encoderChan2, encoderAPP);

  // init motor and motor struct
  motor = setupMotor( motorChan1, motorChan2, motorConvert );
  
  // Checks if null pointers were returned, then handles them by resetting the board.
  if ((motor == NULL) || (motorEncoder == NULL) ){
    // Give some time to possibly flash new firmware
    delay(2000);
    resetFunc();
  }

  // Just for peace of mind.
  Serial.println("No null pointers found");

  // Ensure motor is zeroed
  writeMotor( 0.0f, motor );
  
  // Initial conditions for the velocity. Just read the encoder once.
  readEncoder( motorEncoder );
  prevVelocity = motorEncoder->velocity;

  delay(timeStep);
}

// control loop. Controls to 180 degrees and 0 degree/second
void loop() {
  // Being timing the control loop
  timer = millis();

  // Read encoder
  readEncoder( motorEncoder );

  // update state column vector
  state[0][0] = motorEncoder->angle;
  state[1][0] = motorEncoder->velocity;

  // Set the previous svelcoity for the next loop
  prevVelocity = motorEncoder->velocity;

  // Get the motor effort
  motorVolt = calcEffort( referenceState, state, contK);

  // Write motor output
  writeMotor( motorVolt, motor );


  // Write the state to Serial
  Serial.print(state[0][0], DEC);
  Serial.print("\t");
  Serial.println(state[1][0], DEC);

  // Spin until the control step is over
  while ((millis() - timer) < timeStep);
}
