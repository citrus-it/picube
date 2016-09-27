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

#ifdef PICUBE
#define duration 20
static int cyclone[duration+1][3];

void cyclone1(void);
#endif

void Cyclone(){
    for (int mycolors=0; mycolors<190; mycolors= mycolors+15){ //get a color  from color wheel
      int color2= mycolors+95;  // get a color from the opposite side of color  wheel
      if (color2>189){
        color2=color2-189;
      }
      getColor(mycolors, 4);  // set up the top layer with these colors
      cyclone[0][0]=myred;
      cyclone[0][1]=mygreen;
      cyclone[0][2]=myblue;
      cyclone[1][0]=myred;
      cyclone[1][1]=mygreen;
      cyclone[1][2]=myblue;
      getColor(color2, 4);
      cyclone[10][0]=myred;
      cyclone[10][1]=mygreen;
      cyclone[10][2]=myblue;
      cyclone[11][0]=myred;
      cyclone[11][1]=mygreen;
      cyclone[11][2]=myblue;
      for (int count=0; count<duration; count++){ // send them through a full  rotation
        cyclone1();
      }
    }
    clearCube();
#ifndef PICUBE
     delay(1000);
#endif
  }

void cyclone1(){  // actually display in LEDs
  LED (4,0,7,cyclone[0][0],cyclone[0][1],cyclone[0][2]);
  LED (3,0,7,cyclone[1][0],cyclone[1][1],cyclone[1][2]);
  LED (2,1,7,cyclone[2][0],cyclone[2][1],cyclone[2][2]);
  LED (1,1,7,cyclone[3][0],cyclone[3][1],cyclone[3][2]);
  LED (1,2,7,cyclone[4][0],cyclone[4][1],cyclone[4][2]);
  LED (0,3,7,cyclone[5][0],cyclone[5][1],cyclone[5][2]);
  LED (0,4,7,cyclone[6][0],cyclone[6][1],cyclone[6][2]);
  LED (1,5,7,cyclone[7][0],cyclone[7][1],cyclone[7][2]);
  LED (1,6,7,cyclone[8][0],cyclone[8][1],cyclone[8][2]);
  LED (2,6,7,cyclone[9][0],cyclone[9][1],cyclone[9][2]);
  LED (3,7,7,cyclone[10][0],cyclone[10][1],cyclone[10][2]);
  LED (4,7,7,cyclone[11][0],cyclone[11][1],cyclone[11][2]);
  LED (5,6,7,cyclone[12][0],cyclone[12][1],cyclone[12][2]);
  LED (6,6,7,cyclone[13][0],cyclone[13][1],cyclone[13][2]);
  LED (6,5,7,cyclone[14][0],cyclone[14][1],cyclone[14][2]);
  LED (7,4,7,cyclone[15][0],cyclone[15][1],cyclone[15][2]);
  LED (7,3,7,cyclone[16][0],cyclone[16][1],cyclone[16][2]);
  LED (6,2,7,cyclone[17][0],cyclone[17][1],cyclone[17][2]);
  LED (6,1,7,cyclone[18][0],cyclone[18][1],cyclone[18][2]);
  LED (5,1,7,cyclone[19][0],cyclone[19][1],cyclone[19][2]);
  
  for (int x=0;x<8;x++){ // copy content of each layer to the layer below it.
    for (int y=0;y<8;y++){
      for (int z=1;z<8;z++){
#ifdef PICUBE
 	copyLED(x, y, z, x, y, z-1);
#else
        for (int c=0;c<3;c++){
          cube [x][y][z-1][c] = cube [x][y][z][c];
        }
#endif
      }
    }
  }
 
  for (int counter=duration-1; counter>-1; counter--){ // rotate the content  in the cyclone matrix by one
    cyclone[counter+1][0]=cyclone[counter][0];
    cyclone[counter+1][1]=cyclone[counter][1];
    cyclone[counter+1][2]=cyclone[counter][2];
  }
  cyclone[0][0]=cyclone[duration][0];
  cyclone[0][1]=cyclone[duration][1];
  cyclone[0][2]=cyclone[duration][2]; 

  delay (55);  // wait 55 msec before moving to next position. 
}
