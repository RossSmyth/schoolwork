#include "Arduino.h"

// ssControl.h

#ifndef HEADER_SSCONTROL
  #define HEADER_SSCONTROL
    /*
     * State-feedback control.
     */

    /*
     * * * * * * * * * * * * * * * * ** * * * * * Defintions
     */ 
     // the only function here
     float calcEffort( const float referenceState[2][1], float userState[2][1], const float userK[2] );
#endif
