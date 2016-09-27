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

// This is a subroutine that swings three sheets of LEDs from one face of the cube to another.  The string input 
// tells the routine the corner which we are going to swing from, and direction of 
// rotation.  The time input in milliseconds between steps (25 is pretty fast; 200 is pretty slow). 
// It also has some options to sent the sheet straight across the cube instead of swinging. These
// start with a p and then specify the direction and plane of movement.

#ifdef PICUBE
void swingAll(char *RedString, char *GreenString, char *BlueString, int myTime) {
  
  for (int i=0; i<8; i++){
    for (int z=0; z<8; z++){
      for (int x=0; x<8; x++) {
        // do it all around the z axis
        if (!strcmp(BlueString, "1r")){
          BlueLED(x,diagonal[x][i],z);  
        }
        else if (!strcmp(BlueString, "1f")){
            BlueLED(diagonal[7-x][i],7-x,z); 
        }
        else if (!strcmp(BlueString, "2f")){
            BlueLED(x,7-diagonal[x][i],z); 
        }
        else if (!strcmp(BlueString, "2r")){
          BlueLED(diagonal[7-x][i],x,z); 
        }
        else if (!strcmp(BlueString, "3r")){
          BlueLED(7-x,7-diagonal[x][i],z);   
        }
        else if (!strcmp(BlueString, "3f")){
          BlueLED(7-diagonal[7-x][i],x,z); 
        }
        else if (!strcmp(BlueString, "4f")){
            BlueLED(7-x,diagonal[x][i],z); 
        }
        else if (!strcmp(BlueString, "4r")){
            BlueLED(7-diagonal[7-x][i],7-x,z); 
        }
        else if (!strcmp(BlueString, "pfy")){
            BlueLED(x,i/2,z);
        }
         else if (!strcmp(BlueString, "pry")){
            BlueLED(x,7-(i/2),z); 
        }
         else if (!strcmp(BlueString, "pfx")){
            BlueLED(i/2,x,z);
        }
         else if (!strcmp(BlueString, "prx")){
            BlueLED(7-(i/2),x,z); 
        }
        // now do it all again around the x axis
         if (!strcmp(RedString, "1r")){
          RedLED(z,x,diagonal[x][i]);   
        }
        else if (!strcmp(RedString, "1f")){
            RedLED(z,diagonal[7-x][i],7-x); 
        }
        else if (!strcmp(RedString, "2f")){
            RedLED(z,x,7-diagonal[x][i]); 
        }
        else if (!strcmp(RedString, "2r")){
          RedLED(z,diagonal[7-x][i],x); 
        }
        else if (!strcmp(RedString, "3r")){
          RedLED(z,7-x,7-diagonal[x][i]);   
        }
       else if (!strcmp(RedString, "3f")){
          RedLED(z,7-diagonal[7-x][i],x); 
        }
        else if (!strcmp(RedString, "4f")){
            RedLED(z,7-x,diagonal[x][i]); 
        }
        else if (!strcmp(RedString, "4r")){
            RedLED(z,7-diagonal[7-x][i],7-x); 
        }
         else if (!strcmp(RedString, "pfy")){
            RedLED(x,i/2,z);
        }
         else if (!strcmp(RedString, "pry")){
            RedLED(x,7-(i/2),z); 
        }
         else if (!strcmp(RedString, "pfz")){
            RedLED(x,z,i/2);
        }
         else if (!strcmp(RedString, "prz")){
            RedLED(x,z,7-(i/2)); 
        }
        // now do it all again around the y axis
         if (!strcmp(GreenString, "1r")){
          GreenLED(x,z,diagonal[x][i]);   
        }
        else if (!strcmp(GreenString, "1f")){
           GreenLED(diagonal[7-x][i],z,7-x); 
        }
        else if (!strcmp(GreenString, "2f")){
            GreenLED(x,z,7-diagonal[x][i]); 
        }
        else if (!strcmp(GreenString, "2r")){
          GreenLED(diagonal[7-x][i],z,x); 
        }
        else if (!strcmp(GreenString, "3r")){
          GreenLED(7-x,z,7-diagonal[x][i]);   
        }
       else if (!strcmp(GreenString, "3f")){
          GreenLED(7-diagonal[7-x][i],z,x); 
        }
        else if (!strcmp(GreenString, "4f")){
            GreenLED(7-x,z,diagonal[x][i]); 
        }
        else if (!strcmp(GreenString, "4r")){
            GreenLED(7-diagonal[7-x][i],z,7-x); 
        }
        else if (!strcmp(GreenString, "pfx")){
            GreenLED(i/2,x,z);
        }
         else if (!strcmp(GreenString, "prx")){
            GreenLED(7-(i/2),x,z); 
        }
         else if (!strcmp(GreenString, "pfz")){
            GreenLED(x,z,i/2);
        }
         else if (!strcmp(GreenString, "prz")){
            GreenLED(x,z,7-(i/2)); 
        }
      } 
    }
    delay(myTime);
    clearCube();
  }

for (int i=6; i>-1; i--){
    for (int z=0; z<8; z++){
      for (int x=0; x<8; x++) {
        // do it all around the z axis
        if (!strcmp(BlueString, "1r")){
          BlueLED(diagonal[x][i],x,z); 
        } 
         else if (!strcmp(BlueString, "1f")){
          BlueLED(7-x,diagonal[7-x][i],z); 
        } 
        else  if (!strcmp(BlueString, "2f")){
          BlueLED(diagonal[x][i],7-x,z);  
        } 
       else  if (!strcmp(BlueString, "2r")){
          BlueLED(7-x,7-diagonal[7-x][i],z);  
        } 
        else if (!strcmp(BlueString, "3r")){
         BlueLED(7-diagonal[x][i],7-x,z);  
        } 
        else if (!strcmp(BlueString, "3f")){
          BlueLED(x,7-diagonal[7-x][i],z); 
        } 
         else if (!strcmp(BlueString, "4f")){
         BlueLED(7-diagonal[x][i],x,z);  
        } 
        else if (!strcmp(BlueString, "4r")){
          BlueLED(x,diagonal[7-x][i],z); 
        } 
        else if (!strcmp(BlueString, "pfy")){
            BlueLED(x,3+(7-i)/2,z);
        }
         else if (!strcmp(BlueString, "pry")){
            BlueLED(x,4-(7-i)/2,z); 
        }
          else if (!strcmp(BlueString, "pfx")){
            BlueLED(3+(7-i)/2,x,z);
        }
         else if (!strcmp(BlueString, "prx")){
            BlueLED(4-(7-i)/2, x,z); 
        }
        // now do it all again around the x axis
        if (!strcmp(RedString, "1r")){
          RedLED(z,diagonal[x][i],x); 
        } 
        else if (!strcmp(RedString, "1f")){
          RedLED(z,7-x,diagonal[7-x][i]); 
        } 
         else if (!strcmp(RedString, "2f")){
          RedLED(z,diagonal[x][i],7-x);  
        } 
        else if (!strcmp(RedString, "2r")){
          RedLED(z,7-x,7-diagonal[7-x][i]);  
        } 
        else if (!strcmp(RedString, "3r")){
         RedLED(z,7-diagonal[x][i],7-x);  
        } 
        else if (!strcmp(RedString, "3f")){
          RedLED(z,x,7-diagonal[7-x][i]); 
        } 
         else if (!strcmp(RedString, "4f")){
         RedLED(z,7-diagonal[x][i],x);  
        } 
        else if (!strcmp(RedString, "4r")){
          RedLED(z,x,diagonal[7-x][i]); 
        } 
         else if (!strcmp(RedString, "pfy")){
            RedLED(x,3+(7-i)/2,z);
        }
         else if (!strcmp(RedString, "pry")){
            RedLED(x,4-(7-i)/2,z); 
        }
          else if (!strcmp(RedString, "pfz")){
            RedLED(x,z,3+(7-i)/2);
        }
         else if (!strcmp(RedString, "prz")){
            RedLED(x,z,4-(7-i)/2); 
        }
        
         // now do it all again around the y axis
        if (!strcmp(GreenString, "1r")){
          GreenLED(diagonal[x][i],z,x); 
        } 
        else if (!strcmp(GreenString, "1f")){
          GreenLED(7-x,z,diagonal[7-x][i]); 
        } 
         else if (!strcmp(GreenString, "2f")){
          GreenLED(diagonal[x][i],z,7-x);  
        } 
        else if (!strcmp(GreenString, "2r")){
          GreenLED(7-x,z,7-diagonal[7-x][i]);  
        } 
        else if (!strcmp(GreenString, "3r")){
         GreenLED(7-diagonal[x][i],z,7-x);  
        } 
        else if (!strcmp(GreenString, "3f")){
          GreenLED(x,z,7-diagonal[7-x][i]); 
        } 
         else if (!strcmp(GreenString, "4f")){
         GreenLED(7-diagonal[x][i],z,x);  
        } 
        else if (!strcmp(GreenString, "4r")){
          GreenLED(x,z,diagonal[7-x][i]); 
        }
       else if (!strcmp(GreenString, "pfx")){
            GreenLED(3+(7-i)/2,x,z);
        }
         else if (!strcmp(GreenString, "prx")){
            GreenLED(4-(7-i)/2,x,z); 
        }
          else if (!strcmp(GreenString, "pfz")){
            GreenLED(x,z,3+(7-i)/2);
        }
         else if (!strcmp(GreenString, "prz")){
            GreenLED(x,z,4-(7-i)/2); 
        } 
      }
    }

    delay(myTime);
     clearCube();
  }
}

#else
void swingAll(String RedString, String GreenString, String BlueString, int myTime) {
  
  for (int i=0; i<8; i++){
    for (int z=0; z<8; z++){
      for (int x=0; x<8; x++) {
        // do it all around the z axis
        if (BlueString == "1r"){
          BlueLED(x,diagonal[x][i],z);  
        }
        else if (BlueString == "1f"){
            BlueLED(diagonal[7-x][i],7-x,z); 
        }
        else if (BlueString == "2f"){
            BlueLED(x,7-diagonal[x][i],z); 
        }
        else if (BlueString == "2r"){
          BlueLED(diagonal[7-x][i],x,z); 
        }
        else if (BlueString == "3r"){
          BlueLED(7-x,7-diagonal[x][i],z);   
        }
        else if (BlueString == "3f"){
          BlueLED(7-diagonal[7-x][i],x,z); 
        }
        else if (BlueString == "4f"){
            BlueLED(7-x,diagonal[x][i],z); 
        }
        else if (BlueString == "4r"){
            BlueLED(7-diagonal[7-x][i],7-x,z); 
        }
        else if (BlueString == "pfy"){
            BlueLED(x,i/2,z);
        }
         else if (BlueString == "pry"){
            BlueLED(x,7-(i/2),z); 
        }
         else if (BlueString == "pfx"){
            BlueLED(i/2,x,z);
        }
         else if (BlueString == "prx"){
            BlueLED(7-(i/2),x,z); 
        }
        // now do it all again around the x axis
         if (RedString == "1r"){
          RedLED(z,x,diagonal[x][i]);   
        }
        else if (RedString == "1f"){
            RedLED(z,diagonal[7-x][i],7-x); 
        }
        else if (RedString == "2f"){
            RedLED(z,x,7-diagonal[x][i]); 
        }
        else if (RedString == "2r"){
          RedLED(z,diagonal[7-x][i],x); 
        }
        else if (RedString == "3r"){
          RedLED(z,7-x,7-diagonal[x][i]);   
        }
       else if (RedString == "3f"){
          RedLED(z,7-diagonal[7-x][i],x); 
        }
        else if (RedString == "4f"){
            RedLED(z,7-x,diagonal[x][i]); 
        }
        else if (RedString == "4r"){
            RedLED(z,7-diagonal[7-x][i],7-x); 
        }
         else if (RedString == "pfy"){
            RedLED(x,i/2,z);
        }
         else if (RedString == "pry"){
            RedLED(x,7-(i/2),z); 
        }
         else if (RedString == "pfz"){
            RedLED(x,z,i/2);
        }
         else if (RedString == "prz"){
            RedLED(x,z,7-(i/2)); 
        }
        // now do it all again around the y axis
         if (GreenString == "1r"){
          GreenLED(x,z,diagonal[x][i]);   
        }
        else if (GreenString == "1f"){
           GreenLED(diagonal[7-x][i],z,7-x); 
        }
        else if (GreenString == "2f"){
            GreenLED(x,z,7-diagonal[x][i]); 
        }
        else if (GreenString == "2r"){
          GreenLED(diagonal[7-x][i],z,x); 
        }
        else if (GreenString == "3r"){
          GreenLED(7-x,z,7-diagonal[x][i]);   
        }
       else if (GreenString == "3f"){
          GreenLED(7-diagonal[7-x][i],z,x); 
        }
        else if (GreenString == "4f"){
            GreenLED(7-x,z,diagonal[x][i]); 
        }
        else if (GreenString == "4r"){
            GreenLED(7-diagonal[7-x][i],z,7-x); 
        }
        else if (GreenString == "pfx"){
            GreenLED(i/2,x,z);
        }
         else if (GreenString == "prx"){
            GreenLED(7-(i/2),x,z); 
        }
         else if (GreenString == "pfz"){
            GreenLED(x,z,i/2);
        }
         else if (GreenString == "prz"){
            GreenLED(x,z,7-(i/2)); 
        }
      } 
    }
    delay(myTime);
    clearCube();
  }

for (int i=6; i>-1; i--){
    for (int z=0; z<8; z++){
      for (int x=0; x<8; x++) {
        // do it all around the z axis
        if (BlueString == "1r"){
          BlueLED(diagonal[x][i],x,z); 
        } 
         else if (BlueString == "1f"){
          BlueLED(7-x,diagonal[7-x][i],z); 
        } 
        else  if (BlueString == "2f"){
          BlueLED(diagonal[x][i],7-x,z);  
        } 
       else  if (BlueString == "2r"){
          BlueLED(7-x,7-diagonal[7-x][i],z);  
        } 
        else if (BlueString == "3r"){
         BlueLED(7-diagonal[x][i],7-x,z);  
        } 
        else if (BlueString == "3f"){
          BlueLED(x,7-diagonal[7-x][i],z); 
        } 
         else if (BlueString == "4f"){
         BlueLED(7-diagonal[x][i],x,z);  
        } 
        else if (BlueString == "4r"){
          BlueLED(x,diagonal[7-x][i],z); 
        } 
        else if (BlueString == "pfy"){
            BlueLED(x,3+(7-i)/2,z);
        }
         else if (BlueString == "pry"){
            BlueLED(x,4-(7-i)/2,z); 
        }
          else if (BlueString == "pfx"){
            BlueLED(3+(7-i)/2,x,z);
        }
         else if (BlueString == "prx"){
            BlueLED(4-(7-i)/2, x,z); 
        }
        // now do it all again around the x axis
        if (RedString == "1r"){
          RedLED(z,diagonal[x][i],x); 
        } 
        else if (RedString == "1f"){
          RedLED(z,7-x,diagonal[7-x][i]); 
        } 
         else if (RedString == "2f"){
          RedLED(z,diagonal[x][i],7-x);  
        } 
        else if (RedString == "2r"){
          RedLED(z,7-x,7-diagonal[7-x][i]);  
        } 
        else if (RedString == "3r"){
         RedLED(z,7-diagonal[x][i],7-x);  
        } 
        else if (RedString == "3f"){
          RedLED(z,x,7-diagonal[7-x][i]); 
        } 
         else if (RedString == "4f"){
         RedLED(z,7-diagonal[x][i],x);  
        } 
        else if (RedString == "4r"){
          RedLED(z,x,diagonal[7-x][i]); 
        } 
         else if (RedString == "pfy"){
            RedLED(x,3+(7-i)/2,z);
        }
         else if (RedString == "pry"){
            RedLED(x,4-(7-i)/2,z); 
        }
          else if (RedString == "pfz"){
            RedLED(x,z,3+(7-i)/2);
        }
         else if (RedString == "prz"){
            RedLED(x,z,4-(7-i)/2); 
        }
        
         // now do it all again around the y axis
        if (GreenString == "1r"){
          GreenLED(diagonal[x][i],z,x); 
        } 
        else if (GreenString == "1f"){
          GreenLED(7-x,z,diagonal[7-x][i]); 
        } 
         else if (GreenString == "2f"){
          GreenLED(diagonal[x][i],z,7-x);  
        } 
        else if (GreenString == "2r"){
          GreenLED(7-x,z,7-diagonal[7-x][i]);  
        } 
        else if (GreenString == "3r"){
         GreenLED(7-diagonal[x][i],z,7-x);  
        } 
        else if (GreenString == "3f"){
          GreenLED(x,z,7-diagonal[7-x][i]); 
        } 
         else if (GreenString == "4f"){
         GreenLED(7-diagonal[x][i],z,x);  
        } 
        else if (GreenString == "4r"){
          GreenLED(x,z,diagonal[7-x][i]); 
        }
       else if (GreenString == "pfx"){
            GreenLED(3+(7-i)/2,x,z);
        }
         else if (GreenString == "prx"){
            GreenLED(4-(7-i)/2,x,z); 
        }
          else if (GreenString == "pfz"){
            GreenLED(x,z,3+(7-i)/2);
        }
         else if (GreenString == "prz"){
            GreenLED(x,z,4-(7-i)/2); 
        } 
      }
    }

    delay(myTime);
     clearCube();
  }
}
#endif

// This is the series of calls to the SwingAll subroutine. 
void swings(){
 int myTime = 25;

 swingAll("1f", "xx","xx", myTime);
 swingAll("4f", "xx", "xx", myTime);
 swingAll("3f", "xx", "xx", myTime);
 swingAll("2f", "xx", "xx", myTime);
 swingAll("2r", "xx","xx", myTime);
 swingAll("3r", "xx", "xx", myTime);
 swingAll("4r", "xx", "xx", myTime);
 swingAll("1r", "xx", "xx", myTime);
 swingAll("pfy", "xx", "xx", myTime);
 swingAll("pry", "xx", "xx", myTime);
 
 swingAll("xx", "1f", "xx", myTime);
 swingAll("xx", "4f", "xx", myTime);
 swingAll("xx", "3f", "xx", myTime);
 swingAll("xx", "2f", "xx", myTime);
 swingAll("xx", "2r", "xx", myTime);
 swingAll("xx", "3r", "xx", myTime);
 swingAll("xx", "4r", "xx", myTime);
 swingAll("xx", "1r", "xx", myTime);
 swingAll("xx", "pfx", "xx", myTime);
 swingAll("xx", "prx", "xx", myTime);
 
 swingAll("xx", "xx", "1f", myTime);
 swingAll("xx", "xx", "4f", myTime);
 swingAll("xx", "xx", "3f", myTime);
 swingAll("xx", "xx", "2f", myTime);
 swingAll("xx", "xx", "2r", myTime);
 swingAll("xx", "xx", "3r", myTime);
 swingAll("xx", "xx", "4r", myTime);
 swingAll("xx", "xx", "1r", myTime);
 swingAll("xx", "xx", "pfx", myTime);
 swingAll("xx", "xx", "prx", myTime);

 myTime = 35;
 swingAll("2r", "xx", "1f", myTime);
 swingAll("3r", "xx", "4f", myTime);
 swingAll("4r", "xx", "3f", myTime);
 swingAll("1r", "xx", "2f", myTime);
  swingAll("1f", "xx", "1f", myTime);
 swingAll("4f", "xx", "4f", myTime);
 swingAll("3f", "xx", "3f", myTime);
 swingAll("2f", "xx", "2f", myTime);

 swingAll("xx", "1f","2r", myTime);
 swingAll("xx", "4f", "3r", myTime);
 swingAll("xx", "3f", "4r", myTime);
 swingAll("xx", "2f", "1r", myTime);
 swingAll("xx", "1f","1f", myTime);
 swingAll("xx", "4f", "4f", myTime);
 swingAll("xx", "3f", "3f", myTime);
 swingAll("xx", "2f", "2f", myTime);
 
 swingAll("2r", "1f","xx", myTime);
 swingAll("3r", "4f", "xx", myTime);
 swingAll("4r", "3f", "xx", myTime);
 swingAll("1r", "2f", "xx", myTime);
 swingAll("1f", "2r","xx", myTime);
 swingAll("4f", "3r", "xx", myTime);
 swingAll("3f", "4r", "xx", myTime);
 swingAll("2f", "1r", "xx", myTime);

 myTime = 45;
 swingAll("1f", "1f","1f", myTime);
 swingAll("4f", "4f", "4f", myTime);
 swingAll("3f", "3f", "3f", myTime);
 swingAll("2f", "2f", "2f", myTime);
 
 swingAll("2r", "pfx", "3r", myTime);
 swingAll("2f", "prx", "3f", myTime); 
 
 swingAll("1f", "1f","1f", myTime);
 swingAll("4f", "4f", "4f", myTime);
 swingAll("3f", "3f", "3f", myTime);
 swingAll("2f", "2f", "2f", myTime);
 swingAll("1f", "1f","1f", myTime);
 swingAll("4f", "4f", "4f", myTime);
  
 swingAll("4r", "pfz", "3r", myTime);
 swingAll("4f", "prz", "3f", myTime);
 
 swingAll("3f", "3f", "3f", myTime);
 swingAll("2f", "2f", "2f", myTime);
 swingAll("1f", "1f","1f", myTime);
 swingAll("4f", "4f", "4f", myTime);
 swingAll("3f", "3f", "3f", myTime);
 swingAll("2f", "2f", "2f", myTime);
 swingAll("2r", "1f","1f", myTime);
 swingAll("3r", "4f", "4f", myTime);
 swingAll("4r", "3f", "3f", myTime);
 
 swingAll("pfy", "3r", "3r", myTime);
 swingAll("pry", "3f", "3f", myTime);
 
 swingAll("1r", "2f", "2f", myTime);
 swingAll("2r", "1f","1f", myTime);
 swingAll("3r", "4f", "4f", myTime);
 swingAll("4r", "3f", "3f", myTime);
 swingAll("1r", "2f", "2f", myTime);
 swingAll("2r", "2r","1f", myTime);
 
 swingAll("prz", "2f", "1r", myTime);
 swingAll("pfz", "2r", "1f", myTime);
 
 swingAll("3r", "3r", "4f", myTime);
 swingAll("4r", "4r", "3f", myTime);
 swingAll("1r", "1r", "2f", myTime);
 swingAll("2r", "2r","1f", myTime);
 
 swingAll("2f", "2f", "prx", myTime);
 swingAll("2r", "2r", "pfx", myTime);
 
 swingAll("3r", "3r", "4f", myTime);
 swingAll("4r", "4r", "3f", myTime);
 swingAll("1r", "1r", "2f", myTime);
 swingAll("2r", "2r","2r", myTime);
 swingAll("3r", "3r", "3r", myTime);
 swingAll("4r", "4r", "4r", myTime);
  
 swingAll("4f", "4f", "pry", myTime);
 swingAll("4r", "4r", "pfy", myTime);
 
 swingAll("1r", "1r", "1r", myTime);
 swingAll("2r", "2r", "2r", myTime);
 swingAll("3r", "3r", "3r", myTime);
 swingAll("4r", "4r", "4r", myTime);
 swingAll("1r", "1r", "1r", myTime);

 myTime = 35;
  swingAll("2r", "1f","xx", myTime);
 swingAll("3r", "4f", "xx", myTime);
 swingAll("4r", "3f", "xx", myTime);
 swingAll("1r", "2f", "xx", myTime);
 swingAll("1f", "2r","xx", myTime);
 swingAll("4f", "3r", "xx", myTime);
 swingAll("3f", "4r", "xx", myTime);
 swingAll("2f", "1r", "xx", myTime);
 
 myTime = 25;
 swingAll("1f", "xx","xx", myTime);
 swingAll("4f", "xx", "xx", myTime);
 swingAll("3f", "xx", "xx", myTime);
 swingAll("2f", "xx", "xx", myTime);
 swingAll("2r", "xx","xx", myTime);
 swingAll("3r", "xx", "xx", myTime);
 swingAll("4r", "xx", "xx", myTime);
 swingAll("1r", "xx", "xx", myTime);
 
 swingAll("xx", "1f", "xx", myTime);
 swingAll("xx", "4f", "xx", myTime);
 swingAll("xx", "3f", "xx", myTime);
 swingAll("xx", "2f", "xx", myTime);
 swingAll("xx", "2r", "xx", myTime);
 swingAll("xx", "3r", "xx", myTime);
 swingAll("xx", "4r", "xx", myTime);
 swingAll("xx", "1r", "xx", myTime);
 
 swingAll("xx", "xx", "1f", myTime);
 swingAll("xx", "xx", "4f", myTime);
 swingAll("xx", "xx", "3f", myTime);
 swingAll("xx", "xx", "2f", myTime);
 swingAll("xx", "xx", "2r", myTime);
 swingAll("xx", "xx", "3r", myTime);
 swingAll("xx", "xx", "4r", myTime);
 swingAll("xx", "xx", "1r", myTime);
#ifndef PICUBE
 delay(1000);
#endif
}


