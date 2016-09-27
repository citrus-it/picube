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

// This animation creates red, green, and blue boxes. Then it rolls one around  the edge of the cube around the X axis, one is rolled around the Y axis,
// and one is rolled around the Z axis.  Creates an interesting effect. 
#ifdef PICUBE
void FlyingBoxes() {
  sprite s = sprite_create(3, 3, 3);
  sprite_colorIt(s, Green);
  sprite_place(s, 3, 5, 3);
  sprite_setIt(s);
  sprite_motion(s, 2, 1, 1);

  sprite s2 = sprite_create(3, 3, 3);
  sprite_colorIt(s2, Red);
  sprite_place(s2, 0, 3, 2);
  sprite_setIt(s2);
  sprite_motion(s2, 2, 1, 1);

  sprite s3 = sprite_create(3, 3, 3);
  sprite_colorIt(s3, Blue);
  sprite_place(s3, 4, 2, 4);
  sprite_setIt(s3);
  sprite_motion(s3, 2, 1, 1);

  for (count=0; count<250; count++) { // loop around 100 times
    sprite_rollX(s, 1);
    sprite_rollZ(s2, 1);
    sprite_rollY(s3, 0);
    delay(100); // wait 1/10th second before next move.
  } 
  sprite_clearIt(s);
  sprite_clearIt(s2);
  sprite_clearIt(s3);
  sprite_delete(s);
  sprite_delete(s2);
  sprite_delete(s3);
}
#else
void FlyingBoxes() {
  sprite mySprite(3,3,3); // this creates a sprite called mySprite with  dimensions 2x2x2 LEDs.
  mySprite.colorIt(Green);
  mySprite.place = {3,5,3}; // locate it in the lower, back corner of the cube
  mySprite.setIt(); // actually puts it in the cube, turning on the LEDs. 
  mySprite.motion = {2,1,1}; // gives my sprite an initial direction of motion
  
  sprite mySprite2(3,3,3); // this creates a sprite called mySprite with  dimensions 2x2x2 LEDs.
  mySprite2.colorIt(Red);
  mySprite2.place = {0,3,2}; // locate it in the lower, back corner of the  cube
  mySprite2.setIt(); // actually puts it in the cube, turning on the LEDs. 
  mySprite2.motion = {2,1,1}; // gives my sprite an initial direction of  motion
  
  sprite mySprite3(3,3,3); // this creates a sprite called mySprite with  dimensions 2x2x2 LEDs.
  mySprite3.colorIt(Blue);
  mySprite3.place = {4,2,4}; // locate it in the lower, back corner of the  cube
  mySprite3.setIt(); // actually puts it in the cube, turning on the LEDs. 
  mySprite3.motion = {2,1,1}; // gives my sprite an initial direction of  motion
  
  for (count=0; count<250; count++) { // loop around 100 times
    mySprite.rollX(1); 
    mySprite2.rollZ(1); 
    mySprite3.rollY(0); 
    delay(100); // wait 1/10th second before next move.
  } 
  mySprite.clearIt(); // turn off the sprite since we're done.
  mySprite2.clearIt(); // turn off the sprite since we're done.
  mySprite3.clearIt(); // turn off the sprite since we're done.
  delay(1000);
}
#endif

