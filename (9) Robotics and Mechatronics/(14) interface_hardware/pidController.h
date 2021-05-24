#ifndef HEADER_PIDCONTROLLER
  #define HEADER_PIDCONTROLLER

  // Struct that defines a PID controller. Easy to use later.
  // Could add a derivative filter as well but I don't think the signal is that noisy
  // Shall see in lab if that's true. If so then prevState may need to be an array.
  typedef struct {
    float         Kp;        // Proportional gain
    float         Ki;        // Integral gain
    float         Kd;        // Derivative gain
    int           dt;        // Time step (milliseconds)
  } PID;
  
  // Prototype for setup function
  void pid_setup( PID* );
  void reset_controller( void );
  float pid_run( float error );
  
#endif
