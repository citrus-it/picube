/*
 * In order to use as the existing ChipKit animations with as few changes
 * as possible, the following macros, functions and global variables are
 * defined.
 * The global variables are used on the ChipKit to reduce memory usage.
 *
 * The animation routines themselves have been split into separate files
 * within the anim/ folder. The main changes required are to stop direct
 * memory access to the cube array and use the LED(), xLED() and copyLED()
 * functions instead which us atomic operations to avoid race conditions
 * between threads.
 */

#define int(x) (int)(x)
#define float(x) (float)(x)
#define random(x) (random() % (x))

static int x3, y3, z3, count3, mywait=50;
static int xx, yy, zz, xx1, yy1, zz1;
static float count;
static float x, y, z, z1;
static int colorCount, counter;
static float myangle, myangle2, rotation;

void manage_color() {
  mycolor=mycolor+10;
  if (mycolor>189){
    mycolor=0;
  } 
  getColor(mycolor, 4);
}

static byte const growTable[4][4] = {
  {3,4,0,0,},
  {2,5,3,4,},
  {1,6,2,5,},
  {0,7,1,6,},
};

#define RedLED(x, y, z) cLED(x, y, z, RED, 63)
#define GreenLED(x, y, z) cLED(x, y, z, GREEN, 63)
#define BlueLED(x, y, z) cLED(x, y, z, BLUE, 63)

