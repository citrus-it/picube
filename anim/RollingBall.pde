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
This animation uses the new .sphere action of the sprite object class to  create a 6 LED diameter sphere where is then rolled around the main cube.  
*/
void RollingBall(){ 
// This created the sprite and rolls it around the cube. 
// The sprite is rotated around the axis, and then 
// gradually moved back and forth on the x axis.
 int color;
#ifdef PICUBE
 sprite mySprite = sprite_create(6,6,6); 
 sprite_sphere(mySprite, color);
 sprite_place(mySprite, -1, 1, 1);
 for (int x=0; x<95; x++){
    color=color+2;
    if (color>189){color=0;}
      sprite_sphere(mySprite, color);
    if (x>15){
      clearCube();
      sprite_placeX(mySprite, 0, 0);
    }
    if (x>30){
      clearCube();
      sprite_placeX(mySprite, 0, 1);
    }
    if (x>45){
      clearCube();
      sprite_placeX(mySprite, 0, 2);
    }
    if (x>60){
      clearCube();
      sprite_placeX(mySprite, 0, 1);
    }
    if (x>75){
      clearCube();
      sprite_placeX(mySprite, 0, 0);
    }
    sprite_rollX(mySprite, 0);
    delay(50);
  }
  sprite_clearIt(mySprite);
  sprite_delete(mySprite);
#else
 sprite mySprite(6,6,6); 
 mySprite.sphere(color);
 mySprite.place = {-1,1,1};
 for (int x=0; x<95; x++){
    color=color+2;
    if (color>189){color=0;}
      mySprite.sphere(color);
    if (x>15){
      clearCube();
      mySprite.place[0]= 0;
    }
    if (x>30){
      clearCube();
      mySprite.place[0]= 1;
    }
    if (x>45){
      clearCube();
      mySprite.place[0]= 2;
    }
    if (x>60){
      clearCube();
      mySprite.place[0]= 1;
    }
    if (x>75){
      clearCube();
      mySprite.place[0]= 0;
    }
    mySprite.rollX(0);
    delay(50);
  }
 mySprite.clearIt();
  delay(1000);
#endif
}
