/*
 * This code is adapted from:
 *
 * 8 x 8 x 8 Cube Application Template, Version 7.0  © 2014 by Doug Domke
 * Downloads of this template and upcoming versions, along with detailed
 * instructions, are available at: http://d2-webdesign.com/cube
 *
 * Local modifications required to support the Pi cube software are
 * bracketed within #ifdef PICUBE
 */

// The animation creates some interesting stuff to rotate around in the cube
void Rotor(int reps, int myspeed) {
  rotation = myspeed * .0174532; // convert angle to radians
  for (int mycount=0; mycount<reps; mycount++){ // create the first pattern
  for (byte layer=0; layer<8; layer++){
    buffer_LED(7,7-layer,layer, 63,63,0);
    buffer_LED(6,7-layer,layer, 63,0,63);
    buffer_LED(1,layer,layer, 0,63,0);
    buffer_LED(0,layer,layer, 0,0,63);
  }
  for (int count=0; count<90; count++){ // rotate it
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle>6.28318) { // and make sure it doesn't overflow
      myangle=0;
    }
  }
  clearBufferCube();
  for (byte layer=0; layer<8; layer++){  // create the second pattern
    buffer_LED(6,7-layer,layer, 63,63,0);
    buffer_LED(5,7-layer,layer, 63,0,63);
    buffer_LED(2,layer,layer, 0,63,0);
    buffer_LED(1,layer,layer, 0,0,63);
  }
  for (int count=0; count<90; count++){  // rotate it
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle>6.28318) { // and make sure it doesn't overflow
      myangle=0;
    }
  }
  clearBufferCube();
  for (byte layer=0; layer<8; layer++){  // create the third pattern
    buffer_LED(5,7-layer,layer, 63,63,0);
    buffer_LED(4,7-layer,layer, 63,0,63);
    buffer_LED(3,layer,layer, 0,63,0);
    buffer_LED(2,layer,layer, 0,0,63);
  }
  for (int count=0; count<90; count++){ // rotate it
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle>6.28318) { // and make sure it doesn't overflow
      myangle=0;
    }
  }
  rotation = -rotation;
  for (int count=0; count<90; count++){  // now rotate the third pattern  backward
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle<=0) {  // don't let angle overflow
      myangle=6.28318;
    }
  }
  clearBufferCube(); // reload the 2nd pattern
  for (byte layer=0; layer<8; layer++){
    buffer_LED(6,7-layer,layer, 63,63,0);
    buffer_LED(5,7-layer,layer, 63,0,63);
    buffer_LED(2,layer,layer, 0,63,0);
    buffer_LED(1,layer,layer, 0,0,63);
  }
  for (int count=0; count<90; count++){ // rotate it backward
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle<=0) {  // don't let angle overflow
      myangle=6.28318;
    }
  }
  clearBufferCube();
   for (byte layer=0; layer<8; layer++){  // reload the first pattern
    buffer_LED(7,7-layer,layer, 63,63,0);
    buffer_LED(6,7-layer,layer, 63,0,63);
    buffer_LED(1,layer,layer, 0,63,0);
    buffer_LED(0,layer,layer, 0,0,63);
  }
  for (int count=0; count<90; count++){ // rotate it backward
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle<=0) {  // don't let angle overflow
      myangle=6.28318;
    }
  }
  for (byte layer=0; layer<8; layer++){  // now add a reversed version of the  first pattern
    buffer_LED(7,layer,layer, 63,63,0);  // we didn't clear the buffer so both  patterns are there together
    buffer_LED(6,layer,layer, 63,0,63);
    buffer_LED(1,7-layer,layer, 0,63,0);
    buffer_LED(0,7-layer,layer, 0,0,63);
  }
  for (int count=0; count<90; count++){  // not rotate it forward
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle<=0) {  // don't let angle overflow
      myangle=6.28318;
    }
  }
  rotation = -rotation;
  for (int count=0; count<90; count++){  // and rotate it backwards
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle>6.28318) { // and make sure it doesn't overflow
      myangle=0;
    }
  }
  }
  clearBufferCube();
  clearCube();
#ifndef PICUBE
   delay(1000);
#endif
}
