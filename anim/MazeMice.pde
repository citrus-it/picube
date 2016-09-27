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

// MazeMice is derived from my previos Mouse animation.  There are three 
// mice this time, and the "tails" are much shorter. Nothing fancy, but
// a lot of repetitious code! 
void mazemice(){
  int dir1 = 1, dir2 = 1, dir3 =1;
  int xx1=7,xx2=7,xx3=7, xx11,xx12, xx13, xx21,xx22, xx23,xx31,xx32, xx33;  
  int yy1= 7,yy2= 7,yy3=7, yy11,yy12, yy13, yy21,yy22, yy23,yy31,yy32, yy33;  
  int zz1=7,zz2=7,zz3=7, zz11,zz12,zz13, zz21,zz22,zz23,zz31,zz32, zz33;
  int xyz1=1,xyz2=1,xyz3=1; 
  for (int myloop; myloop<820; myloop= myloop+2){
    LED(xx1,yy1,zz1,31,63,0);  
    LED(xx2,yy2,zz2,0,63,63);
    LED(xx3,yy3,zz3,31,0,63);
    if (myloop>4){
     LED(xx11,yy11,zz11,5,10,0);  
     LED(xx21,yy21,zz21,0,10,10);
     LED(xx31,yy31,zz31,5,0,10);
     LED(xx12,yy12,zz12,2,4,0);  
     LED(xx22,yy22,zz22,0,4,4);
     LED(xx32,yy32,zz32,2,0,4);
    }
    delay(75);
  //  LED(xx1,yy1,zz1,0,0,0);  
  //  LED(xx2,yy2,zz2,0,0,0);
  //  LED(xx3,yy3,zz3,0,0,0);
  if (myloop>4){
    LED(xx13,yy13,zz13,0,0,0);  
    LED(xx23,yy23,zz23,0,0,0);
    LED(xx33,yy33,zz33,0,0,0);
   }
    xx13=xx12;  yy13=yy12;  zz13=zz12;
    xx12=xx11;  yy12=yy11;  zz12=zz11;
    xx11=xx1;  yy11=yy1;  zz11=zz1;
    xx23=xx22;  yy23=yy22;  zz23=zz22;
    xx22=xx21;  yy22=yy21;  zz22=zz21;
    xx21=xx2;  yy21=yy2;  zz21=zz2;
    xx33=xx32;  yy33=yy32;  zz33=zz32;
    xx32=xx31;  yy32=yy31;  zz32=zz31;
    xx31=xx3;  yy31=yy3;  zz31=zz3;
    // For Red, everything is 1
    switch(xyz1){   
    case 1: // moving across layers
      if (dir1 == 1){ // if moving higher?
        xx1++;
        if (xx1>7){ // Did we hit an edge on the high end?
          xx1=7;
          xyz1=2; // if so, change direction
          if (yy1<4){ // in new direction, move toward the middle
            dir1 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }
      if (dir1 == -1){  // if moving lower?
        xx1--;
        if (xx1<0) { // Did we hit an edge on the low end?
          xx1=0;
          xyz1=3;   // if so, change direction
          if (zz1<4){  // in new direction, move toward the middle
            dir1 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }

      if (random(5) == 0){  // one in 5 times, change move dimension in the  middle of the cube
        if (random(2) == 0){  // which way to change dimension?
          xyz1=2;  // move across panels 
        }
        else {
          xyz1=3;  // move across columns
        }
      }
      break;

    case 2: // moving across panels  (similar to above)
      if (dir1 == 1){
        yy1++;

        if (yy1>7){
          yy1=7; 
          xyz1=3; 
          if (zz1<4){
            dir1 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }
      if (dir1 == -1){
        yy1--;
        if (yy1<0) {
          yy1=0;
          xyz1=1; 
          if (xx1<4){
            dir1 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz1=3;
        }
        else {
          xyz1=1;
        }
      } 
      break;
    case 3:  // moving across columns, similar to above
      if (dir1 == 1){
        zz1++;
        if (zz1>7){
          zz1=7; 
          xyz1=1; 
          if (xx1<4){
            dir1 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }
      if (dir1 == -1){
        zz1--;
        if (zz1<0) {
          zz1=0;
          xyz1=2; 
          if (yy1<4){
            dir1 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz1=1;
        }
        else {
          xyz1=2;
        }
      }
      break;
    } 
  // For Green, everything is 2  
  switch(xyz2){   
    case 1: // moving across layers
      if (dir2 == 1){ // if moving higher?
        xx2++;
        if (xx2>7){ // Did we hit an edge on the high end?
          xx2=7;
          xyz2=2; // if so, change direction
          if (yy2<4){ // in new direction, move toward the middle
            dir2 = 1;
          }
          else {
            dir2 =-1;
          }
        }
      }
      if (dir2 == -1){  // if moving lower?
        xx2--;
        if (xx2<0) { // Did we hit an edge on the low end?
          xx2=0;
          xyz2=3;   // if so, change direction
          if (zz1<4){  // in new direction, move toward the middle
            dir2 = 1;
          }
          else {
            dir2 =-1;
          }
        }
      }

      if (random(5) == 0){  // one in 5 times, change move dimension in the  middle of the cube
        if (random(2) == 0){  // which way to change dimension?
          xyz2=2;  // move across panels 
        }
        else {
          xyz2=3;  // move across columns
        }
      }
      break;

    case 2: // moving across panels  (similar to above)
      if (dir2 == 1){
        yy2++;

        if (yy2>7){
          yy2=7; 
          xyz2=3; 
          if (zz2<4){
            dir2 = 1;
          }
          else {
            dir2 =-1;
          }
        }
      }
      if (dir2 == -1){
        yy2--;
        if (yy2<0) {
          yy2=0;
          xyz2=1; 
          if (xx2<4){
            dir2 = 1;
          }
          else {
            dir2 =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz2=3;
        }
        else {
          xyz2=1;
        }
      } 
      break;
    case 3:  // moving across columns, similar to above
      if (dir2 == 1){
        zz2++;
        if (zz2>7){
          zz2=7; 
          xyz2=1; 
          if (xx2<4){
            dir2 = 1;
          }
          else {
            dir1 =-1;
          }
        }
      }
      if (dir2 == -1){
        zz2--;
        if (zz2<0) {
          zz2=0;
          xyz2=2; 
          if (yy2<4){
            dir2 = 1;
          }
          else {
            dir2 =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz2=1;
        }
        else {
          xyz2=2;
        }
      }
      break;
    }
   // For Blue everything is 3
  switch(xyz3){   
    case 1: // moving across layers
      if (dir3 == 1){ // if moving higher?
        xx3++;
        if (xx3>7){ // Did we hit an edge on the high end?
          xx3=7;
          xyz3=2; // if so, change direction
          if (yy3<4){ // in new direction, move toward the middle
            dir3 = 1;
          }
          else {
            dir3 =-1;
          }
        }
      }
      if (dir3 == -1){  // if moving lower?
        xx3--;
        if (xx3<0) { // Did we hit an edge on the low end?
          xx3=0;
          xyz3=3;   // if so, change direction
          if (zz3<4){  // in new direction, move toward the middle
            dir3 = 1;
          }
          else {
            dir3 =-1;
          }
        }
      }

      if (random(5) == 0){  // one in 5 times, change move dimension in the  middle of the cube
        if (random(2) == 0){  // which way to change dimension?
          xyz3=2;  // move across panels 
        }
        else {
          xyz3=3;  // move across columns
        }
      }
      break;

    case 2: // moving across panels  (similar to above)
      if (dir3 == 1){
        yy3++;

        if (yy3>7){
          yy3=7; 
          xyz3=3; 
          if (zz3<4){
            dir3 = 1;
          }
          else {
            dir3 =-1;
          }
        }
      }
      if (dir3 == -1){
        yy3--;
        if (yy3<0) {
          yy3=0;
          xyz3=1; 
          if (xx3<4){
            dir3 = 1;
          }
          else {
            dir3 =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz3=3;
        }
        else {
          xyz3=1;
        }
      } 
      break;
    case 3:  // moving across columns, similar to above
      if (dir3 == 1){
        zz3++;
        if (zz3>7){
          zz3=7; 
          xyz3=1; 
          if (xx3<4){
            dir3 = 1;
          }
          else {
            dir3 =-1;
          }
        }
      }
      if (dir3 == -1){
        zz3--;
        if (zz3<0) {
          zz3=0;
          xyz3=2; 
          if (yy3<4){
            dir3 = 1;
          }
          else {
            dir3 =-1;
          }
        }
      }

      if (random(5) == 0){
        if (random(2) == 0){
          xyz3=1;
        }
        else {
          xyz3=2;
        }
      }
      break;
    }
 
  }
  clearCube();  // Clear the cube
#ifndef PICUBE
  delay(1000);
#endif
}
