/// Week 6 Quadrature Encoder
/// Quadrature Encoder as speed sensor
/// Author: Ross Smyth

// Constants
#define EncoderChannelIn 2 // pin the encoder channel goes in
const float anglePerPulse = 0.17578125; // angle per pulse in degrees. 360/2048 = degrees/2*N as this is measuringe every edge.

// Variables
volatile bool edgeDetect; // Detects an edge in the encoder signal
unsigned long pulseTime; // Time between pulses
float shaftSpeed = 0; // Speed of shaft in degrees/s

// Functions
void setup() {
  // Set pinmode to input for encoder channel 1
  pinMode(EncoderChannelIn, INPUT);
  
  // Instance Serial object
  Serial.begin(9600);
  
  // Wait for serial connection to initialize
  while(!Serial) {;}

  // Attach interrupt routines for changing edges from encoder
  attachInterrupt(digitalPinToInterrupt(EncoderChannelIn), encoderEdge, CHANGE);
}

void loop() {
   // Get current execution time
   pulseTime = millis();

   // Spin until an edge is detected.
   while (!edgeDetect) {;}

   // Find time difference from last edge
   pulseTime = millis() - pulseTime;
   
  // Calculate the speed of the shaft. Converts from milliseconds to seconds.
  shaftSpeed = anglePerPulse / (pulseTime * 0.001);

  // Print speed to serial
  Serial.println(shaftSpeed, DEC);

  // Reset detection flag for next iteration
  edgeDetect = false;
}

void encoderEdge() {
  edgeDetect = true;
}
