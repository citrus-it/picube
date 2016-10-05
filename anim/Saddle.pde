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

// This is a rotating saddle or hyperbolic paraboloid.  It was originally suppose
// to increase and decrease in amplitude as it rotated.  But I forgot to clear
// the buffer_cube array after each rotation and the result was a cool mixture
// of colors.  I decided to leave it that way.  If you uncomment the clear
// buffer_cube you will see another version, but I like this better. 
void saddle(){
  float myZ; 
  int z; 
#ifdef PICUBE
  clearBufferCube();
#endif
  manage_color();
  for (int j=0; j<5; j++){
    for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(3+j));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(1, 10);
  //  clearBufferCube();
  }
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
  //  clearBufferCube();
  }
    for (int j=0; j<5; j++){
    for (byte x=0; x<8; x++){  // scan thru each x
      for (byte y=0; y<8; y++){  // scan thru every y
        myZ= (x-3.5)*(x-3.5)-(y-3.5)*(y-3.5);
        z= int(3.5 +(myZ)/(3+j));
        buffer_LED(x,y,z,myred, mygreen, myblue);
      }
    }
    manage_color(); 
    rotateCube(1, 10);
  //  clearBufferCube();
  }
  clearCube();
  clearBufferCube();
#ifndef PICUBE
  delay(1000);
#endif
}
