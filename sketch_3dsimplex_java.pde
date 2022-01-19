final int SCREEN_SIZE = 1024;
//final int STEP_COUNT = 256; //default: 256 steps
final int LAYER_SIZE = 256; //default: 256
final int ATLAS_DIMENSION = 4096;
final int GRID_SIZE = 8;
//16 means 16 points, per noise grid.
NoiseMaker3D pm = new NoiseMakerComposite()
  .add(new VoronoiMaker3D().setScale(3).setSeed(1212.1).setFlipped(true).initialize())
  .add(new VoronoiMaker3D().setScale(5).setSeed(24212.1).setFlipped(true).initialize())
  .add(new VoronoiMaker3D().setScale(7).setSeed(24212.1).setFlipped(true).initialize())
  .add(new PerlinMaker3D().setScale(9).setSeed(4412.1).initialize())
  .add(new PerlinMaker3D().setScale(14).setSeed(12132.1).initialize())
  .add(new PerlinMaker3D().setScale(20).setSeed(1232.1).initialize());

int step_val;
int drawHeadX = 0;
int drawHeadY = 0;
int drawIndex = 0;
PImage offscreen = createImage(4096, 4096, RGB);
boolean hasStopped = false;

void setup() {
  size(1024, 1024);
  
}



void draw(){
  
  int rowCount = ATLAS_DIMENSION / LAYER_SIZE; //onceyou draw this many pics, switch to next row
  int STEP_COUNT = rowCount * rowCount;
  
  if(step_val >= STEP_COUNT){
    //stop drawing!
    if(!hasStopped){
      offscreen.save(pm.getMakerName() + "3D" + "_" + GRID_SIZE + ".png");
      hasStopped = true;
    }
  }
  else{
    //background(0);
    //float rads = TWO_PI / stepCount * i;
    //int seed = seedFromRad(rads);
    //noiseSeed(seed);
    noiseInRange(offscreen, drawHeadX, drawHeadY, drawHeadX + LAYER_SIZE, drawHeadY + LAYER_SIZE, (step_val / (float)STEP_COUNT));
    drawIndex += 1;
    drawHeadX += LAYER_SIZE;
    if(drawIndex >= rowCount){
      drawIndex = 0;
      drawHeadY += LAYER_SIZE;
      drawHeadX = 0;
    }
    offscreen.updatePixels();
    image(offscreen, 0, 0, SCREEN_SIZE, SCREEN_SIZE);
  }
  step_val += 1;
  
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
