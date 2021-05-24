// Smyth Week 11 Lab
// Servo Motor

// Constants
#define PWM_OFFSET 250.0f // Offset in microseconds to 90 degrees
#define PWM_SCALE  12.5f   // Scale from degrees to microseconds
#define PWM_PERIOD 20000ul // 50 Hz period in microseconds

#define SERVO_OUT 3  // Servo motor output pin.

// Variables
unsigned long loopPeriod;  // Period of the square wave output in microseconds

unsigned long periodTimer; // USed to time the overall PWM period

void setup() {
  // init serial connection to computer
  Serial.begin(9600);
  while(!Serial);
  
  // Set timeout to 10 seonds to allow for user input
  Serial.setTimeout(10000l);
  
  // Configure pin for output
  pinMode(SERVO_OUT, OUTPUT);
  
  Serial.println("Please the angle in degrees");
    
  // Calculates the wave period from the input
  loopPeriod  = degToTime( Serial.parseInt() );
}

void loop() {
  periodTimer = micros(); // Start timing this loop
  
  digitalWrite(SERVO_OUT, HIGH); // Write pins high

  while( micros() < periodTimer + loopPeriod ); // Wait for time to put signal low

  digitalWrite(SERVO_OUT, LOW); // Write pin high

  while( micros() < periodTimer + PWM_PERIOD ); // Wait for period to end
}

// Calculates the high period of the PWM signal for a given degree input.
unsigned long degToTime( int angle ) {
  if ( angle < 0 ) {
    // Return the minimum period if input is less than zero.
    return (unsigned long)(PWM_OFFSET);
  } else if ( angle > 180 ) {
    // Return the maximum period if input is greater than the max
    return (unsigned long)(PWM_OFFSET + PWM_SCALE*180.0f);
  } else {
    // If in the valid range, transform it properly. Do the calculations as FP.
    return (unsigned long)( (float)angle * PWM_SCALE + PWM_OFFSET );
  } 
}
