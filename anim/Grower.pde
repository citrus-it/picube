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

//  This animatin is  based on the grow routine below that builds boxes
//  We create a bunch of interesting effects by rapidly changing the boxes. 

// this routine builds the outline of a box in the center of the cube.  
//  You can specify is size, color and how long it exists. 
//  
void grow(int sz, int color, int time){
 getColor(color, 4);
 for (int x=growTable[sz][0]; x<growTable[sz][1]+1; x++){
   for (int y=growTable[sz][0]; y<growTable[sz][1]+1; y++){
     for (int z=growTable[sz][0]; z<growTable[sz][1]+1; z++){
       LED(x,y,z,myred, mygreen, myblue);
     }
   }
 }
 if (sz>0){
   for (int x=growTable[sz][2]; x<growTable[sz][3]+1; x++){
     for (int y=growTable[sz][2]; y<growTable[sz][3]+1; y++){
       for (int z=growTable[sz][2]; z<growTable[sz][3]+1; z++){
         LED(x,y,z,0, 0, 0);
       }
     }
   }
 }
 delay(time);
}

void grower(){
  for (int q=0; q<15; q++){
    mycolor=mycolor+10;
    if(mycolor>189){mycolor=0;}
    grow(0, mycolor, 100); 
    grow(1, mycolor, 100); 
    grow(2, mycolor, 100); 
    grow(3, mycolor, 100); 
    delay(100);
    mycolor=mycolor+10;
    if(mycolor>189){mycolor=0;} 
    grow(2, mycolor, 100); 
    grow(1, mycolor, 100); 
    grow(0, mycolor, 100); 
    delay(100);
    if (q%2) {clearCube();}
  }
  for (int q=0; q<15; q++){
    if (q%2){mycolor=85;}
    else {mycolor=0;}
    grow(0, mycolor, 100); 
    grow(1, mycolor, 100); 
    grow(2, mycolor, 100); 
    grow(3, mycolor, 100); 
    delay(100);
    grow(2, mycolor, 100); 
    grow(1, mycolor, 100); 
    grow(0, mycolor, 100); 
    delay(100);
    if (q%2==1){
      clearCube();}
  }
    for (int q=0; q<15; q++){
    mycolor=White;
    grow(0, mycolor, 100); 
    grow(1, mycolor, 50); 
    grow(2, mycolor, 50); 
    grow(3, mycolor, 100); 
    clearCube();
    grow(2, mycolor, 50); 
    clearCube();
    grow(1, mycolor, 50); 
    clearCube();
  }
#ifndef PICUBE
  delay(1000);
#endif
}

