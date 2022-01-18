
void setup() {
  size(1024, 1024);
  PImage offscreen = createImage(4096, 4096, RGB);
  //
  int stepCount = 256;
  int rowCount = 16; //onceyou draw 4 pics, switch to next row
  int rowSize = 256;
  int drawHeadX = 0;
  int drawHeadY = 0;
  int drawIndex = 0;
  for(int i = 0; i < stepCount; i++){
    
    //float rads = TWO_PI / stepCount * i;
    //int seed = seedFromRad(rads);
    //noiseSeed(seed);
    noiseInRange(offscreen, drawHeadX, drawHeadY, drawHeadX + rowSize, drawHeadY + rowSize, (i / (float)stepCount * 4.0f));
    drawIndex += 1;
    drawHeadX += rowSize;
    if(drawIndex >= rowCount){
      drawIndex = 0;
      drawHeadY += rowSize;
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
      float localX = (x - startX) / ((float)(endX - startX) / 4.0f);
      float localY = (y - startY) / ((float)(endY - startY) / 4.0f);
      float noiseVal = noise(localX, localY, z);
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
