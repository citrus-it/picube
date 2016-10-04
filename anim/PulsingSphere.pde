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

void show_sphere(){ // draw the sphere and change its color
  for (byte layer=0; layer<8; layer++){  // scan thru each layer
    for (byte column=0; column<8; column++){  // scan thru every column
      for (byte panel=0; panel<8; panel++){  // scan thru every panel
        x= float(layer); // convert coordinates to floating point to compute  distance from center of cube
        y= float(panel); 
        z= float(column); 
        float polar = sqrt((x-3.5)*(x-3.5)+(y-3.5)*(y-3.5)+(z-3.5)*(z-3.5)); //  Calculate the distance
        if (polar<count){ // if an LED is inside the radius specified by  count, turn it on. 
          LED(column, panel, layer, myred, mygreen, myblue);
        }
        else{  // otherwise turn it off
          LED(column, panel, layer,0,0,0);
        }
      }
    }
  }
  delay(75);  // control speed
  colorCount = colorCount + 12;  // increment color wheel by twelve
  if (colorCount > 189){  // keep color wheel colors in bounds
    colorCount =0;
  }
  getColor(colorCount, 3); // get the color wheel color for next pass
}

// this is the pulsing sphere animation.
void Pulsing_Sphere(int mycount){
  for (int counter=0; counter<mycount; counter++){
    for (count=0; count<5; count++){  //expand
      show_sphere();
    }
    for (count=4; count>0; count--){  //contract
      show_sphere();
    }
  }
#ifndef PICUBE
  delay(1000);
#else
  clearCube();
#endif
}


