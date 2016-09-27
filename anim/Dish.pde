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

// As the name implies, this forms a dish, which changes
// color and floats around using the full cube rotation
void dish(){
  mycolor=0;
  getColor(mycolor,4); 
  for (int j=0; j<8; j++){
    for (byte x=0; x<8; x++){  
      for (byte y=0; y<8; y++){
        buffer_LED(x,y,((x*x)+(y*y))/12,myred, mygreen, myblue);
      }
    }
    mycolor=mycolor+30;
    manage_color();
    rotateCube(1+random(3), 15);
    for (byte x=0; x<8; x++){  
      for (byte y=0; y<8; y++){
        buffer_LED(x,y,((x*x)+(y*y))/12,myred, mygreen, myblue);
      }
    }
    mycolor=mycolor+30;
    manage_color();
    rotateCube(1+random(3), -15);
  }
  clearCube();
  clearBufferCube();
#ifndef PICUBE
  delay(1000);
#endif
}
