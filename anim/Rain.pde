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

void lightOne() {
  int RED = 0;
  int GREEN = 0;
  int BLUE = 0;
  if (random(2)){  // red is on or off
    RED=63;
  }
  if (random(2)){  // green is on or off
    GREEN =63;
  }
  if (random(2)){  // blue is on or off
    BLUE=63;
  }
  LED (random(8), random(8), 7, RED,GREEN,BLUE); // light an LED in the top  layer with a random color
}

void Rain(int times){
  for (int count=0; count<times; count++){
    lightOne();   // load 5 colored LEDs into the top layer
    lightOne();
    lightOne();
    lightOne();
    lightOne();
    delay(100);  // wait 1/10 second
    for (int x=0;x<8;x++){
      for (int y=0;y<8;y++){
        for (int z=1;z<8;z++){
#ifdef PICUBE
	  copyLED(x, y, z, x, y, z-1);
#else
          for (int c=0;c<3;c++){
            cube [x][y][z-1][c] = cube [x][y][z][c];  // shift everything in  the cube down one
          }
#endif
        }
#ifdef PICUBE
	LED(x, y, 7, 0, 0, 0);
#else
        for (int c=0;c<3;c++){
          cube [x][y][7][c] = 0;  // and clear the top layer
        } 
#endif
      }
    }
  }
  clearCube();
#ifndef PICUBE
   delay(1000);
#endif
}
