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

// This probably holds the record for my simplist animation
void randomLights(){
  // first we select standard colors
 for (int k=0; k<12; k++){
  rnd_std_color();
  for (int j=0; j<256; j++){
    LED(random(8), random(8), random(8), myred, mygreen, myblue); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    delay(8);
  }
 }
 clearCube();
 delay(250);
 mycolor=0;
 // then we scan through the colors of the rainbow. 
 for (int k=0; k<35; k++){
  mycolor=mycolor+5;
  if (mycolor>189){mycolor=0;}
  getColor(mycolor,4);
  for (int j=0; j<70; j++){
    LED(random(8), random(8), random(8), myred, mygreen, myblue); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    delay(8);
  }
 }
 mycolor = 170;
 // Finally we hang out in the blue/ violet/ purple area of the
 // spectrum and try to create an effect something like northern lights.
 for (int k=0; k<40; k++){
  if (random(2)) {
    mycolor=mycolor+5;
    if (mycolor>189){mycolor=180;}
  }
  else {
    mycolor=mycolor-5;
    if (mycolor<140){mycolor=150;}
  }
  getColor(mycolor,4);
  for (int j=0; j<50; j++){
    LED(random(8), random(8), random(8), myred, mygreen, myblue); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    LED(random(8), random(8), random(8), 0, 0, 0); 
    delay(8);
  }
 }
 clearCube();
#ifndef PICUBE
 delay(1000);
#endif
}
