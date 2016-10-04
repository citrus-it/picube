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

// This is the original version of the saddle routine where the clear buffer_cube
// is left in, giving our saddle a single slowly changing color. 
void saddle2(){
  float myZ; 
  int z; 
#ifdef PICUBE
    clearBufferCube();
#endif
  manage_color();
  for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(15));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(1, -10);
    clearBufferCube();
  for (int j=5; j>-1; j--){
    for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(3+j));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(1, -10);
    clearBufferCube();
  }
    for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(3));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(5, -10);
    clearBufferCube();
  
    for (int j=0; j<5; j++){
    for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(3+j));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(1, -10);
    clearBufferCube();
  }
 manage_color();
    for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(15));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(1, -10);
    clearBufferCube();
  clearCube();
  clearBufferCube();
#ifndef PICUBE
  delay(1000);
#endif
}
