/// Lab 3 DC Motor
/// Semi-auto motor
/// Author: Ross Smyth

// Constants
#define buttonIn 2 // push-button in
const int pitchIn = A0; // pitch axis in

#define motorIN1 4 // Driver IN1 pin
#define motorIN2 5 // Driver IN2 pin

// Variables
int pitch = 0; // stores pitch value

// stores state of program
// true will be joystick control
// false will be serial control, the default.
volatile bool state = false; 

int  userSpeed  = 0; // User speed via serial
bool motorDir   = false; // 0 = negative, 1 = positive
int  motorSpeed = 0; // Speed mapped to PWM

void setup() {
  // Initilize pins for motor PWM control
  pinMode(motorIN1, OUTPUT);
  pinMode(motorIN2, OUTPUT);
  
  // sets digital pin for reading the button
  // Not sure if button has pull-down resistor. We'll see in lab.
  pinMode(buttonIn, INPUT_PULLUP);
  
  // Instance Serial object
  Serial.begin(9600);
  
  // Wait for serial connection to initialize
  while(!Serial) {;}

  // Attach interrupt routines for a button press to change state.
  attachInterrupt(digitalPinToInterrupt(buttonIn), stateChange, RISING);
}

void loop() {
  // Check the state and run the respective function
  if (state) {
    joystickControl();
  } else {
    serialControl();
  }
  // finally, set the motor speed
  setMotorSpeed();
}

// Interrupt routine for the program state change
void stateChange() {
  state = !state;
}

// Function runs when in the state to control via joystick
void joystickControl() {
  // Sets analog variable to its reading
  // subtracted by 127 to shift the zero to the midpoint
  // check in lab if that is exactl the midpoint or if I'm off
  // by one. Or may it has a bias.
  pitch = analogRead(pitchIn) - 511;

  // Map the shifted range to the speed
  // I think I see why in Zelda: Ocarina of Time and in
  // Super Mario 64 they move faster backwards than forwards
  motorSpeed = map(abs(pitch), 0, 512, 0, 255);
Serial.println(motorSpeed);
  // Set to true for forwards when greater than zero
  motorDir = (pitch > 0);
  Serial.println(motorDir);
}

// This function only runs during serial control time
// it grabs input if avaliable and sets the motor variables
void serialControl() {
  if (Serial.available() > 0){
    // Grabs an integer from serial port
    userSpeed = Serial.parseInt(SKIP_ALL, '\n');

    // Maps to users' values to PWM
    motorSpeed = map(abs(userSpeed), 0, 100, 0, 255);

    // Set to true for forwards when greater than zero
    motorDir = (userSpeed > 0);
  }
}

// This function reads the globals,
// and sets the motor speed accordingly.
void setMotorSpeed() {
    if (!motorSpeed) {
    // If speed is zero, both are low
    analogWrite(motorIN1, 0);
    analogWrite(motorIN2, 0);
  } else if (motorDir) {
    // If positive have IN1 be PWM
    analogWrite(motorIN1, motorSpeed);
    // and have IN2 be low
    analogWrite(motorIN2, 0);
  } else {
    // Negative IN1 is low
    analogWrite(motorIN1, 0);
    // and IN2 is PWM
    analogWrite(motorIN2, motorSpeed);
  }
}
