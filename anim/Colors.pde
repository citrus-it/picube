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

// A simple animation with a panel changing color and rotating.
void colors() {
  for (int j=0; j<25; j++){
   for (int z=0; z<8; z++){
    getColor(mycolor, 4);
    for (int x=0; x<8; x++) {
      buffer_LED(x,x,z,myred, mygreen, myblue);   
    }
    mycolor= mycolor+20; 
    if (mycolor > 189){
      mycolor=0;
    }
  }
  mycolor= count; 
  count= count+10;
  if (count == 190){
    count=0;
    }
  rotateCube(1, 15);
   }
  clearCube();
  clearBufferCube();
#ifndef PICUBE
  delay(1000);
#endif
}
