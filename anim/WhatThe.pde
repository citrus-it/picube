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

// whatThe is the result of a simple experiment. The idea was have each layer going around
// (using the atom table) at a different speed. A lot of work just to end up with a 
// simple animation.  Then let's try to put everything back by reversing the process. 
// That doesn't quite work.  I had to fudge it a little.  But here it is. 
void whatThe() {
  mycolor=0;
  getColor(mycolor, 4);
  for (int k=0; k<6; k++){
    byte index0=0, index1=0, index2=0, index3=0, index4=0, index5=0, index6=0, index7=0;
  for (int j=0;j<1000; j++) {
      if (j%20==0){index0++;} 
      if (index0>19){index0=0;}
      LED(atomTable[index0][0],atomTable[index0][1],0,myred, myblue, mygreen);
      if (j%19==0){index1++;} 
      if (index1>19){index1=0;}
      LED(atomTable[index1][0],atomTable[index1][1],1,myred, myblue, mygreen);
      if (j%18==0){index2++;} 
      if (index2>19){index2=0;}
      LED(atomTable[index2][0],atomTable[index2][1],2,myred, myblue, mygreen);
      if (j%17==0){index3++;} 
      if (index3>19){index3=0;}
      LED(atomTable[index3][0],atomTable[index3][1],3,myred, myblue, mygreen);
      if (j%16==0){index4++;} 
      if (index4>19){index4=0;}
      LED(atomTable[index4][0],atomTable[index4][1],4,myred, myblue, mygreen);
      if (j%15==0){index5++;} 
      if (index5>19){index5=0;}
      LED(atomTable[index5][0],atomTable[index5][1],5,myred, myblue, mygreen);  
      if (j%14==0){index6++;} 
      if (index6>19){index6=0;}
      LED(atomTable[index6][0],atomTable[index6][1],6,myred, myblue, mygreen);
     if (j%13==0){index7++;} 
      if (index7>19){index7=0;}
      LED(atomTable[index7][0],atomTable[index7][1],7,myred, myblue, mygreen);
      mycolor=mycolor+5;
      if (mycolor>189){mycolor=0;}
        getColor(mycolor,4);
      if(j%10<1) {
       delay(25+ 25/(j/100+10)); 
       clearAtom();
      }
    }
    for (int j=1000;j<3000; j++) {
      if (j%16==0){index0++;} 
      if (index0>19){index0=0;}
      LED(atomTable[index0][0],atomTable[index0][1],0,myred, myblue, mygreen);
      if (j%16==0){index1++;} 
      if (index1>19){index1=0;}
      LED(atomTable[index1][0],atomTable[index1][1],1,myred, myblue, mygreen);
      if (j%16==0){index2++;} 
      if (index2>19){index2=0;}
      LED(atomTable[index2][0],atomTable[index2][1],2,myred, myblue, mygreen);
      if (j%16==0){index3++;} 
      if (index3>19){index3=0;}
      LED(atomTable[index3][0],atomTable[index3][1],3,myred, myblue, mygreen);
      if (j%16==0){index4++;} 
      if (index4>19){index4=0;}
      LED(atomTable[index4][0],atomTable[index4][1],4,myred, myblue, mygreen);
      if (j%16==0){index5++;} 
      if (index5>19){index5=0;}
      LED(atomTable[index5][0],atomTable[index5][1],5,myred, myblue, mygreen);  
      if (j%16==0){index6++;} 
      if (index6>19){index6=0;}
      LED(atomTable[index6][0],atomTable[index6][1],6,myred, myblue, mygreen);
     if (j%16==0){index7++;} 
      if (index7>19){index7=0;}
      LED(atomTable[index7][0],atomTable[index7][1],7,myred, myblue, mygreen);
      mycolor=mycolor+5;
      if (mycolor>189){mycolor=0;}
        getColor(mycolor,4);
      if(j%10<1) {
       delay(25); 
       clearAtom();
      }
    }
    
    for (int j=3000;j<4150; j++) {
      if (j%13==0){index0++;} 
      if (index0>19){index0=0;}
      LED(atomTable[index0][0],atomTable[index0][1],0,myred, myblue, mygreen);
      if (j%14==0){index1++;} 
      if (index1>19){index1=0;}
      LED(atomTable[index1][0],atomTable[index1][1],1,myred, myblue, mygreen);
      if (j%15==0){index2++;} 
      if (index2>19){index2=0;}
      LED(atomTable[index2][0],atomTable[index2][1],2,myred, myblue, mygreen);
      if (j%16==0){index3++;} 
      if (index3>19){index3=0;}
      LED(atomTable[index3][0],atomTable[index3][1],3,myred, myblue, mygreen);
      if (j%17==0){index4++;} 
      if (index4>19){index4=0;}
      LED(atomTable[index4][0],atomTable[index4][1],4,myred, myblue, mygreen);
      if (j%18==0){index5++;} 
      if (index5>19){index5=0;}
      LED(atomTable[index5][0],atomTable[index5][1],5,myred, myblue, mygreen);  
      if (j%19==0){index6++;} 
      if (index6>19){index6=0;}
      LED(atomTable[index6][0],atomTable[index6][1],6,myred, myblue, mygreen);
     if (j%20==0){index7++;} 
      if (index7>19){index7=0;}
      LED(atomTable[index7][0],atomTable[index7][1],7,myred, myblue, mygreen);
      mycolor=mycolor+5;
      if (mycolor>189){mycolor=0;}
        getColor(mycolor,4);
      if(j%10<1) {
       delay(25); 
       clearAtom();
      }
    }
    clearAtom();
    for (int j=0; j<8;j++){
      LED(2,0,j,myred, myblue, mygreen);
    }
    delay(100);
}
clearAtom();
#ifndef PICUBE
delay(1000);
#endif
}
