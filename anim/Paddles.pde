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

/*  Paddles basically steals from two other animations.  It uses the 
    same separate color drivers as the Swings animation, and it is based
    on the Simple_Rotation scheme introduced in template verson 5, where
    we were rotating a red arrow. In this version, we changed the arrow
    and inverted what is lit up creating something like a frame with  
    a hollow center.  Then for each color, we rotate around a different
    axis.  */
void paddles(){
  int rotations=1, mydelay=35;
  // This is a pattern to be rotated. It can be anything fitting in an 8x8 panel.
  // But for this animation, we are displaying its inverse, so red is dark. 
  int const myPattern[8][8]  = {
    {Black,Black,Black,Black,Black,Black,Black,Black,  }, 
    {Black,Black,Red,Red,Red,Red,Black,Black,      }, 
    {Black,Red,Red,Red,Red,Red,Red,Black,      },
    {Black,Red,Red,Black,Black,Red,Red,Black,   },
    {Black,Red,Red,Black,Black,Red,Red,Black, },
    {Black,Red,Red,Red,Red,Red,Red,Black,      },
    {Black,Black,Red,Red,Red,Red,Black,Black,      },
    {Black,Black,Black,Black,Black,Black,Black,Black,  },  
  };
  // This is the table that tells Y how to move for each X as we move though 45 degrees. 
  int const table[32] = {
    0,1,2,3,4,5,6,7,1,1,2,3,4,5,6,6,2,2,3,3,4,4,5,5,3,3,3,3,4,4,4,4  };
  for (int j=0; j<35; j++){  
    if (j>5) {mydelay = 45;}
    if (j>10) {mydelay = 55;}
    if (j>24) {mydelay = 45;}
    if (j>29) {mydelay = 35;}
  for (int x =0; x<rotations; x++){  // move first 45 degrees
    for (int count=0; count<4; count++){
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
          if (myPattern[layer][x]>0){
            if (j<25){
            RedLED(x,table[count*8+x],layer);}
            if (j>5 && j<30){ 
            GreenLED(layer,x,table[count*8+x]);}
            if (j>10){
            BlueLED(table[count*8+x],layer,x);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }
    for (int count=0; count<4; count++){  // move second 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
         if (myPattern[layer][x]>0){
           if (j<25){
            RedLED(x,table[31-(count*8+x)],layer);}
           if (j>5 && j<30){  
            GreenLED(layer,x,table[31-(count*8+x)]);}  
           if (j>10){
            BlueLED(table[31-(count*8+x)],layer, x);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }

    for (int count=1; count<4; count++){  // move third 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
          if (myPattern[layer][x]>0){  //???
           if (j<25){
            RedLED(table[count*8+x],7-x,layer);}
            if (j>5 && j<30){  
            GreenLED(layer,table[count*8+x],7-x);}
            if (j>10){
            BlueLED(7-x,layer,table[count*8+x]);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }

    for (int count=0; count<3; count++){  // move fourth 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
          if (myPattern[layer][x]>0){
            if (j<25){
            RedLED(table[31-(count*8+x)],7-x,layer);}
            if (j>5 && j<30){ 
            GreenLED(layer,table[31-(count*8+x)],7-x);}
            if (j>10){
            BlueLED(7-x,layer,table[31-(count*8+x)]);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }

    for (int count=0; count<4; count++){  // move fifth 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
          if (myPattern[layer][x]>0){
           if (j<25){
            RedLED(x,table[count*8+x],layer);}
           if (j>5 && j<30){  
            GreenLED(layer,x,table[count*8+x]);}
            if (j>10){
            BlueLED(table[count*8+x],layer,x);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }

    for (int count=1; count<4; count++){  // move sixth 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
          if (myPattern[layer][x]>0){
            if (j<25){
            RedLED(x,table[31-(count*8+x)],layer);}
            if (j>5 && j<30){ 
            GreenLED(layer,x,table[31-(count*8+x)]);}
           if (j>10){
            BlueLED(table[31-(count*8+x)],layer,x);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }

    for (int count=1; count<4; count++){  // move seventh 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
         if (myPattern[layer][x]>0){
            if (j<25){
            RedLED(table[count*8+x],7-x,layer);}
            if (j>5 && j<30){  
            GreenLED(layer,table[count*8+x],7-x);}
           if (j>10){
            BlueLED(7-x,layer,table[count*8+x]);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }
    for (int count=0; count<3; count++){  // move last 45 degrees
      for (int layer=0; layer<8; layer++){
        for (int x=0; x<8; x++){
          if (myPattern[layer][x]>0){
            if (j<25){
            RedLED(table[31-(count*8+x)],7-x,layer);}
            if (j>5 && j<30){ 
            GreenLED(layer,table[31-(count*8+x)],7-x);}
            if (j>10){
            BlueLED(7-x,layer,table[31-(count*8+x)]);}
          }
        }
      }
      delay(mydelay);
      clearCube();
    }
  }
  }
  clearCube();
#ifndef PICUBE
  delay(1000);
#endif
}
