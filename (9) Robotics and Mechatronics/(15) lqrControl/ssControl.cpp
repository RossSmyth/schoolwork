#include "ssControl.h"

// This calculates the output of a second-order SS controller.
// If a higher order is needed I'll do that then, but not now.
// This is because matrix calculations are slow.
// Make sure the K matrix is of a discrete controller
float calcEffort( const float referenceState[2][1], float userState[2][1], const float userK[2] ) {
  // This is the multiplication of the vectors
  return (referenceState[0][0] - userState[0][0]) * userK[0] + (referenceState[1][0] - userState[1][0]) * userK[1];
}
