
class PerlinMaker3D extends NoiseMaker3D{

  
  ArrayList<PVector> gridVecs = new ArrayList<>();
  
  public PerlinMaker3D(){
    super(1, 13165.11f);
    this.name = "Perlin";
  }
    
  public PerlinMaker3D(int scale, float seed){
    super(scale, seed);
    this.name = "Perlin";
  }
  
  @Override
  public void initialize(){
    //precompute because there is sooo many repetitive data...
  }
  /*
  private float interpolate(float a0, float a1, float w){
    return (a1 - a0) * ((w * (w * 6.0f - 15.0f) + 10.0f) * w * w * w) + a0;
  }*/
  
  private float interpolate(float a0, float a1, float w){
    return (a1 - a0) * w + a0;
  }
  
  private float smoothstep(float w){
    return ((w * (w * 6.0f - 15.0f) + 10.0f) * w * w * w);
  }
  
  @Override
  public float noise(float x, float y, float z){
    float loopX = x * this.scale;
    float loopY = y * this.scale;
    float loopZ = z * this.scale;
    

    
    int flooredX = (int) floor(loopX);
    int flooredY = (int) floor(loopY);
    int flooredZ = (int) floor(loopZ);
    
    int ceiledX = (flooredX + 1);
    int ceiledY = (flooredY + 1);
    int ceiledZ = (flooredZ + 1);
    
    float fracX = loopX - flooredX;
    float fracY = loopY - flooredY;
    float fracZ = loopZ - flooredZ;
    
    
    float interpX = smoothstep(fracX);
    float interpY = smoothstep(fracY);
    float interpZ = smoothstep(fracZ);
   
    //remember that this hasen't been normalized
    //so you can essentially just do 1-x to flip the direction
    PVector pos = new PVector(x, y, z);
     
    //whatever you do....
    //compute gradient relative to fx, fy, fz
    float gradFXFYFZ = noiseFunction(loopX, loopY, loopZ, flooredX, flooredY, flooredZ);
    float gradCXFYFZ = noiseFunction(loopX, loopY, loopZ,  ceiledX, flooredY, flooredZ);
    
    //interpolate them two (save for later)
    float gradFYFZ = interpolate(gradFXFYFZ, gradCXFYFZ, interpX);

    //now, fx, cy, fz
    float gradFXCYFZ = noiseFunction(loopX, loopY, loopZ,  flooredX, ceiledY, flooredZ);
    float gradCXCYFZ = noiseFunction(loopX, loopY, loopZ, ceiledX, ceiledY, flooredZ);
    
    //interpolate (save for later)
    float gradCYFZ = interpolate(gradFXCYFZ, gradCXCYFZ, interpX);
    float gradFZ = interpolate(gradFYFZ, gradCYFZ, interpY);
    
    
    //finally, fx, fy, cz
    float gradFXFYCZ = noiseFunction(loopX, loopY, loopZ,  flooredX, flooredY, ceiledZ);
    float gradCXFYCZ = noiseFunction(loopX, loopY, loopZ,  ceiledX, flooredY, ceiledZ);
    
    float gradFYCZ = interpolate(gradFXFYCZ, gradCXFYCZ, interpX);
    
    //interpolate (save for later)
    float gradFXCYCZ = noiseFunction(loopX, loopY, loopZ,  flooredX, ceiledY, ceiledZ);
    float gradCXCYCZ = noiseFunction(loopX, loopY, loopZ,  ceiledX, ceiledY, ceiledZ);
    
    float gradCYCZ = interpolate(gradFXCYCZ, gradCXCYCZ, interpX);
    float gradCZ = interpolate(gradFYCZ, gradCYCZ, interpY);
    
    return (interpolate(gradFZ, gradCZ, interpZ) + 1.0) / 2.0f;
  }
  
  
  
  public float noiseFunction(float px, float py, float pz, int x, int y, int z){
    float fx = px - (float)x;
    float fy = py - (float)y;
    float fz = pz - (float)z;
    
    //then....
    //get a sphereVector!
    PVector sphere = sphereVector(x % this.scale, y % this.scale, z % this.scale);
    
    return fx * sphere.x + fy * sphere.y + fz * sphere.z;
  }
  
  /*
  public PVector noiseVector(PVector inVector){
    //cosine hemisphere...
  }
  */
  
  
  
  public PVector sphereVector(int x, int y, int z){
    float rnd = noiseFunction(x, y, z);
    PVector outVector = hemisphereVector(x, y, z);
    if(rnd < 0){
      return outVector;
    }
    else{
      /*outVector.x = -outVector.x;
      outVector.y = -outVector.y;
      outVector.z = -outVector.z;
      return outVector;*/
      return outVector.mult(-1); // reverse direction
    }
  }
  
  public PVector hemisphereVector(int x, int y, int z){
    float phi = noiseFunction(x - z, y + z) * 6.28318f;
    float cos_t = sqrt(noiseFunction(x - y, z - x));
    float sin_t = sqrt(1 - cos_t * cos_t);
    float out_x = cos(phi) * sin_t;
    float out_y = sin(phi) * sin_t;
    float out_z = cos_t;
    return new PVector(out_x, out_y, out_z);
  }
  
    

  
  
}
