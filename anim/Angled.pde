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

/* Angled is simple - a diagonal plane running from one corner 
of the cube to the oposite corner is rotated.  Variations include
multiple planes and different colors.
 */

void angled(){
    getColor(Blue, 4);
    for (int z=0; z<8; z++){
      for (int x=0;x<8;x++){
        for (int y=0;y<8;y++){
          if (x+y==2*z) {
            buffer_LED(x,y,z,myred, mygreen, myblue); 
          } 
        }
      }
    }
  rotateCube(5, 5);
  for (int j=0; j<25; j++){
    mycolor=mycolor+5;
    if (mycolor>189){
      mycolor=0;
    }
    int my2ndColor= mycolor+85;
    if (my2ndColor>189){
      my2ndColor=0;
    }
    getColor(mycolor, 4);
    for (int z=0; z<8; z++){
      for (int x=0;x<8;x++){
        for (int y=0;y<8;y++){
          if (x+y==2*z) {
            buffer_LED(x,y,z,myred, mygreen, myblue); 
          } 
        }
      }
    }
    if (j<5 || j>14){
    getColor(my2ndColor,4);}
    else {
    getColor(mycolor,4);
    }
    for (int z=0; z<8; z++){
      for (int x=0;x<8;x++){
        for (int y=0;y<8;y++){
          if (x+y==2*z) {
            if (j<10 || j>20) {
              buffer_LED(x,7-y,z,myred, mygreen, myblue); }
            if (j>9) {
              buffer_LED(7-x,7-y,z,myred, mygreen, myblue);
            }
          } 
        }
      }
    }
   
    rotateCube(1, 5);
    if (j<20) {clearBufferCube();}
  }
  clearCube();
  clearBufferCube();
#ifndef PICUBE
  delay (1000);
#endif
}
