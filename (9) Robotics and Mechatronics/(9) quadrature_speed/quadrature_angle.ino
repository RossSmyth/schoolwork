/// Week 6 Quadrature Encoder
/// Quadrature Encoder as angle displacement sensor
/// Author: Ross Smyth
/// Will use the same API as the library for part C 

// Constants
#define EncoderChannel1 2 // pin channel 1 is on
#define EncoderChannel2 3 // pin channel 2 is on
const float anglePerPulse = 0.3515625; // 360/1024 angle pulse per revolution

// Variables
float angle = 0; // current shaft angle in degrees
int   count = 9; // Counts since last reading of the encoder

// Functions
void setup() {
  // Instance Serial object
  Serial.begin(9600);
  
  // Wait for serial connection to initialize
  while(!Serial) {;}

  setup_encoder();
}

void loop() {
  angle = read_encoder();
  Serial.println(angle, DEC);
}

// Sets up the encoder with interrupts and I/O
void setup_encoder() {
  // Set the encoder pin modes
  pinMode(EncoderChannel1, INPUT);
  pinMode(EncoderChannel2, INPUT);
  
  // Attach interrupt. Only look at rising edges of one channel for direction detection
  attachInterrupt(digitalPinToInterrupt(EncoderChannel1), Chan1Rise, RISING);
}

// Calculates the angle since the last 
float read_encoder() {
  // Turn interrupts off to be safe.
  noInterrupts();
  
  // Increment angle based upon encoder counts
  angle  = angle + count * anglePerPulse;

  // Reset counts
  count = 0;
  
  // Turn interrupts back on
  interrupts();
  
  return angle;
}

// Check the direction and increments count
// Only increments or decrements counts cause floating point math
// inside of an interrtupt is a bit sketchy.
void Chan1Rise() {
  // check state of other channel
  switch (digitalRead(EncoderChannel2)) {
    case 1 : count++; break; // If high, increment
    case 0 : count--; break; // If low, decrement
  }
}
