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

void Elevators() {
  byte location[8][8][2];  //this array stores the location and direction of  each elevator 
  for (byte xx=0; xx<8; xx++){  // this is the setup routine.
    for (byte yy=0; yy<8; yy++){
      location[xx][yy][0]= random(4); // pick an initial floor
      if (location[xx][yy][0] >0) {location[xx][yy][0]= 10;}  // only ones on  the ground floor are chosen. 
      // other 2/4 of LEDs are banished to the 10th floor where they won't be  seen.  
      location[xx][yy][1]= random(3);  // select an initial direction of  travel: up, down, or stopped. 
      if (location[xx][yy][0]<8)  {  // if it's not on the 10th floor, assign  it a color
        rnd_std_color();
        LED(xx,yy,location[xx][yy][0], myred, mygreen, myblue); // and turn it  on.  
      }
    }
  } 
  delay(2000); // our elevators are all set up and lit up on the ground floor.   
  for (int j=0;  j<250; j++){  // now we put them in motion
    for (byte xx=0; xx<8; xx++){
      for (byte yy=0; yy<8; yy++){
        if (location[xx][yy][0]<8)  { // if it's a valid elevator
#ifdef PICUBE
	  myred = xLED(xx, yy, location[xx][yy][0], RED);
	  mygreen = xLED(xx, yy, location[xx][yy][0], GREEN);
	  myblue = xLED(xx, yy, location[xx][yy][0], BLUE);
#else
          myred=cube[xx][yy][location[xx][yy][0]][0]; // get its color
          mygreen=cube[xx][yy][location[xx][yy][0]][1];
          myblue=cube[xx][yy][location[xx][yy][0]][2];
#endif
          LED(xx,yy,location[xx][yy][0],0,0,0); // then erase it from its  current position
          if (random(3)==0){  // 1/3 of the time
            location[xx][yy][1]= random(3);  //change direction: up, down, or  stopped
          }
          if (location[xx][yy][1]==1){ // if it's going up, 
            if (location[xx][yy][0]<7){  // and not already on the top floor
              location[xx][yy][0]=location[xx][yy][0]+1; // move it up one
            }
            else{ // on the top floor?
              location[xx][yy][0]=location[xx][yy][0]-1;  // move down one
              location[xx][yy][1]==2; // change direction to down
            }
          }
          if (location[xx][yy][1]==2){  // if it's going down,
            if (location[xx][yy][0]>0){ // and not already on the ground floor
              location[xx][yy][0]=location[xx][yy][0]-1;  // move it down one
            }
            else{ // on the bottom floor?
              location[xx][yy][0]=location[xx][yy][0]+1; // move up one
              location[xx][yy][1]==1;  //change direction to up
            }
          }
          LED(xx,yy,location[xx][yy][0], myred, mygreen, myblue); // turn on  in new location
        }
      }
    } 
    delay(300-j);  // wait, with animation speeding up as j increases. 
  }
  clearCube();    // clear the cube
#ifndef PICUBE
  delay(1000);
#endif
}
