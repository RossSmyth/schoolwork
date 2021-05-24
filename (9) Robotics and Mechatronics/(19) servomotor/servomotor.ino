// Smyth Week 9 Lab
// Servo Motor

// Constants
#define PWM_OFFSET 250.0f // Offset in microseconds to 90 degrees
#define PWM_SCALE  12.5f   // Scale from degrees to microseconds
#define PWM_PERIOD 20000ul // 50 Hz period in microseconds

#define PAN_OUT 3  // Servo motor output pin.
#define TILT_OUT 4 // Servo motor output pin.

// Variables
unsigned long panPeriod;  // Period of the square wave output in microseconds
unsigned long tiltPeriod;

unsigned long periodTimer; // USed to time the overall PWM period

unsigned long timers[2]; // Each of the timers
int           motors[2]; // The motor pins

void setup() {
  // init serial connection to computer
  Serial.begin(9600);
  while(!Serial);
  
  // Set timeout to 10 seonds to allow for user input
  Serial.setTimeout(10000l);
  
  // Configure pin for output
  pinMode(PAN_OUT, OUTPUT);
  pinMode(TILT_OUT, OUTPUT);
  
  Serial.println("Please send data formatted like 'PAN TILT' in degrees");
    
  // Calculates the wave period from the input
  panPeriod  = degToTime( Serial.parseInt() );
  tiltPeriod = degToTime( Serial.parseInt() );

  // Sort the array of timers and motor outputs
  if (panPeriod <= tiltPeriod) {
    timers[0] = panPeriod;
    motors[0] = PAN_OUT;

    timers[1] = tiltPeriod;  
    motors[1] = TILT_OUT;
  } else {
    timers[0] = tiltPeriod;
    motors[0] = TILT_OUT;

    timers[1] = panPeriod;  
    motors[1] = PAN_OUT;
  }
}

void loop() {
  periodTimer = micros(); // Start timing this loop
  
  digitalWrite(PAN_OUT, HIGH); // Write pins high
  digitalWrite(TILT_OUT, HIGH);

  while( micros() < periodTimer + timers[0] ); // Wait for time to put signal low

  digitalWrite(motors[0], LOW); // Write pin high

  while( micros() < periodTimer + timers[1] ); // Wait for time to put signal low

  digitalWrite(motors[1], LOW); // Write pin high

  while( micros() < periodTimer + PWM_PERIOD ); // Wait for period to end
}

// Calculates the high period of the PWM signal for a given degree input.
unsigned long degToTime( int angle ) {
  if ( angle < -30 ) {
    // Return the minimum period if input is less than zero.
    return (unsigned long)(PWM_OFFSET - PWM_SCALE*30.0f);
  } else if ( angle > 30 ) {
    // Return the maximum period if input is greater than the max
    return (unsigned long)(PWM_OFFSET + PWM_SCALE*30.0f);
  } else {
    // If in the valid range, transform it properly. Do the calculations as FP.
    return (unsigned long)( ( (float)angle + 90.0f ) * PWM_SCALE + PWM_OFFSET );
  }
  
}
