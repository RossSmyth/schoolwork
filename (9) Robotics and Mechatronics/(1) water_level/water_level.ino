/// Lab 2 Water Level Sensor
/// Attempt to measure water level
/// Author: Ross Smyth

// Constants
const int SENSOR = A3; // Analog pin

// Variables
long waterLevel; // [0, 40] mm water height

void setup() {  
  // Setup serial port over USB.
  Serial.begin(9600);

  // wait for connection to initilize 
  while (!Serial) {;}
}

void loop() {
  // Read analog voltage and map to water level scale
  waterLevel = map(analogRead(A3), 0, 1023, 0, 40);

  // Print to serial
  Serial.println(waterLevel, DEC);
}
