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

void Hula(){ 
  colorCount=0; 
  rotation = 10 * .0174532; // convert 10 degree angle to radians
  for (int reps=0; reps<50; reps++){
    for (int z=0; z<8; z++) {  // for each layer
      getColor(colorCount,4);  // pick a color.  It will gradually change as  colorCount increases.
      colorCount = colorCount+3;
      if (colorCount>188){
        colorCount=0;
      }
      // here is the actual animation for one layer and it's compliment (7-z)
      for (int x=0; x<z+1; x++){
        for (int y=0; y<z+1; y++){
          buffer_LED(x, y, 7-z, myred, mygreen, myblue);
        }
      }
      for (int x=0; x<z+1; x++){
        for (int y=0; y<z+1; y++){
          buffer_LED(x, y, z, myred, mygreen, myblue);
        }
      }
      for (int x=1; x<z; x++){
        for (int y=1; y<z; y++){
          buffer_LED(x, y, 7-z, 0, 0,0);
        }
      }
      for (int x=1; x<z; x++){
        for (int y=1; y<z; y++){
          buffer_LED(x, y, z, 0, 0,0);
        }
      }
    }
    // Now we rotate the new formation 90 degrees. (9 * 10 degrees)
    for (int count=0; count<9; count++) {  // now rotate it. 
      rotateAll(myangle);  // the actual rotation of the animation
      myangle = myangle + rotation; // increment the angle
      if (myangle>6.28318) { // and make sure it doesn't overflow
        myangle=myangle-6.28318;  //subtract 2 pi radians
      }
#ifdef PICUBE
	delay(20);
#endif
    }
  }
  clearBufferCube();
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
}

