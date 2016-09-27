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

// This table gives us coordinates to smoothly move from a side to the diagonal
byte diagonal[8][8] = {
  {0,0,0,0,0,0,0,0,        },
  {0,0,0,0,1,1,1,1,        },
  {0,0,0,1,1,2,2,2,        },
  {0,0,1,1,2,2,2,3,        },
  {0,1,1,2,2,3,3,4,        },
  {0,1,2,2,3,3,4,5,        },
  {0,1,2,3,3,4,5,6,        },
  {0,1,2,3,4,5,6,7,        }
};

