final int SCREEN_SIZE = 1024;
//final int STEP_COUNT = 256; //default: 256 steps
final int LAYER_SIZE = 256; //default: 256
final int ATLAS_DIMENSION = 4096;
//16 means 16 points, per noise grid.
PerlinMaker3D pm = new PerlinMaker3D(4, 4, 4, 8, 44100);

void setup() {
  size(1024, 1024);
  
  PImage offscreen = createImage(4096, 4096, RGB);
  
  //
  int rowCount = ATLAS_DIMENSION / LAYER_SIZE; //onceyou draw this many pics, switch to next row
  int STEP_COUNT = rowCount * rowCount;
  int drawHeadX = 0;
  int drawHeadY = 0;
  int drawIndex = 0;
  for(int i = 0; i < STEP_COUNT; i++){
    
    //float rads = TWO_PI / stepCount * i;
    //int seed = seedFromRad(rads);
    //noiseSeed(seed);
    noiseInRange(offscreen, drawHeadX, drawHeadY, drawHeadX + LAYER_SIZE, drawHeadY + LAYER_SIZE, (i / (float)STEP_COUNT));
    drawIndex += 1;
    drawHeadX += LAYER_SIZE;
    if(drawIndex >= rowCount){
      drawIndex = 0;
      drawHeadY += LAYER_SIZE;
      drawHeadX = 0;
    }
  }
  
  image(offscreen, 0, 0, 1024, 1024);
  offscreen.save("noise3D.png");
}

void noiseInRange(PImage image, int startX, int startY, int endX, int endY, float z){
  int imageWidth = image.width;
  for(int x = startX; x < endX; x++){
    for(int y = startY; y < endY; y++){
      float localX = (x - startX) / ((float)(endX - startX));
      float localY = (y - startY) / ((float)(endY - startY));
      float noiseVal = pm.noise(localX, localY, z);//noise(localX, localY, z);
      int pColor = (int)floor(noiseVal * 256);
      image.pixels[y * imageWidth + x] = color(pColor);
    }
  }
}

int seedFromRad(float rad){
  float xComponent = cos(rad);
  float yComponent = sin(rad);
  int res = (int)floor(167 * xComponent + 33 * yComponent);
  return res;
}
