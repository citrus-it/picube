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

void Mysterious() {
int xpos = 3;
int ypos = 3;
int mydelay = 50;
int myrandom;
  for (int j=0; j<400; j++){
    myrandom=random(8);
    if (myrandom==0){
      xpos++;
    }
    if (myrandom==1){
      xpos--;
    }
    if (myrandom==2){
      ypos++;
    }
    if (myrandom==3){
      ypos--;
    }
    if (xpos<0) {
      xpos=1;
    }
    if (xpos>6) {
      xpos=5;
    }
    if (ypos<0) {
      ypos=1;
    }
    if (ypos>6) {
      ypos=5;
    }
    getColor(mycolor,4);
    mycolor=mycolor-3;
    if (mycolor<1){
      mycolor=189;
    }
    if (xpos > -1 && ypos > -1)
    {
    LED(xpos, ypos, 7, myred, mygreen, myblue);
    LED(xpos+1, ypos, 7, myred, mygreen, myblue);
    LED(xpos, ypos+1, 7, myred, mygreen, myblue);
    LED(xpos+1, ypos+1, 7, myred, mygreen, myblue);
    delay(mydelay);
    }
    for (int x=0;x<8;x++){ // copy content of each layer to the layer below  it.
      for (int y=0;y<8;y++){
        for (int z=1;z<8;z++){
#ifdef PICUBE
	  copyLED(x, y, z, x, y, z-1);
#else
          for (int c=0;c<3;c++){
            cube [x][y][z-1][c] = cube [x][y][z][c];
          }
#endif
        }
      }
    }
    
    if (xpos > -1 && ypos > -1)
    {
    LED(xpos, ypos, 7, 0, 0, 0);
    LED(xpos+1, ypos, 7, 0, 0, 0);
    LED(xpos, ypos+1, 7, 0, 0, 0);
    LED(xpos+1, ypos+1, 7, 0, 0, 0);
    }
  }
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
 }

