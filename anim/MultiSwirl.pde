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

// This animation is similar to the single swirl except our sprites are 2 x 2  x 2 in size.  They are just as easy to create as our single LED sprites, 
// and are much easier to track as they move about in the cube. 

#ifdef PICUBE
void Multi_Swirl() {
	sprite s[6];
	int i, count;

	for (i = 0; i < 6; i++)
		s[i] = sprite_create(2, 2, 2);

	sprite_colorIt(s[0], Yellow);
	sprite_colorIt(s[1], Green);
	sprite_colorIt(s[2], Blue);
	sprite_colorIt(s[3], Violet);
	sprite_colorIt(s[4], Orange);
	sprite_colorIt(s[5], Red);

	sprite_place(s[0], 5, 4, 3);
	sprite_place(s[1], 3, 4, 5);
	sprite_place(s[2], 2, 6, 3);
	sprite_place(s[3], 5, 1, 2);
	sprite_place(s[4], 1, 2, 3);
	sprite_place(s[5], 5, 1, 2);

	sprite_motion(s[0], 1, -2, 1);
	sprite_motion(s[1], 2, 1, -2);
	sprite_motion(s[2], 1, -1, -1);
	sprite_motion(s[3], 2, 1, -1);
	sprite_motion(s[4], 1, 1, 2);
	sprite_motion(s[5], 2, 1, -1);

  for (count=0; count<150; count++) {  //now bounce all these sprites  around in the cube
	for (i = 0; i < 6; i++)
		sprite_bounceIt(s[i]);
    delay(125); // delay 125msec between each movement. 
  }
  for (i = 0; i < 6; i++)
  {
	sprite_clearIt(s[i]);
	sprite_delete(s[i]);
  }
}
#else
void Multi_Swirl() {
   sprite LED1(2,2,2);  //create 6 sprites
  LED1.colorIt(Yellow);
  LED1.place = {5,4,3};
  LED1.motion = {1,-2,1};

  sprite LED2(2,2,2);
  LED2.colorIt(Green);
  LED2.place = {3,4,5};
  LED2.motion = {2,1,-2};
  
  sprite LED3(2,2,2);
  LED3.colorIt(Blue);
  LED3.place = {2,6,3};
  LED3.motion = {1,-1,-1};
   
  sprite LED4(2,2,2);
  LED4.colorIt(Violet);
  LED4.place = {5,1,2};
  LED4.motion = {2,1,-1};
 
  sprite LED5(2,2,2);
  LED5.colorIt(Orange);
  LED5.place = {1,2,3};
  LED5.motion = {1,1,2};

  sprite LED6(2,2,2);
  LED6.colorIt(Red);
  LED6.place = {5,1,2};
  LED6.motion = {2,1,-1};

  for (int count=0; count<150; count++) {  //now bounce all these sprites  around in the cube
    LED1.bounceIt();
    LED2.bounceIt();
    LED3.bounceIt();
    LED4.bounceIt();
    LED5.bounceIt();
    LED6.bounceIt();
    delay(125); // delay 125msec between each movement. 
  }
  LED1.clearIt();
  LED2.clearIt();
  LED3.clearIt();
  LED4.clearIt();
  LED5.clearIt();
  LED6.clearIt();
  delay(1000);
}
#endif

