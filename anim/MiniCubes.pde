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

// Another animations using the sprite object class
// More boxes, but not concentic. These just pop into
// and out of existence with different colors and sizes.

// this is used to assign a standard color to a sprite
// by randomly putting a standard color's number in mycolor.
 void get_std_color(){
  int colorit= random(8)+1;
  switch(colorit){
  case 1:
    mycolor=Red;
    break;
  case 2:
    mycolor=Yellow;
    break;
  case 3:
    mycolor=Green;
    break;
  case 4:
    mycolor=Blue;
    break;
  case 5:
    mycolor=Purple;;
    break;
  case 6:
    mycolor=Violet;
    break;
  case 7:
    mycolor=Orange;
    break;
  case 8:
    mycolor=Aqua;
    break;
  default: 
    mycolor=Black;;  
  }
}

#ifdef PICUBE
void miniCubes(){
  sprite s[3];

  s[0] = sprite_create(2, 2, 2);
  s[1] = sprite_create(3, 3, 3);
  s[2] = sprite_create(2, 2, 2);
	
  for (int j=0; j<50; j++){

    get_std_color();
    sprite_outline(s[0], mycolor);
    s[0]->place[0] = random(7);
    s[0]->place[1] = random(7);
    s[0]->place[2] = random(7);
    sprite_setIt(s[0]);
    delay(200-j*3);

    get_std_color();
    sprite_outline(s[1], mycolor);
    s[1]->place[0] = random(6);
    s[1]->place[1] = random(6);
    s[1]->place[2] = random(6);
    sprite_setIt(s[1]);
    delay(200-j*3);

    get_std_color();
    sprite_outline(s[2], mycolor);
    s[2]->place[0] = random(7);
    s[2]->place[1] = random(7);
    s[2]->place[2] = random(7);
    sprite_setIt(s[2]);
    delay(200-j*3);
    
    sprite_clearIt(s[0]);
    sprite_clearIt(s[1]);
    sprite_clearIt(s[2]);
  }
  sprite_delete(s[0]);
  sprite_delete(s[1]);
  sprite_delete(s[2]);
}
#else
void miniCubes(){
  sprite mysprite1(2,2,2);
  sprite mysprite2(3,3,3);
  sprite mysprite3(2,2,2);
  for (int j=0; j<50; j++){
    get_std_color();
    mysprite1.outline(mycolor); 
    mysprite1.place[0] =random(7);
    mysprite1.place[1] =random(7); 
    mysprite1.place[2] =random(7);  
    mysprite1.setIt();
    delay(200-j*3);
    
    get_std_color();
    mysprite2.outline(mycolor); 
    mysprite2.place[0] =random(6);
    mysprite2.place[1] =random(6); 
    mysprite2.place[2] =random(6);  
    mysprite2.setIt();
    delay(200-j*3);
    
    get_std_color();
    mysprite3.outline(mycolor); 
    mysprite3.place[0] =random(7);
    mysprite3.place[1] =random(7); 
    mysprite3.place[2] =random(7);  
    mysprite3.setIt();
    delay(200-j*3);
    mysprite1.clearIt(); 
    mysprite2.clearIt();
    mysprite3.clearIt(); 
  }
 delay(1000); 
}
#endif

