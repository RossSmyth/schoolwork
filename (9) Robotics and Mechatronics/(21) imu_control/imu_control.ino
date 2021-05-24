#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>

/*
 * Definitions
 */

// Setup the IMU object
Adafruit_BNO055 sensor = Adafruit_BNO055(1, 0x28);

/*
 * Constants
 */

#define PWM_OFFSET 250.0f // Offset in microseconds to 90 degrees
#define PWM_SCALE  12.5f   // Scale from degrees to microseconds
#define PWM_PERIOD 20000ul // 50 Hz period in microseconds

#define SERVO_OUT 3  // Servo motor output pin.

/* IMU connections according to the example
   Connections
   ===========
   Connect SCL to analog 5
   Connect SDA to analog 4
   Connect VDD to 3.3V DC
   Connect GROUND to common ground
*/

/* 
 *  Variables
 */

// Init the vector for getting data
imu::Vector<3> eulerAngles;

unsigned long signalPeriod = 250;  // Period of the square wave output in microseconds

unsigned long periodTimer; // USed to time the overall PWM period

void setup() {
  // init serial connection to computer
  Serial.begin(9600);
  while(!Serial);

   // Initialise the sensor
  if(!sensor.begin())
  {
    // No sensor 
    Serial.print("No sensor detected");
    while(true);
  }

  // Use the external crystal to increase accuracy
  sensor.setExtCrystalUse(true);

  // Configure pin for output
  pinMode(SERVO_OUT, OUTPUT);

}

void loop() {
  periodTimer = micros(); // Start timing this loop
  
  digitalWrite(SERVO_OUT, HIGH); // Write pins high

  while( micros() < periodTimer + signalPeriod ); // Wait for time to put signal low

  digitalWrite(SERVO_OUT, LOW); // Write pin high

  // While waiting for the loop to end, get the next angle vector.
  eulerAngles = sensor.getVector(sensor.VECTOR_EULER);

  // Set the next signal period
  signalPeriod  = degToTime( eulerAngles.x() );

  while( micros() < periodTimer + PWM_PERIOD ); // Wait for period to end

}

// Calculates the high period of the PWM signal for a given degree input.
unsigned long degToTime( double angle ) {
  if ( angle < 30 ) { // 30 due to note on the arm.
    // Return the minimum period if input is less than zero.
    return (unsigned long)(PWM_OFFSET+PWM_SCALE*30.0f);
  } else if ( angle > 180 ) {
    // Return the maximum period if input is greater than the max
    return (unsigned long)(PWM_OFFSET + PWM_SCALE*180.0f);
  } else {
    // If in the valid range, transform it properly. Do the calculations as FP.
    return (unsigned long)( angle * PWM_SCALE + PWM_OFFSET );
  } 
}
