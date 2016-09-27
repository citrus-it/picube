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

/*
This is the new and improved Helicopter!  It takes advantage of the fact that  sprites
can now be up to 6x6x6.   It's now 6x6x4 while the old one was 4x4x4.   
The main roter is bigger and actually rotates now. And the tail is longer, so  it actually
looks a little more like a helicopter.  There are actually three different  subroutines
here working on the sprite, so it is created globally, outside of any of them.   This is
very wasteful of RAM, but I have enough because I have been very careful in  all the other 
animations to dispose of sprites when they are finished with. I guess I could  have done that
here too. but it's not that easy to create. Also, I would need some global  variable to keep track
of where it is as its flying around if I kept distroying it (and losing its  position) after every
subroutine. 

And thanks to David Yee for some minor improvements which are now included here. 
*/
#ifdef PICUBE

void rotor(sprite heli, int delayx){  // makes the rotor rotate
  static int rot = 1;

  switch(rot){
  case 1:
    heli->description[0][3][0]=Black;
    heli->description[0][3][1]=Black;
    heli->description[0][3][2]=Black;
    heli->description[0][2][3]=Black;
    heli->description[0][2][4]=Black;
    heli->description[0][2][5]=Black;
    heli->description[0][0][0]=White;
    heli->description[0][1][1]=White;
    heli->description[0][2][2]=White;
    heli->description[0][3][3]=White;
    heli->description[0][4][4]=White;
    heli->description[0][5][5]=White;
    rot=2; 
    break; 
  case 2:
    heli->description[0][0][0]=Black;
    heli->description[0][1][1]=Black;
    heli->description[0][2][2]=Black;
    heli->description[0][3][3]=Black;
    heli->description[0][4][4]=Black;
    heli->description[0][5][5]=Black;
    heli->description[0][5][3]=White;
    heli->description[0][4][3]=White;
    heli->description[0][3][3]=White;
    heli->description[0][2][2]=White;
    heli->description[0][1][2]=White;
    heli->description[0][0][2]=White;
    rot=3;
    break; 
  case 3:
    heli->description[0][5][3]=Black;
    heli->description[0][4][3]=Black;
    heli->description[0][3][3]=Black;
    heli->description[0][2][2]=Black;
    heli->description[0][1][2]=Black;
    heli->description[0][0][2]=Black;
    heli->description[0][5][0]=White;
    heli->description[0][4][1]=White;
    heli->description[0][3][2]=White;
    heli->description[0][2][3]=White;
    heli->description[0][1][4]=White;
    heli->description[0][0][5]=White;
    rot=4;
    break; 
  case 4:
    heli->description[0][5][0]=Black;
    heli->description[0][4][1]=Black;
    heli->description[0][3][2]=Black;
    heli->description[0][2][3]=Black;
   heli->description[0][1][4]=Black;
    heli->description[0][0][5]=Black;
    heli->description[0][3][0]=White;
    heli->description[0][3][1]=White;
    heli->description[0][3][2]=White;
    heli->description[0][2][3]=White;
    heli->description[0][2][4]=White;
    heli->description[0][2][5]=White;
    rot=1;
    break; 
  }
  sprite_setIt(heli);
  delay(delayx);
}

void blinkRed(sprite heli){  // turns tail light on if off, or off if on. 
  static int blinkMe = 0;

  if (!heli)
  {
	blinkMe = 0;
	return;
  }

  if (blinkMe==0){
    blinkMe = 1;
    heli->description[1][2][5]=Blue;
    heli->description[1][3][5]=Blue;
  }
  else {
    blinkMe = 0;
    heli->description[1][2][5]=Red;
    heli->description[1][3][5]=Red;
  }
}
void Helicopter(){
  sprite heli = sprite_create(6, 6, 4);
  byte d[6][6][6] = {  // define the shape and color of the helicopter. 
    {  // top layer
      {
        White,  Black, Black, Black, Black, Black          }
      , // 1st column,  6 panels 
      {
        Black,  White, Black, Black, Black, Black                 }
      , // 2nd column,  6 panels
      {
        Black,  Black, White, Black , Black, Black                  }
      , // 3rd column,  6 panels
      {
        Black,  Black, Black, White , Black, Black               }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black , White, Black               }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black , Black, White               }
      , // 6th column,  6 panels
    }
    ,
    {  // 1st middle layer 
      {
        Black,  Black, Black, Black, Black, Black              }
      , // 1st column,  6panels 
      {
        Black, Black, Black, Black, Black, Black             }
      , // 2nd column,  6 panels
      {
        Black,  Blue, Blue, Blue, Blue, Blue             }
      , // 3rd column,  6 panels
      {
        Black,  Blue, Blue, Blue, Blue, Blue                  }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black                  }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black                  }
      , // 6th column,  6 panels
    }
    ,
    {  // 2nd middle layer
      {
        Black,  Black, Black, Black, Black, Black                }
      , // 1st column,  6 panels 
      {
        Black,  Black, Black, Black, Black, Black               }
      , // 2nd column,  6 panels
      {
        Black,  Blue, Blue, Black, Black, Black              }
      , //// 3rd column,  6 panels
      {
        Black,  Blue, Blue, Black, Black, Black              }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black              }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black              }
      ,// 6th column,  6 panels
    }
    ,
    {  // bottom layer
      {
        Black,  Black, Black, Black, Black, Black                 }
      , // 1st column,  6 panels 
      {
        Black,  Black, Black, Black, Black, Black           }
      , // 2nd column,  6 panels
      {
        Blue,  Black, Blue, Black, Black, Black                }
      , // 3rd column,  6 panels
      {
        Blue,  Black, Blue, Black, Black, Black               }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black               }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black               }
      , // 6th column,  6 panels
    }
    ,
  };

  sprite_description(heli, d);
  sprite_place(heli, 2, 2, 0);
  sprite_motion(heli, 1, -1, 1);
  sprite_setIt(heli);

  delay(1000);
  for (int count=0; count<6; count++){  // make the tail light blink
    blinkRed(heli);
    sprite_setIt(heli);
    delay(500);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 160);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 140);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 120);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 100);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 80);
  }  
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 50);
  }    
  for (int count=0; count<40; count++){  // now the helicopter is flying
    sprite_bounceIt(heli);
    blinkRed(heli);
    rotor(heli, 40);
    rotor(heli, 40);
    rotor(heli, 40);
    rotor(heli, 40);
    rotor(heli, 40);
    blinkRed(heli);
    rotor(heli, 40);
    rotor(heli, 40);
    rotor(heli, 40);
    rotor(heli, 40);
    rotor(heli, 40);
  }
  if (heli->description[0][3][0]==Black){  // now it's landing
    rotor(heli, 50);  
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 80);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 120);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 140);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(heli); 
    sprite_setIt(heli);
    rotor(heli, 160);
  }
  for (int count=0; count<5; count++){  // rotor stops but tail light still  blinks
    blinkRed(heli);
    sprite_setIt(heli);
    delay(500);
  }
  delay(1000);  // blinking stops 
  blinkRed(NULL);
  clearCube();  // done - clear the cube
  sprite_delete(heli);
}

#else

sprite heli(6,6,4);  // Our sprite is 6 x 6 x 4.
void Helicopter(){
  heli.place = {  // set up its initial location
    2,2,0          };
  heli.motion = {  // set up its initial motion
    1,-1, 1          };
  heli.description = {  // define the shape and color of the helicopter. 
    {  // top layer
      {
        White,  Black, Black, Black, Black, Black          }
      , // 1st column,  6 panels 
      {
        Black,  White, Black, Black, Black, Black                 }
      , // 2nd column,  6 panels
      {
        Black,  Black, White, Black , Black, Black                  }
      , // 3rd column,  6 panels
      {
        Black,  Black, Black, White , Black, Black               }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black , White, Black               }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black , Black, White               }
      , // 6th column,  6 panels
    }
    ,
    {  // 1st middle layer 
      {
        Black,  Black, Black, Black, Black, Black              }
      , // 1st column,  6panels 
      {
        Black, Black, Black, Black, Black, Black             }
      , // 2nd column,  6 panels
      {
        Black,  Blue, Blue, Blue, Blue, Blue             }
      , // 3rd column,  6 panels
      {
        Black,  Blue, Blue, Blue, Blue, Blue                  }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black                  }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black                  }
      , // 6th column,  6 panels
    }
    ,
    {  // 2nd middle layer
      {
        Black,  Black, Black, Black, Black, Black                }
      , // 1st column,  6 panels 
      {
        Black,  Black, Black, Black, Black, Black               }
      , // 2nd column,  6 panels
      {
        Black,  Blue, Blue, Black, Black, Black              }
      , //// 3rd column,  6 panels
      {
        Black,  Blue, Blue, Black, Black, Black              }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black              }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black              }
      ,// 6th column,  6 panels
    }
    ,
    {  // bottom layer
      {
        Black,  Black, Black, Black, Black, Black                 }
      , // 1st column,  6 panels 
      {
        Black,  Black, Black, Black, Black, Black           }
      , // 2nd column,  6 panels
      {
        Blue,  Black, Blue, Black, Black, Black                }
      , // 3rd column,  6 panels
      {
        Blue,  Black, Blue, Black, Black, Black               }
      , // 4th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black               }
      , // 5th column,  6 panels
      {
        Black,  Black, Black, Black, Black, Black               }
      , // 6th column,  6 panels
    }
    ,
  };
   heli.setIt();  // display helicopter
  delay(1000);
  for (int count=0; count<6; count++){  // make the tail light blink
    blinkRed();
    heli.setIt();
    delay(500);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(160);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(140);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(120);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(100);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(80);
  }  
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(50);
  }    
  for (int count=0; count<40; count++){  // now the helicopter is flying
    heli.bounceIt();
    blinkRed();
    rotor(40);
    rotor(40);
    rotor(40);
    rotor(40);
    rotor(40);
    blinkRed();
    rotor(40);
    rotor(40);
    rotor(40);
    rotor(40);
    rotor(40);
  }
  if (heli.description[0][3][0]==Black){  // now it's landing
    rotor(50);  
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(80);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(120);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(140);
  }
  for (int count=0; count<5; count++){  // start the rotor turning
    blinkRed(); 
    heli.setIt();
    rotor(160);
  }
  for (int count=0; count<5; count++){  // rotor stops but tail light still  blinks
    blinkRed();
    heli.setIt();
    delay(500);
  }
  delay(1000);  // blinking stops 
  blinkMe=0;
  clearCube();  // done - clear the cube
  delay(1000);
}

void rotor(int delayx){  // makes the rotor rotate
  switch(rot){
  case 1:
    heli.description[0][3][0]=Black;
    heli.description[0][3][1]=Black;
    heli.description[0][3][2]=Black;
    heli.description[0][2][3]=Black;
    heli.description[0][2][4]=Black;
    heli.description[0][2][5]=Black;
    heli.description[0][0][0]=White;
    heli.description[0][1][1]=White;
    heli.description[0][2][2]=White;
    heli.description[0][3][3]=White;
    heli.description[0][4][4]=White;
    heli.description[0][5][5]=White;
    rot=2; 
    break; 
  case 2:
    heli.description[0][0][0]=Black;
    heli.description[0][1][1]=Black;
    heli.description[0][2][2]=Black;
    heli.description[0][3][3]=Black;
    heli.description[0][4][4]=Black;
    heli.description[0][5][5]=Black;
    heli.description[0][5][3]=White;
    heli.description[0][4][3]=White;
    heli.description[0][3][3]=White;
    heli.description[0][2][2]=White;
    heli.description[0][1][2]=White;
    heli.description[0][0][2]=White;
    rot=3;
    break; 
  case 3:
    heli.description[0][5][3]=Black;
    heli.description[0][4][3]=Black;
    heli.description[0][3][3]=Black;
    heli.description[0][2][2]=Black;
    heli.description[0][1][2]=Black;
    heli.description[0][0][2]=Black;
    heli.description[0][5][0]=White;
    heli.description[0][4][1]=White;
    heli.description[0][3][2]=White;
    heli.description[0][2][3]=White;
    heli.description[0][1][4]=White;
    heli.description[0][0][5]=White;
    rot=4;
    break; 
  case 4:
    heli.description[0][5][0]=Black;
    heli.description[0][4][1]=Black;
    heli.description[0][3][2]=Black;
    heli.description[0][2][3]=Black;
   heli.description[0][1][4]=Black;
    heli.description[0][0][5]=Black;
    heli.description[0][3][0]=White;
    heli.description[0][3][1]=White;
    heli.description[0][3][2]=White;
    heli.description[0][2][3]=White;
    heli.description[0][2][4]=White;
    heli.description[0][2][5]=White;
    rot=1;
    break; 
  }
  heli.setIt();
  delay(delayx);
}

void blinkRed(){  // turns tail light on if off, or off if on. 
  if (blinkMe==0){
    blinkMe = 1;
    heli.description[1][2][5]=Blue;
    heli.description[1][3][5]=Blue;
  }
  else {
    blinkMe = 0;
    heli.description[1][2][5]=Red;
    heli.description[1][3][5]=Red;
  }
}
#endif
