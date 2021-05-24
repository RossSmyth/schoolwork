// encoderRead.h
#include "Arduino.h"

#ifndef HEADER_ENCODERREAD
  #define HEADER_ENCODERREAD
  
    struct ENCODER {
      // Inputs
      int encoderChannel1;
      int encoderChannel2;
    
      // Config
      float anglePerPulse;

      // "Private" (even if no such thing)
      unsigned long _lastRead;
      
    
      // User output
      float angle;
      float velocity;
   };

    // Prototype for functions
    struct ENCODER* setupEncoder(int userChannel1, int userChannel2, float userAngPP);
    void            readEncoder( struct ENCODER* userEncoder );
    void            resetEncoder( struct ENCODER* userEncoder );
#endif
