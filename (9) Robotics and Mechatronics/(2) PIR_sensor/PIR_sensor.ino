/// Lab 2 PIR Sensor
/// Turn on LED when something is in range of sensors
/// Author: Ross Smyth

// Constants
#define LED 5 // LED pin
#define PIR 7 // PIR sensor pin

// Variables
unsigned int presses;
bool         IRState = false; // Real PIR state
bool         DState; // Digital I/O state

// Functions
void setup() {
  // Set pinmodes
  pinMode(LED, OUTPUT);
  pinMode(PIR, INPUT_PULLUP);
  
  // Setup serial port over USB.
  Serial.begin(9600);
  while (!Serial) {;}
}


void loop() {
  // Let's count the lowering edges
  DState = digitalRead(PIR);

  // Look for rising edge
  if (!IRState and DState) 
  {
    // Actually changes the state
    IRState = true;

    //output to serial and turn on LED
    Serial.println(true);
    digitalWrite(LED, HIGH);
    
  } else if (IRState and !DState) {
    // Falling edge detection
    IRState = false;

    // Write to serial and turn off LED
    Serial.println(false);
    digitalWrite(LED, LOW);
  }
}
