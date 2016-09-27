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

// this code creates flash effects. We turn on a random LED every 10 msec.
// each LED once on stays on through one complete loop or 30 msec. 
void Sparkle() {
  getColor(White, 4);  //flashes are white
  for (int j=0; j<200; j++){  // go around 75 times
    int newx1, newy1, newz1, newx2, newy2, newz2, newx3, newy3, newz3; //  locations for 3 LEDs that are on at one time
    newx1=random(8);
    newy1=random(8);
    newz1=random(8);
    LED(newx1, newy1, newz1, myred, mygreen, myblue); // create the first
    delay(10);
    LED(newx2, newy2, newz2, 0, 0, 0);  // turn off the second
    newx2=random(8);
    newy2=random(8);
    newz2=random(8);
    LED(newx2, newy2, newz2, myred, mygreen, myblue);  // create the second
    delay(10);
    LED(newx3, newy3, newz3, 0, 0, 0); // turn off the third
    newx3=random(8);
    newy3=random(8);
    newz3=random(8);
    LED(newx3, newy3, newz3, myred, mygreen, myblue);  // create the third
    delay(10);
    LED(newx1, newy1, newz1, 0, 0, 0);  // turn off the first
  }
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
}
