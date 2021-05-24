#include "encoderRead.h"

void setup() {
  Serial.begin(9600);
  setup_encoder();
}

void loop() {
  float angle = read_encoder();// in [deg]
  Serial.println(angle);
  delay(50);
}
