#include "Arduino.h"

// motorControl.h

#ifndef HEADER_MOTORCONTROL
  #define HEADER_MOTORCONTROL

    /*
     * * * * * * * * * * * * * * * * ** * * * * * Defintions
     */ 
    
    struct MOTOR {
      // Hardware
      int motorChan1; // Motor driver input 1
      int motorChan2; // Motor driver input 1
    
      // Configure
      float userConvert; // Conversion from user input to [-255, 255]
    };
  
    
    // Prototypes for functions
    struct MOTOR* setupMotor( int motorOut1, int motorOut2, float userPWMconvert );
    void          writeMotor( float motorEffort, struct MOTOR* userMotor );
#endif
