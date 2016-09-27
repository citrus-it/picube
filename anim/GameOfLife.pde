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

/* This is the Conway Game of Life in 3D.  It's a simulation of life called a cellular automation.  
 Each LED in the cube represents a potential life.  A newborn life is represented by a violet LED.  
 A life lasting more than a single generation is represented by a blue LED. A recently deceased life
 is represented by a dull red LED.  
 
 The simulation starts with some random births near the center of the cube.  The simulation 
 than proceeds with up to a maximum of 150 generations. Each new generation is based on these rules:
 1. A dead cell (LED) with exactly 4 living neighbors is born into the next generation. 
 2. A live cell with exactly 4 living neighbors continues to life to the next generation. 
 3. A cell with less than 4 or more than 4 neighbors dies in the next generation. 
 
 This version is slightly different than the one I published separately.  Since we are only 
 showing 3 generations here, I increased the number of starting live cells to insure a
 sustainable colony.  */

void GameOfLife(){
  for (int simruns=0; simruns<5; simruns++){
    int myspeed = 10; // This is where you set the speed. It is basically the number of generations per second. 
    for (byte layer=2; layer<8; layer++){  // This is where we set up a random pattern of living cells
      for (byte column=2; column<6; column++){  
        for (byte panel=2; panel<6; panel++){  
          if (random(2)==0){
#ifdef PICUBE
	    LED(column, panel, layer, 33, 0, 63);
#else
            cube[column][panel][layer][2]= 63;
            cube[column][panel][layer][0]= 33;
#endif
          }
        }
      }
    }
    delay(3000/myspeed);  // showing the initial birth pattern here.  
    for (int counter=0; counter<150; counter++){ // this is the generation counter
      clearBufferCube();  //  BufferCube is where we will temporarily store result for the next generation. 
      int kill=0; // kill is where we count the number of living cells.  When 0, we end the simulation.
      // This next part is where we find the number of live neighbors for each cell
      for (byte layer=0; layer<8; layer++){  // scan thru each layer
        for (byte column=0; column<8; column++){  // scan thru every column
          for (byte panel=0; panel<8; panel++){  // scan thru every panel
            int count=0;  // This is the count of neighbors.
            for (int i=-1; i<2; i++){  // 
              for (int j=-1; j<2; j++){  // 
                for (int k=-1; k<2; k++){  // 
                  if (column+j<8 && column+j>-1 && panel+k<8 && panel+k>-1 && layer+i<8 && layer+i>-1 ) {
#ifdef PICUBE
		    if (xLED(layer+i, column+j, panel+k, BLUE)) {
#else
                    if (cube[layer+i][column+j][panel+k][2]>0) {
#endif
                      count++;  // increment count for each neighbor found. 
                    }
                  }
                }
              }
            }
#ifdef PICUBE
	    if (xLED(layer, column, panel, BLUE)) {
#else
            if (cube[layer][column][panel][2]>0) {
#endif
              count--;  // don't count yourself as a neighbor
            }
            // Then here we light the LEDs based on new birth, continuing to live, recently dead or dead.
            if (count==4){  // if the number of neighbors is 4
              // and we are within the boundaries of the cube
              if (column<8 && column>-1 && panel<8 && panel>-1 && layer<8 && layer>-1 ) {
#ifdef PICUBE
		buffer_cLED(layer, column, panel, BLUE, 63);
		if (!xLED(layer, column, panel, BLUE))
			buffer_cLED(layer, column, panel, RED, 33);
#else
                buffer_cube[layer][column][panel][2]=63;  // make it alive
                if (cube[layer][column][panel][2]==0){  // if its newly born
                  buffer_cube[layer][column][panel][0]=33; //make it violet
                }
#endif
                kill++;  // increment living cell counter
              }
            }
            else {  // if not 4 neighbors, make it dead
#ifdef PICUBE
		buffer_LED(layer, column, panel, 0, 0, 0);
		if (xLED(layer, column, panel, BLUE))
			buffer_cLED(layer, column, panel, RED, 3);
#else
              buffer_cube[layer][column][panel][2]=0;
              buffer_cube[layer][column][panel][0]=0;
              if (cube[layer][column][panel][2]>0){  // if it was alive
                buffer_cube[layer][column][panel][0]=3; // make it dull red. 
              }
#endif
            }
          }
        }
      }
      // Now we transfer the next generation result to the cube.
      clearCube(); // clear the cube and transfer the the content of the BufferCube
      // to the cube. 
#ifdef PICUBE
	cube_from_buffer();
#else
      for (byte layer=0; layer<8; layer++){  
        for (byte column=0; column<8; column++){ 
          for (byte panel=0; panel<8; panel++){  
            cube[column][panel][layer][2]= buffer_cube[column][panel][layer][2];
            cube[column][panel][layer][0]= buffer_cube[column][panel][layer][0];
          }
        }
      }
#endif
      if (kill==0 && xx==0) {  // if all remaining cells are dead, pause
        delay(10000/myspeed);
      }
      if (kill>0) {  // if there are living cells, wait the desired time
        delay(1000/myspeed);  // between generations.    
        xx=0; // clear a flag that says everyone is dead
      }
      else {
        xx=1;
      }  // set the flag if everyone is dead
    }  // end of generation loop
    if (xx==0) {  // if we got through all 150 generations with live cells
      clearCube();  // clear the cube
      delay(10000/myspeed);  // short pause before starting over. 
    }
  }
#ifndef PICUBE
  delay (1000);
#endif
}
