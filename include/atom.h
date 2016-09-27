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

// this little table describes the columns in which Atom and Atom Smasher operates
byte atomTable[20][2] = {
   {2,0  },{3,0  },{4,0  },{5,0  },{6,1  },{7,2  },{7,3  },{7,4  },{7,5  },{6,6  },
   {5,7  },{4,7  },{3,7  },{2,7  },{1,6  },{0,5  },{0,4  },{0,3  },{0,2  },{1,1  }
  , };

