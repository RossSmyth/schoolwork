// Smyth Week 9 Lab
// Stepper Motor Scratch

// Constants

// Motor pins
#define STEPPER_1 2
#define STEPPER_2 3
#define STEPPER_3 4
#define STEPPER_4 5

#define STEPS_PER_ROTATION 2048

#define MOTOR_RPM 10

// variables
unsigned long stepPeriod;

// Functions
void setup() {
  // Set pinmodes
  pinMode(STEPPER_1, OUTPUT);
  pinMode(STEPPER_2, OUTPUT);
  pinMode(STEPPER_3, OUTPUT);
  pinMode(STEPPER_4, OUTPUT);

  // Calculate period
  stepPeriod = 1.0f / ((float)MOTOR_RPM * (float)STEPS_PER_ROTATION / 60.0f / 1000.0f / 1000.0f);
  
  // Rotate 1 rotation
  for (int i = 0; i < STEPS_PER_ROTATION; i++ ) {
    motorStep(); // this is essetnially a coroutine.
  }

  // Disable all poles on motor once done.
  digitalWrite(STEPPER_1, LOW);
  digitalWrite(STEPPER_2, LOW);
  digitalWrite(STEPPER_3, LOW);
  digitalWrite(STEPPER_4, LOW);
}

// Nothing to loop
void loop() {}

// State machine funciton aka coroutine
void motorStep() {
  static unsigned char state = 0; // store the state of the function. This is not called each time, only once.
  unsigned long timer; // us, time per step.
  switch (state) {
    case 0: // First step
      // micros because milliseconds intergers are too discrete
      timer = micros();
      
      digitalWrite(STEPPER_1, HIGH);
      digitalWrite(STEPPER_2, HIGH);
      while( micros() < timer + stepPeriod );

      state++;
      return;
      
    case 1: // Second step
      timer = micros();
      
      digitalWrite(STEPPER_1, LOW);
      digitalWrite(STEPPER_3, HIGH);
      while( micros() < timer + stepPeriod );

      state++;
      return;
    case 2: // Third step
      timer = micros();

      digitalWrite(STEPPER_2, LOW);
      digitalWrite(STEPPER_4, HIGH);
      while( micros() < timer + stepPeriod );

      state++;
      return;

    case 3: // Fourth step
      digitalWrite(STEPPER_3, LOW);
      digitalWrite(STEPPER_4, HIGH);
      digitalWrite(STEPPER_1, HIGH);
      while( micros() < timer + stepPeriod );
    
      digitalWrite(STEPPER_4, LOW);

      state = 0; // Reset to the inital state.
      return;      
  }
}
