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

// This is new animation derived from the elevator animation.  Just messing  with the 
// elevator's code created this interesting effect.

void Chaos() {
  for (int k=0; k<15; k++){
    byte location[8][8][2];  //this array stores the location and direction of  each column 
    for (byte xx=0; xx<8; xx++){  // this is the setup routine.
      for (byte yy=0; yy<8; yy++){
        location[xx][yy][0]= random(7);
        if (location[xx][yy][0] >0) {
          location[xx][yy][0]= 10;
        }  // only ones at layer 0 are chosen. 
        // other 3/4 of LEDs are banished to the 10th layer where they won't  be seen.  
        location[xx][yy][1]= random(3);  // select an initial direction of  travel: up, down, or stopped. 
        if (location[xx][yy][0]<8)  {  // if it's not on the 10th level,  assign it a color
          LED(xx,yy,location[xx][yy][0], myred, mygreen, myblue); // and turn  it on.  
        }
      }
    } 

    for (int j=0;  j<50; j++){  // now we put them in motion
      getColor(mycolor,4);
      mycolor=mycolor-1;
      if (mycolor<1){
        mycolor=189;
      }
      for (byte xx=0; xx<8; xx++){
        for (byte yy=0; yy<8; yy++){
          if (location[xx][yy][0]<8)  { // if it's a valid location (not 10th  layer
            if (random(3)==0){  // 1/3 of the time
              location[xx][yy][1]= random(3);  //change direction: up, down,  or stopped
              for (int z=0; z<8; z++) { // at this time erase everything in  this xx,yy column
                LED(xx,yy,z,0,0,0);
              }
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
              if (location[xx][yy][0]>0){ // and not already on the ground  floor
                location[xx][yy][0]=location[xx][yy][0]-1;  // move it down  one
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
      delay(30); // this moves pretty fast
    }
    clearCube();    // clear the cube
  }
#ifndef PICUBE
  delay(1000);
#endif
}
