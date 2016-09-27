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

// this anamation sort of looks like a tornado.  is gets faster as it goes,  eventually
// picking up yellew debris in its center, which turns red as it gets faster. 
void Tornado(){
  rotation = 12 * .0174532; // convert angle to radians - this is slow speed
  buffer_LED(1,1,7,0,0,63);  // this sets up the tornato
  buffer_LED(0,4,6,0,0,63);
  buffer_LED(2,5,5,0,0,63);
  buffer_LED(3,6,4,0,0,63);
  buffer_LED(5,5,3,0,0,63);
  buffer_LED(5,4,2,0,0,63);
  buffer_LED(4,4,1,0,0,63);
  buffer_LED(4,3,0,0,0,63);
  buffer_LED(6,6,7,0,63,0);
  buffer_LED(7,4,6,0,63,0);
  buffer_LED(5,2,5,0,63,0);
  buffer_LED(4,2,4,0,63,0);
  buffer_LED(2,2,3,0,63,0);
  buffer_LED(2,4,2,0,63,0);
  buffer_LED(3,3,1,0,63,0);
  buffer_LED(3,4,0,0,63,0);
  for (int count=0; count<400; count++){
    if (count>100) { // this speeds up the rotation
      rotation = 23 * .0174532;
    }
    if (count>200) { // this speeds up the rotation again
      rotation = 30 * .0174532;
      buffer_LED(5,2,7,31,63,0);  //this adds the yellow debris
      buffer_LED(4,2,6,31,63,0);
      buffer_LED(2,2,5,31,63,0);
      buffer_LED(3,3,4,31,63,0);
      buffer_LED(4,4,3,31,63,0);
    }
    if (count>300) { // this speeds up the rotation again
      rotation = 37 * .0174532; // this adds the red debris
      buffer_LED(5,3,7,31,0,0);
      buffer_LED(4,3,6,31,0,0);
      buffer_LED(3,2,5,31,0,0);
      buffer_LED(4,4,4,31,0,0);
      buffer_LED(3,3,3,31,0,0);
    }
    rotateAll(myangle);  // the actual rotation of the animation
    myangle = myangle + rotation; // increment the angle
    if (myangle>6.28318) { // and make sure it doesn't overflow
      myangle=myangle-6.28318;
    }
  }
  clearBufferCube();
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
}
