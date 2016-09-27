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

void angledx(int color, int mycount){
  getColor(color, 4); 
  for (int z=0; z<8; z++){
    for (int x=0;x<8;x++){
      for (int y=0;y<8;y++){
        if (x+y==2*z) {
          if (mycount<40) {
            LED(x,y,z, myred, mygreen, myblue);
          }
          else  {
            LED(x,y,7-z, myred, mygreen, myblue);
          }
        } 
      }
    }
  }
}

void angledy(int color, int mycount){
  getColor(color, 4); 
  for (int z=0; z<8; z++){
    for (int x=0;x<8;x++){
      for (int y=0;y<8;y++){
        if (x+y==2*z) {
          if (mycount<40) {
            LED(y,z,x, myred, mygreen, myblue);
          }
          else  {
            LED(y,z,7-x, myred, mygreen, myblue);
          }
        }
      } 
    }
  }
}

void angledz(int color, int mycount){
  getColor(color, 4); 
  for (int z=0; z<8; z++){
    for (int x=0;x<8;x++){
      for (int y=0;y<8;y++){
        if (x+y==2*z) {
          if (mycount<40) {
            LED(z,x,y, myred, mygreen, myblue);
          }
          else  {
            LED(z,x,7-y, myred, mygreen, myblue);
          }
        } 
      }
    }
  }
}

void angled2(){
  mycolor=0;
  for (int j=0; j<80; j++){
    int mydelay=100;
    angledx(mycolor, j);
    delay(mydelay);
    clearCube(); 
    angledy(mycolor, j);
    delay(mydelay);
    clearCube(); 
    angledz(mycolor, j);
    delay(mydelay);
    clearCube(); 
    mycolor=mycolor-5; 
    if (mycolor<0){
      mycolor=185;
    }
  }
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
}

