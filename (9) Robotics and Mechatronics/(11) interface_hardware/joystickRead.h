#include "Arduino.h"

// joystickRead.h

#ifndef HEADER_JOYSTICKREAD
  #define HEADER_JOYSTICKREAD
   
  // Prototype for setup function
  void joystick_setup( void );
  void joystick_read(float* pitch, float* roll, bool* button);
#endif
