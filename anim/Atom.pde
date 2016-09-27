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

/*  Atom is my version of Nick Schulze's Atom animation.  There are a lot of things 
going on here.  The animation operates in a small set of only 20 columns, represented by 
atomTable.  We basically operate around these 20 columns using index i. We step 
through the animation with index k, first with k increasing and then with k decreasing.  
More positions are lit as k increases. The real action is in which layer each of Atom's 
columns is lit up. There is a linear vertical component called p which varies between
0 and 3, and sinewave component controlled by both j(the offset of i) and k.  Together 
j and k give us a double sinewave that slowly precesses around the cube. 
*/

// This changes colors for Atom
void manage_color2() {
  getColor(mycolor, 4);
  mycolor=mycolor+2;
  if (mycolor>189){mycolor=0;} 
}

 // This little routine clears the cube, but for speed,
 // it only operates onperates on the specific columns used by Atom
 void clearAtom(){  
   for (byte j=0; j<20; j++){  
      for (byte layer=0; layer<8; layer++){  
#ifdef PICUBE
        LED(int(atomTable[j][0]), int(atomTable[j][1]), layer, 0, 0, 0);
#else
        cube[int(atomTable[j][0])][int(atomTable[j][1])][layer][0]=0;
        cube[int(atomTable[j][0])][int(atomTable[j][1])][layer][1]=0;
        cube[int(atomTable[j][0])][int(atomTable[j][1])][layer][2]=0;
#endif
      }
    }
  }

// This is the main Atom routine
void atom(){
  int j, p=1, up_down; 
  int mySpeed=40;
  mycolor=0;
  for (int k=0; k<20; k++){  // at first k is increassing
    if (up_down==0){  // up_down controls the direction of the linear vertical offset
      p++;
    }
    else {
      p--;
    }
    if (p<1){
      up_down=0;
    }
    if (p>2){
      up_down=1;
    }
    for(int i=0; i<20; i++) {  // i steps us through the 20 columns being used
      j=i+0;  // j is the offset of i for the different lit positions, starting with 0 offset.
      if (j>19){
        j=j-20;
      }
      manage_color2();  // routine that manages color
      // the next line is where the first atom shown gets its position
      LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      if(k>3){  // if k is >3, then the 2nd atom is shown
        j=i-3;
        if (j<0){
          j=j+20;
        }
       manage_color2();
       // the next line is where the 2nd atom shown gets its position
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>6){
        j=i-6;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>9){
        j=i-9;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>12){
        j=i-12;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>15){
        j=i-15;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>18){
        j=i-18;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      delay(mySpeed);
      clearAtom();  //clears the cube, but only the columns being used.
    }
  mycolor=mycolor+(k*8); // k is used to offset the color in addition to changing as we go through                         
  getColor(mycolor, 4);  // the various positions. 
  }
  for (int k=18; k>0; k--){  // Now we do it all over again with k declining
    if (up_down==0){
      p++;
    }
    else {
      p--;
    }
    if (p<1){
      up_down=0;
    }
    if (p>2){
      up_down=1;
    }
    for(int i=0; i<20; i++) {
      j=i+0;
      if (j>19){
        j=j-20;
      }
      manage_color2();
      LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      if(k>3){
        j=i-3;
        if (j<0){
          j=j+20;
        }
       manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>6){
        j=i-6;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>9){
        j=i-9;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>12){
        j=i-12;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>15){
        j=i-15;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      if(k>18){
        j=i-18;
        if (j<0){
          j=j+20;
        }
        manage_color2();
        LED(atomTable[j][0],atomTable[j][1],2+p+int(3*sin(((j-k)*12.56)/20)),myred, myblue, mygreen); 
      }
      delay(mySpeed);
    clearAtom();
    }
  mycolor=mycolor+(k);
  getColor(mycolor, 4);
  }
#ifndef PICUBE
  delay(1000);
#endif
}

