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

/* Atom Smasher is a simple animation where two "particles" moving in the Atom table positions
   eventual collide in an explosion. 
 */


void show_sphere3(){ // draw the sphere and change its color
  getColor(White,4);
  float polar;
  for (int layer=0; layer<8; layer++){  // scan thru each layer
    for (byte column=0; column<8; column++){  // scan thru every column
      for (byte panel=0; panel<8; panel++){  // scan thru every panel
        x= float(layer); // convert coordinates to floating point to compute distance from center of cube
        y=float(panel); 
        z= float(column); 
        polar = sqrt((x-4)*(x-4)+(y-6)*(y-6)+(z-6)*(z-6)); // Calculate the distance
        if (polar<count && column<8 && panel<8 && layer >-1 && layer<8){ // if an LED is inside the radius specified by count, turn it on. 
          LED(column, panel, layer, myred, mygreen, myblue);
        }
      }
    }
  }
}

void explode(){  
  for (count=0; count<9; count++){  //expand
    show_sphere3();
  }
  clearCube();
  getColor(White,1);
  for (int p=0; p<20; p++){
    LED(random(3)+3,random(3)+3,random(3)+3,myred, mygreen, myblue);
  }
  for (int p=0; p<7; p++){
  delay(200);
  zdown (1);
  }
}

void atomSmasher(){
  mycolor=0;
  for (int j=0; j<5; j++){
    for(int k=0; k<2; k++){
      for (int i=0; i<20; i++) {
        getColor(mycolor+80,4);
        LED(atomTable[19-i][0],atomTable[19-i][1],0,myred, mygreen, myblue);
        delay(30);
        LED(atomTable[19-i][0],atomTable[19-i][1],0,0,0,0);
      }
    }
    for (int z=15; z>8; z--) {
      for (int i=0; i<20; i++) {
        getColor(mycolor,4);
        LED(atomTable[i][0],atomTable[i][1],z/2,myred, mygreen, myblue);
       
        getColor(mycolor+80,4);
        LED(atomTable[19-i][0],atomTable[19-i][1],8-z/2,myred, mygreen, myblue);
        delay(30);
        if (i==9 && z==9){
          explode();
          break;
        }
        LED(atomTable[i][0],atomTable[i][1],z/2,0,0,0);
        LED(atomTable[19-i][0],atomTable[19-i][1],8-z/2,0,0,0);
      }
    }
    mycolor=mycolor+20;
    if (mycolor>189) {mycolor=0;}
    delay(500);
  }
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
}

