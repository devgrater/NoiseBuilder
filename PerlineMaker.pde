
class PerlinMaker3D{
  float lrX = 1.0;
  float lrY = 1.0;
  float lrZ = 1.0;
  float scale = 300;
  float seed = 1.661;
  
  public PerlinMaker3D(){
    
  }
    
  public PerlinMaker3D(float lrX, float lrY, float lrZ, float seed){
    this.lrX = lrX;
    this.lrY = lrY;
    this.lrZ = lrZ;
    this.seed = seed;
  }
  
  public float noise(float x, float y, float z){
    float loopX = x % this.lrX;
    float loopY = y % this.lrY;
    float loopZ = z % this.lrZ;
    int flooredX = (int) floor(loopX * this.scale);
    int flooredY = (int) floor(loopY * this.scale);
    int flooredZ = (int) floor(loopZ * this.scale);
    
    return noiseFunction(flooredX, flooredY, flooredZ);
  }
  
  private float frac(float input){
    return input - floor(input);
  }
  
  private float dot(float x, float y, float z, float x2, float y2, float z2){
    return x * x2 + y * y2 + z * z2;
  }
  
  private float dot(float x, float y, float x2, float y2){
    return x * x2 + y * y2;
  }
  
  public float noiseFunction(int x, int y, int z){
    //lets just start with a random color.
    return frac(sin(dot(x, y, z, 12.9898f, 78.233f, 1116.156f)) * (43758.5453123f + seed + z) + x);
  }
  
  
}
