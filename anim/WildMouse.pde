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

//This is the wild mouse animation

#ifdef PICUBE
static int dir, xyz;
static int history[24][6];
static int historyCount;
static int tempCount, tempCount2;
#endif

void Mouse1(){
  dir = 1;
  byte currentColor[3] = {0,0,0};
  xx=7;  
  yy= 7;  
  zz=7;
  xyz=1; 
  for (int myloop; myloop<760; myloop= myloop+2){
    LED(xx,yy,zz,currentColor[0],currentColor[1],currentColor[2]);  //light up  the current position with current color 
    xx1=xx; 
    yy1=yy; 
    zz1=zz; 
    switch(xyz){   
    case 1: // moving across layers
      if (dir == 1){ // if moving higher?
        xx++;
        if (xx>7){ // Did we hit an edge on the high end?
          xx=7;
          xyz=2; // if so, change direction
          if (yy<4){ // in new direction, move toward the middle
            dir = 1;
          }
          else {
            dir =-1;
          }
        }
      }
      if (dir == -1){  // if moving lower?
        xx--;
        if (xx<0) { // Did we hit an edge on the low end?
          xx=0;
          xyz=3;   // if so, change direction
          if (zz<4){  // in new direction, move toward the middle
            dir = 1;
          }
          else {
            dir =-1;
          }
        }
      }

      if (random(5) == 0){  // one in 5 times, change move dimension in the  middle of the cube
        if (random(2) == 0){  // which way to change dimension?
          xyz=2;  // move across panels 
        }
        else {
          xyz=3;  // move across columns
        }
      }
      break;

    case 2: // moving across panels  (similar to above)
      if (dir == 1){
        yy++;

        if (yy>7){
          yy=7; 
          xyz=3; 
          if (zz<4){
            dir = 1;
          }
          else {
            dir =-1;
          }
        }
      }
      if (dir == -1){
        yy--;
        if (yy<0) {
          yy=0;
          xyz=1; 
          if (xx<4){
            dir = 1;
          }
          else {
            dir =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz=3;
        }
        else {
          xyz=1;
        }
      } 
      break;
    case 3:  // moving across columns, similar to above
      if (dir == 1){
        zz++;
        if (zz>7){
          zz=7; 
          xyz=1; 
          if (xx<4){
            dir = 1;
          }
          else {
            dir =-1;
          }
        }
      }
      if (dir == -1){
        zz--;
        if (zz<0) {
          zz=0;
          xyz=2; 
          if (yy<4){
            dir = 1;
          }
          else {
            dir =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz=1;
        }
        else {
          xyz=2;
        }
      }
      break;
    } 

    history[historyCount][0]= xx1;  // move the current position into the  history so we can control the trail
    history[historyCount][1]= yy1;
    history[historyCount][2]= zz1;
    history[historyCount][3]= currentColor[0];
    history[historyCount][4]= currentColor[1];
    history[historyCount][5]= currentColor[2];

    tempCount2 = historyCount+1;  // move ahead in the history by one, which  is last position in the trail
    if (tempCount2==24){
      tempCount2=0;
    }
    history[tempCount2][3]= 0;    // and set in to all zeros.
    history[tempCount2][4]= 0;
    history[tempCount2][5]= 0;


    for (int mycount=0; mycount<24; mycount++){  // update the cube with new  trail data
      xx1=history[mycount][0];
      yy1=history[mycount][1];
      zz1=history[mycount][2];
      LED(xx1,yy1,zz1,history[mycount][3],history[mycount][4],history [mycount][5]);
    }

    historyCount++;
    if (historyCount>23){ // keep the history counter in bounds
      historyCount = 0; 
    }
    if (tempCount==4){ // update the every 4th time through
      getColor(mycolor, 4);
      currentColor[0] = myred;
      currentColor[1] = mygreen;
      currentColor[2] = myblue;
      mycolor++;
      if (mycolor>189){ // keep the color in bounds
        mycolor = 0;
      }
      tempCount = 0;
    }
    tempCount++;
    delay (30);  // delay to control speed
  }

  for (int mycount=0; mycount<24; mycount++){  // Clear the trail
    xx1=history[mycount][0];
    yy1=history[mycount][1];
    zz1=history[mycount][2];
    LED(xx1,yy1,zz1,0,0,0);
  }
  clearCube();  // Clear the cube
#ifndef PICUBE
   delay(1000);
#endif
}
