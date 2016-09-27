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

/* Suppose your cube was a sub-atomic particle detector, capable of
   displaying the tracks of neutrinos zipping around everywhere. Watch
   as a burst of neutrinos reaches your cube.  */

void zing(int x, int y, int z, int xm, int ym, int zm, int mycolor) {
  getColor(mycolor,4);
  int newx=x, newy=y, newz=z;
  for (int p=0; p<8; p++) {
    if (newx>-1 && newx<8 && newy>-1 && newy<8 && newz>-1 && newz<8) {
      LED(newx,newy,newz,myred, mygreen, myblue);
      delay(25);
      LED(newx,newy,newz,0, 0, 0);
    }
    newx=newx+xm; 
    newy=newy+ym; 
    newz=newz+zm; 
  }
  delay(random(2000/(counter*3+1)));
}

void neutrinos(){
  counter=0;
  zing(4, 7, 7, 0,-1,-1,White);
  delay(1000);
  for (int q=0; q<25;q++){
    if (q<13) {counter++;}
    else {counter--;}
    zing(0, 5, 5, 1,1,-1,White);
    zing(0, 7, 1, 1,-1,1,Blue);
    zing(4, 7, 7, 0,-1,-1,Green);
    zing(5, 0, 6, 0,1,-1,Purple);
    zing(0, 0, 0, 1,1,1,Aqua);
    zing(7, 1, 7, -1, 1,-1,White);
    zing(0, 5, 5, 1,1,-1,White);
    zing(2, 0, 0, 1,1,1,Orange);
    zing(2, 7, 1, 1,-1,1,Blue);
    zing(6, 7, 2, 0,-1,1,Purple);
    zing(6, 0, 6, -1,1,-1,Red);
    zing(2, 5, 7, 1, 1,-1,White);
    zing(3, 2, 7, 0, 0,-1,Yellow);
  }
  delay(1000);
  zing(4, 7, 7, 0,-1,-1,White);
#ifndef PICUBE
  delay(1000);
#endif
}

