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

// In this animation, we create a bunch of single LED sprites, then introduce  them one at a time
// bouncing around the inside of the cube.  

#ifdef PICUBE
void Single_Swirl() {
	sprite s[5];
	int i;

	for (i = 0; i < 5; i++)
		s[i] = sprite_create(2, 2, 2);

	sprite_colorIt(s[0], Yellow);
	sprite_colorIt(s[1], Green);
	sprite_colorIt(s[2], Blue);
	sprite_colorIt(s[3], Violet);
	sprite_colorIt(s[4], Orange);

	sprite_place(s[0], 5, 4, 3);
	sprite_place(s[1], 3, 4, 5);
	sprite_place(s[2], 2, 6, 3);
	sprite_place(s[3], 5, 1, 2);
	sprite_place(s[4], 1, 2, 3);

	sprite_motion(s[0], 1, -2, 1);
	sprite_motion(s[1], 1, 1, -2);
	sprite_motion(s[2], 1, -1, -2);
	sprite_motion(s[3], 2, 1, -1);
	sprite_motion(s[4], 1, 1, 2);
  
  for (int count=0; count<225; count++) {  //now bounce all there sprites  around in the cube
    sprite_bounceIt(s[0]);
    if (count>30)
        sprite_bounceIt(s[1]);
    if (count>60)
        sprite_bounceIt(s[2]);
    if (count>90)
        sprite_bounceIt(s[3]);
    if (count>120)
        sprite_bounceIt(s[4]);
    delay(125); // delay 125msec between each movement. 
  }
  for (i = 0; i < 5; i++)
  {
	sprite_clearIt(s[i]);
	sprite_delete(s[i]);
  }
}
#else
void Single_Swirl() {
  sprite LED1(1,1,1);
  LED1.colorIt(Yellow);
  LED1.place = {5,4,3};
  LED1.motion = {1,-2,1};
  
  sprite LED2(1,1,1);
  LED2.colorIt(Green);
  LED2.place = {3,4,5};
  LED2.motion = {1,1,-2};
  
  sprite LED3(1,1,1);
  LED3.colorIt(Blue);
  LED3.place = {2,6,3};
  LED3.motion = {1,-1,-2};
  
  sprite LED4(1,1,1);
  LED4.colorIt(Violet);
  LED4.place = {5,1,2};
  LED4.motion = {2,1,-1};
  
  sprite LED5(1,1,1);
  LED5.colorIt(Orange);
  LED5.place = {1,2,3};
  LED5.motion = {1,1,2};
  
  for (int count=0; count<225; count++) {  //now bounce all there sprites  around in the cube
    LED1.bounceIt();
    if (count>30) {
    LED2.bounceIt();}
    if (count>60) {
    LED3.bounceIt();}
    if (count>90) {
    LED4.bounceIt();}
    if (count>120) {
    LED5.bounceIt();}
    delay(125); // delay 125msec between each movement. 
  }
  LED1.clearIt();
  LED2.clearIt();
  LED3.clearIt();
  LED4.clearIt();
  LED5.clearIt();
   delay(1000);
}
#endif

