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

void displayCube(int side, int x, int y, int z, int color){
#ifdef PICUBE
 sprite mySprite = sprite_create(side, side, side);
 sprite_outline(mySprite, color);
 sprite_place(mySprite, x, y, z);
 sprite_setIt(mySprite);
 delay(50);
 sprite_clearIt(mySprite);
 sprite_delete(mySprite);
#else
 sprite mySprite(side,side,side); 
 mySprite.outline(color);
 mySprite.place = {x,y,z};
 mySprite.setIt();
 delay(50);
 mySprite.clearIt();
#endif
}

void bounceCube(int side, int x, int y, int z, int color){
#ifdef PICUBE
 sprite mySprite = sprite_create(side, side, side);
 sprite_place(mySprite, x, y, z);
 sprite_motion(mySprite, 1, 2, -1);
#else
 sprite mySprite(side,side,side); 
 mySprite.place = {x,y,z};
 mySprite.motion = {1,2,-1}; // gives my sprite an initial direction of motion
#endif
  for (count=0; count<66; count++) { // loop around 100 times
    color=color+3;
    if (color>189){color=0;}
#ifdef PICUBE
    sprite_outline(mySprite, color);
    sprite_bounceIt(mySprite);
#else
    mySprite.outline(color);
    mySprite.bounceIt(); // move the sprite one increment. Reverse direction  if cube's edge is detected.
#endif
    delay(95); // wait 1/10th second before next move.
  } // finish the loop
#ifdef PICUBE
  sprite_clearIt(mySprite);
#else
  mySprite.clearIt(); // turn off the sprite since we're done. 
  sprite_delete(mySprite);
#endif
  delay(1000);
}

void CubeInCube(){ 
  for (int i=0; i<4; i++) {
    displayCube(6,1,1,1,Blue);
    displayCube(5,1,1,1,Blue+5);
    displayCube(4,1,1,1,Blue+10);
    displayCube(3,1,1,1,Blue+15);
    displayCube(2,1,1,1,Blue+20);
    displayCube(2,1,1,1,Blue+20);
    displayCube(2,1,1,1,Blue+20);
    displayCube(3,1,1,1,Blue+15);
    displayCube(4,1,1,1,Blue+10);
    displayCube(5,1,1,1,Blue+5);
    displayCube(6,1,1,1,Blue);
    displayCube(6,1,1,1,Blue);
  }
  for (int i=0; i<4; i++) {
    displayCube(6,1,1,1,Blue);
    displayCube(5,2,2,1,Blue-15);
    displayCube(4,3,3,1,Blue-30);
    displayCube(3,4,4,1,Blue-45);
    displayCube(2,5,5,1,Blue-60);
    displayCube(2,5,5,1,Blue-60);
    displayCube(2,5,5,1,Blue-60);
    displayCube(3,4,4,1,Blue-45);
    displayCube(4,3,3,1,Blue-30);
    displayCube(5,2,2,1,Blue-15);
    displayCube(6,1,1,1,Blue);
    displayCube(6,1,1,1,Blue);
  }
  for (int i=0; i<4; i++) {
    displayCube(6,1,1,1,Blue);
    displayCube(5,2,1,2,Blue+15);
    displayCube(4,3,1,3,Blue+30);
    displayCube(3,4,1,4,Blue+45);
    displayCube(2,5,1,5,Blue+60);
    displayCube(2,5,1,5,Blue+60);
    displayCube(2,5,1,5,Blue+60);
    displayCube(3,4,1,4,Blue+45);
    displayCube(4,3,1,3,Blue+30);
    displayCube(5,2,1,2,Blue+15);
    displayCube(6,1,1,1,Blue);
    displayCube(6,1,1,1,Blue);
  }
  for (int i=0; i<4; i++) {
    displayCube(6,1,1,1,Blue);
    displayCube(5,1,2,2,Blue-20);
    displayCube(4,1,3,3,Blue-40);
    displayCube(3,1,4,4,Blue-60);
    displayCube(2,1,5,5,Blue-80);
    displayCube(2,1,5,5,Blue-80);
    displayCube(2,1,5,5,Blue-80);
    displayCube(3,1,4,4,Blue-60);
    displayCube(4,1,3,3,Blue-40);
    displayCube(5,1,2,2,Blue-20);
    displayCube(6,1,1,1,Blue);
    displayCube(6,1,1,1,Blue);
  }
//  bounceCube(4,1,1,1,Blue);
  clearCube();
  delay(500);
  // This is where the flashing occurs. 
  for (int i=0; i<5; i++){
    //Turn everything ON to white
  for (byte layer=0; layer<8; layer++){  // scan thru each layer
    for (byte column=0; column<8; column++){  // scan thru every column
      for (byte panel=0; panel<8; panel++){  // scan thru every panel
#ifdef PICUBE
	LED(layer, panel, column, 31, 63, 63);
#else
        cube[layer][panel][column][0]=31;
        cube[layer][panel][column][1]=63;
        cube[layer][panel][column][2]=63;
#endif
      }
    }
  }
  delay(10);
  //Turn everything off.(Same as clearCube)
  clearCube();
  delay(390);
  }
#ifndef PICUBE
  delay(1000);
#endif
}


