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

// Bouncer is some simple effects based on the sprite object class and its bounce action.
// This version of bouncer has 3 sprites bouncing around the cube while changing colors  

#ifdef PICUBE
void bouncer1(){
  sprite mySprite1 = sprite_create(2,2,2); 
  sprite mySprite2 = sprite_create(2,2,2); 
  sprite mySprite3 = sprite_create(2,2,2); 

  sprite_place(mySprite1, 1, 2, 3);
  sprite_place(mySprite2, 0, 4, 4);
  sprite_place(mySprite3, 4, 4, 0);

  sprite_motion(mySprite1, 1, 2, 1);
  sprite_motion(mySprite2, 1, -1, -2);
  sprite_motion(mySprite3, -2, -1, -1);

  for (int j=0; j<200; j++){
   mycolor =mycolor + 5;
   if (mycolor>100) {mycolor=0;}
    sprite_colorIt(mySprite1, mycolor);
    sprite_colorIt(mySprite2, mycolor + 40);
    sprite_colorIt(mySprite3, mycolor + 80);
    sprite_bounceIt(mySprite1);
    delay(50);
    sprite_bounceIt(mySprite2);
    delay(50);
    sprite_bounceIt(mySprite3);
    delay(50);
 }
 sprite_clearIt(mySprite1);
 sprite_clearIt(mySprite2);
 sprite_clearIt(mySprite3);
 sprite_delete(mySprite1);
 sprite_delete(mySprite2);
 sprite_delete(mySprite3);
  
}

// This bouncer has a red, greeen, and blue sprite bouncing back and forth, each in their own
// plane.  It gets faster and faster as it goes.
void bouncer2(){
  sprite mySprite1 = sprite_create(2,2,2); 
  sprite mySprite2 = sprite_create(2,2,2);
  sprite mySprite3 = sprite_create(2,2,2); 

  sprite_colorIt(mySprite1, Red);
  sprite_colorIt(mySprite2, Green);
  sprite_colorIt(mySprite3, Blue);

  sprite_place(mySprite1, 0, 2, 3);
  sprite_place(mySprite2, 5, 2, 4);
  sprite_place(mySprite3, 2, 4, 4);

  sprite_motion(mySprite1, 1, 0, 0);
  sprite_motion(mySprite2, 0, 1, 0);
  sprite_motion(mySprite3, 0, 0, 1);

  for (int j=0; j<210;j++){
    sprite_bounceIt(mySprite1);
  delay(50-j/5);
  if (j>36){
    sprite_bounceIt(mySprite2);
    }
  delay(50-j/5);
  if (j>72){
    sprite_bounceIt(mySprite3);
    }
 delay(50-j/5);
 }
 sprite_clearIt(mySprite1);
 sprite_clearIt(mySprite2);
 sprite_clearIt(mySprite3);
 sprite_delete(mySprite1);
 sprite_delete(mySprite2);
 sprite_delete(mySprite3);
}
//  This is a transition between the first two version.  It's a white ball that fades.
void bouncer3(){
  sprite mySprite1 = sprite_create(6,6,6); 
  sprite_sphere(mySprite1, White);
  sprite_place(mySprite1, 1, 1, 1);
  sprite_setIt(mySprite1);
  delay(150);
  for (int j=3; j>-1;j--){
    sprite_setIt(mySprite1);
    delay(150);
    sprite_ChgIntensity(mySprite1, j);
  }
  sprite_clearIt(mySprite1);
  sprite_delete(mySprite1);
  delay(500);
}
#else
void bouncer1(){
  sprite mySprite1(2,2,2); 
  sprite mySprite2(2,2,2); 
  sprite mySprite3(2,2,2); 
  mySprite1.place = {1,2,3};
  mySprite2.place = {0,4,4};
  mySprite3.place = {4,4,0};
  mySprite1.motion = {1,2,1};
  mySprite2.motion = {1,-1,-2};
  mySprite3.motion = {-2,-1,-1};
  for (int j=0; j<200; j++){
   mycolor =mycolor + 5;
   if (mycolor>100) {mycolor=0;}
   mySprite1.colorIt(mycolor);
   mySprite2.colorIt(mycolor+40);
   mySprite3.colorIt(mycolor+80);
   mySprite1.bounceIt();
   delay(50);
   mySprite2.bounceIt();
   delay(50);
   mySprite3.bounceIt();
   delay(50);
 }
 mySprite1.clearIt();
 mySprite2.clearIt();
 mySprite3.clearIt();
  
}

// This bouncer has a red, greeen, and blue sprite bouncing back and forth, each in their own
// plane.  It gets faster and faster as it goes.
void bouncer2(){
  sprite mySprite1(2,2,2); 
  mySprite1.colorIt(Red);
  mySprite1.place = {0,2,3};
  mySprite1.motion = {1,0,0};
  sprite mySprite2(2,2,2);
  mySprite2.colorIt(Green);
  mySprite2.place = {5,2,4};
  mySprite2.motion = {0,1,0};
  sprite mySprite3(2,2,2); 
  mySprite3.colorIt(Blue);
  mySprite3.place = {2,4,4};
  mySprite3.motion = {0,0,1};
  for (int j=0; j<210;j++){
  mySprite1.bounceIt();
  delay(50-j/5);
  if (j>36){
    mySprite2.bounceIt();
    }
  delay(50-j/5);
  if (j>72){
    mySprite3.bounceIt();
    }
 delay(50-j/5);
 }
 mySprite1.clearIt();
 mySprite2.clearIt();
 mySprite3.clearIt();
}
//  This is a transition between the first two version.  It's a white ball that fades.
void bouncer3(){
  sprite mySprite1(6,6,6); 
  mySprite1.sphere(White);
  mySprite1.place = {1,1,1};
  mySprite1.setIt();
  delay(150);
  for (int j=3; j>-1;j--){
    mySprite1.setIt();
    delay(150);
    mySprite1.ChgIntensity(j);
  }
  mySprite1.clearIt();
  delay(500);
}
#endif

void bouncer(){
  bouncer2();
  bouncer3();
  bouncer1();
#ifndef PICUBE
  delay(1000);
#endif
  }
