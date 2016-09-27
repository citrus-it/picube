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

// In this demo we are rotating a simple sprite around itself.  There is one  restriction that must
// be observed.  The sprite must have equal dimensions in the plane in which  its rotating, i.e. if we are 
// going to use rotateX on a sprite, that sprites Y and Z dimensions must be  equal.  See Sprite1 as an
// example. 
#ifdef PICUBE
void Eyes() { 
  int mydelay = 200;
  sprite s = sprite_create(4, 4, 4);
  
  byte description[6][6][6] = {  // just a simple red green green line across 3  layers
		    {  // top layer
			{Black,  Black, Black, Black}, // 1st column,  4  panels 
			{Black,  Red, Red, Black}, // 2nd column,  4 panels
			{Black,  Red, Red, Black}, // 3rd column,  4 panels
                        {Black,  Black, Black, Black}, // 4th column,  4  panels
		    },
		    {  // middle layer
			{Black,  Red, Red, Black}, // 1st column,  4 panels 
			{Red,  Red, Red, Red}, // 2nd column,  4 panels
			{Red,  Red, Red, Red}, // 3rd column,  4 panels
                        {Black,  Red, Red, Black}, // 4th column,  4 panels
		    },
                    {  // 2nd middle layer
			{Black,  Red, Red, Black}, // 1st column,  4 panels 
			{Red,  Red, Red, Red}, // 2nd column,  4 panels
			{Red,  Red, Red, Red}, // 3rd column,  4 panels
                        {Black,  Red, Red, Black}, // 4th column,  4 panels
		    },
	            {  // bottom layer
			{Black,  Black, Black, Black}, // 1st column,  4  panels 
			{Black,  Red, Red, Black}, // 2nd column,  4 panels
			{Black,  Red, Red, Black}, // 3rd column,  4 panels
                        {Black,  Black, Black, Black}, // 4th column,  4  panels
		    },
		 };
  description[1][1][0] = Blue;
  description[1][2][0] = Blue;

  sprite_place(s, 0, 0, 3);
  sprite_motion(s, 1, 2, -1);
  sprite_description(s, description);

    for (int count=0; count<100; count++){
      sprite_rollZ(s, 0);
      if (count%4 == 0){
        sprite_rotateZ(s, 1);
      }
    delay(mydelay);
  }
  sprite_clearIt(s);
  sprite_delete(s);
}
#else
void Eyes() { 
  int mydelay = 200;
  sprite Sprite1(4,4,4);  // X and Y dimensions must be equal if we are going  to rotate around Z axis.   
  Sprite1.place = {0,0,3};
  Sprite1.motion = {1,2, -1};
  Sprite1.description = {  // just a simple red green green line across 3  layers
		    {  // top layer
			{Black,  Black, Black, Black}, // 1st column,  4  panels 
			{Black,  Red, Red, Black}, // 2nd column,  4 panels
			{Black,  Red, Red, Black}, // 3rd column,  4 panels
                        {Black,  Black, Black, Black}, // 4th column,  4  panels
		    },
		    {  // middle layer
			{Black,  Red, Red, Black}, // 1st column,  4 panels 
			{Red,  Red, Red, Red}, // 2nd column,  4 panels
			{Red,  Red, Red, Red}, // 3rd column,  4 panels
                        {Black,  Red, Red, Black}, // 4th column,  4 panels
		    },
                    {  // 2nd middle layer
			{Black,  Red, Red, Black}, // 1st column,  4 panels 
			{Red,  Red, Red, Red}, // 2nd column,  4 panels
			{Red,  Red, Red, Red}, // 3rd column,  4 panels
                        {Black,  Red, Red, Black}, // 4th column,  4 panels
		    },
	            {  // bottom layer
			{Black,  Black, Black, Black}, // 1st column,  4  panels 
			{Black,  Red, Red, Black}, // 2nd column,  4 panels
			{Black,  Red, Red, Black}, // 3rd column,  4 panels
                        {Black,  Black, Black, Black}, // 4th column,  4  panels
		    },
		 };
  Sprite1.description[1][1][0] = Blue;
  Sprite1.description[1][2][0] = Blue;

    for (int count=0; count<100; count++){
      Sprite1.rollZ(0);
      if (count%4 == 0){
        Sprite1.rotateZ(1);
      }
    delay(mydelay);
  }
  Sprite1.clearIt();
  delay(1000);
}
#endif

