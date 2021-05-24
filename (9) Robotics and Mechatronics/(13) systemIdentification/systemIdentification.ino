#include "systemIdentification.h"

/*
 * This program gives the motor a rectangular voltage signal for system identification.
 */


// This sets a function to the AVR arch's reset vector.
// Essentially a software reset of the board. 
// This is called for null pointers being returned.
void(* resetFunc) (void) = 0;

void setup() {
  // init serial connection to computer. Made serial baud higher to ensure to not be bottlenecked by data rates.
  Serial.begin(250000);
  while(!Serial);

  // Setup motor struct. conversion is from volts to 8-bit PWM value.
  motor = setupMotor( motorChan1, motorChan2, motorVtoPWM );

  // Setup encoder struct
  encoder = setupEncoder( encoderChan1, encoderChan2, encoderAPP );

  // Checks if null pointers were returned, then handles them by resetting the board.
  if ((motor == NULL) || (encoder == NULL) ){
    // Give some time to possibly flash new firmware
    // No need to notify as it will be obvious if this happens.
    delay(2000);
    resetFunc();
  }

  // Ensure motor is off
  writeMotor(0.0f, motor);
  
  // Peace of mind
  Serial.println("No null pointers found");

  // Serial plotter labels
  Serial.println("%Time(us) Velocity Voltage");

  // Print initial values
  Serial.println("0.0 0.0 0.0");

   
  // Set motor to full voltage
  writeMotor(stepVolt, motor);
  
  // Set initial time
  timer = millis();

  // Accurate step time to output.
  maneuverTime = micros();

  // Print angle while timer is running
  while ( millis() <= (timer + stepTime) ) {

    // Start timing loop
    loopTime = millis();
    
    readEncoder( encoder );

    // Print current angle
    Serial.print(micros() - maneuverTime, DEC);
    Serial.print("\t");
    Serial.print(encoder->velocity, DEC);
    Serial.print("\t");
    Serial.println(stepVolt, DEC);

    // spin while period isn't over
    while ( millis() <= (loopTime + samplePeriod) );
  }

  // Second loop for transients when motor is stepped to zero volts
  writeMotor(0.0f, motor);

  // Set initial time
  timer = millis();
  
  // Print angle while timer is running
  while ( millis() <= (timer + stepTime) ) {

    // Start timing loop
    loopTime = millis();
    
    readEncoder( encoder );

    // Print current angle
    Serial.print(micros() - maneuverTime, DEC);
    Serial.print("\t");
    Serial.print(encoder->velocity, DEC);
    Serial.print("\t");
    Serial.println(0.0f, DEC);

    // spin while period isn't over
    while ( millis() <= (loopTime + samplePeriod) );
  }
}

// Nothing to loop
void loop() {}
