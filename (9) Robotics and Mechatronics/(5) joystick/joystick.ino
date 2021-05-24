/// Lab 3 DC Motor
/// Joystick HID
/// Author: Ross Smyth

// Constants
#define buttonIn 2 // push-button in
const int pitchIn = A0; // pitch axis in
const int rollIn  = A1; // roll axis in

// Variables
int pitch = 0 ; // stores pitch value
int roll  = 0; // stores roll value
volatile bool buttonState = 0; // stores button state, must be volatile for interrupts.

void setup() {
  // sets digital pin for reading the button
  // Not sure if button has pull-down resistor. We'll see in lab.
  pinMode(buttonIn, INPUT);
  
  // Instance Serial object
  Serial.begin(9600);
  
  // Wait for serial connection to initialize
  while(!Serial) {;}

  // Attach interrupt routines for rising and falling edges. See buttonHigh() and buttonLow()
  attachInterrupt(digitalPinToInterrupt(buttonIn), buttonHigh, RISING);
  attachInterrupt(digitalPinToInterrupt(buttonIn), buttonLow, FALLING);
}

void loop() {
  // Sets analog variables to their readings
  pitch = analogRead(pitchIn);
  roll  = analogRead(rollIn);

  // Prints  row of tab serpated values.
  // Format: "<pitch value>  <roll value>  <button state>"
  // Example: "100  200 0"
  Serial.print(pitch, DEC); // pitch
  Serial.print("\t");

  Serial.print(roll, DEC); //roll
  Serial.print("\t");
  
  Serial.print(buttonState, DEC); // button
  Serial.print("\n");
}

void buttonHigh() {
  // Set button to the pressed state on rising edge
  buttonState = true;
}

void buttonLow() {
  // Set button to the unpressed state on falling edge
  buttonState = false;
}
