/// Lab 3 DC Motor
/// DC Motor Speed
/// Author: Ross Smyth

// Constants
#define motorIN1 4 // Driver IN1 pin
#define motorIN2 5 // Driver IN2 pin

// Variables
int userSpeed  = 0; // User speed via serial

bool motorDir = false; // 0 = negative, 1 = positive
int motorSpeed = 0; // Speed mapped to PWM

// Functions
void setup() {
  // Initilize pins for motor PWM control
  pinMode(motorIN1, OUTPUT);
  pinMode(motorIN2, OUTPUT);
  
  // Instance Serial object
  Serial.begin(9600);
  
  // Wait for serial connection to initialize
  while(!Serial) {;}
}

void loop() {
  setMotorSpeed();
  
  if (Serial.available() > 0){
    // Grabs an integer from serial port
    userSpeed = Serial.parseInt(SKIP_ALL, '\n');

    // Maps to users' values to PWM
    motorSpeed = map(abs(userSpeed), 0, 100, 0, 255);

    // Set to true for forwards when greater than zero
    motorDir = (userSpeed > 0);
    Serial.println(userSpeed);
  }
}

// This function reads the globals,
// and sets the speed accordingly.
void setMotorSpeed() {
    if (!motorSpeed) {
    // If speed is zero, both are low
    analogWrite(motorIN1, 0);
    analogWrite(motorIN2, 0);
  } else if (motorDir) {
    // If positive have IN1 be PWM
    analogWrite(motorIN1, motorSpeed);
    Serial.println(motorSpeed);
    // and have IN2 be low
    analogWrite(motorIN2, 0);
  } else {
    // Negative IN1 is low
    analogWrite(motorIN1, 0);
    // and IN2 is PWM
    analogWrite(motorIN2, motorSpeed);
  }
}
