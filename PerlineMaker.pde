
class PerlinMaker3D{
  float lrX = 1.0;
  float lrY = 1.0;
  float lrZ = 1.0;
  int scale = 16;
  float seed = 1.661;
  
  //ArrayList<PVector> gridPoints = new ArrayList<>();
  
  public PerlinMaker3D(){
    
  }
    
  public PerlinMaker3D(float lrX, float lrY, float lrZ, int scale, float seed){
    this.lrX = lrX;
    this.lrY = lrY;
    this.lrZ = lrZ;
    this.scale = scale;
    this.seed = seed;
  }
  /*
  private float interpolate(float a0, float a1, float w){
    return (a1 - a0) * ((w * (w * 6.0f - 15.0f) + 10.0f) * w * w * w) + a0;
  }*/
  
  private float interpolate(float a0, float a1, float w){
    return (a1 - a0) * w + a0;
  }
  
  private float interpFactor(float w){
    return ((w * (w * 6.0f - 15.0f) + 10.0f) * w * w * w);
  }
  
  
  public float noise(float x, float y, float z){
    float loopX = x * this.scale % ((float)this.scale);
    float loopY = y * this.scale % ((float)this.scale);
    float loopZ = z * this.scale % ((float)this.scale);
    
    
    //which one is closer?
    int closerX = (int) round(loopX);
    int closerY = (int) round(loopY);
    int closerZ = (int) round(loopZ);
    
    int wrapX = closerX % this.scale;
    int wrapY = closerY % this.scale;
    int wrapZ = closerZ % this.scale;
    
    //find the vector
    PVector currentPixelVector = new PVector(
      loopX - closerX,
      loopY - closerY,
      loopZ - closerZ + 0.001f
    );
    
    float noiseBase = noiseFunction(currentPixelVector, sphereVector(wrapX, wrapY, wrapZ));
    return (noiseBase + 1.0f) / 2.0f;
  }
  /*
  public float noise(float x, float y, float z){
    //something feels off....
    
    float loopX = (x % this.lrX) * this.scale;
    float loopY = (y % this.lrY) * this.scale;
    float loopZ = (z % this.lrZ) * this.scale;
    int flooredX = (int) floor(loopX);
    int flooredY = (int) floor(loopY);
    int flooredZ = (int) floor(loopZ);
    
    int ceiledX = flooredX + 1;
    int ceiledY = flooredY + 1;
    int ceiledZ = flooredZ + 1;
    
    float fracX = loopX - flooredX;
    float fracY = loopY - flooredY;
    float fracZ = loopZ - flooredZ;
    
    
    //and then, you need to interpolate cubic....
    //or, in a more human way to say it:
    //trilinear interpolation.
    
    float xinterpFactor = interpFactor(fracX);
    float yinterpFactor = interpFactor(fracY);
    float zinterpFactor = interpFactor(fracZ);
    //interpolate itx = fx, cx at fy fz
    float fx_fy_fz = noiseFunction(flooredX, flooredY, flooredZ);
    float cx_fy_fz = noiseFunction(ceiledX, flooredY, flooredZ);
    float itx = interpolate(fx_fy_fz, cx_fy_fz, xinterpFactor);
    
    //interpolate itx2 = fx, cx at cy fz
    float fx_cy_fz = noiseFunction(flooredX, ceiledY, flooredZ);
    float cx_cy_fz = noiseFunction(ceiledX, ceiledY, flooredZ);
    float itx2 = interpolate(fx_cy_fz, cx_cy_fz, xinterpFactor);
    
    float ity = interpolate(itx, itx2, yinterpFactor);
    
    //interpolate itx3 = fx, cx at fy cz
    float fx_fy_cz = noiseFunction(flooredX, flooredY, ceiledZ);
    float cx_fy_cz = noiseFunction(ceiledX, flooredY, ceiledZ);
    float itx3 = interpolate(fx_fy_cz, cx_fy_cz, xinterpFactor);
    //interpolate itx4 = fx, cx at cy cz
    float fx_cy_cz = noiseFunction(flooredX, ceiledY, ceiledZ);
    float cx_cy_cz = noiseFunction(ceiledX, ceiledY, ceiledZ);
    float itx4 = interpolate(fx_cy_cz, cx_cy_cz, xinterpFactor);
    
    float ity2 = interpolate(itx3, itx4, yinterpFactor);
    
    //putting it together...
    return interpolate(ity, ity2, zinterpFactor);
  }*/
  

  
  private float frac(float input){
    return input - floor(input);
  }
  
  private float dot(float x, float y, float z, float x2, float y2, float z2){
    return x * x2 + y * y2 + z * z2;
  }
  
  private float dot(float x, float y, float x2, float y2){
    return x * x2 + y * y2;
  }
  
  public float noiseFunction(PVector v1, PVector v2){
    return v1.normalize().dot(v2.normalize());
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
      outVector.x = -outVector.x;
      outVector.y = -outVector.y;
      outVector.z = -outVector.z;
      return outVector;
      //return outVector.mult(-1); // reverse direction
    }
  }
  
  public PVector hemisphereVector(int x, int y, int z){
    float phi = noiseFunction(x - z, y + z) * 6.28318f;
    float cos_t = sqrt(noiseFunction(x - y, z - x));
    float sin_t = sqrt(1 - cos_t * cos_t);
    float out_x = cos(phi) * sin_t;
    float out_y = sin(phi) * sin_t;
    float out_z = cos_t;
    return new PVector(out_x, out_y, out_z + 0.001).normalize();
  }
  
    
  public float noiseFunction(float x, float y){
    //lets just start with a random color.
    float rnd = frac(sin(dot(x, y, 12.9898f, 78.233f)) * (43758.5453123f + seed) + x);
    return rnd;
  }
  
  public float noiseFunction(float x, float y, float z){
    //lets just start with a random color.
    float rnd = frac(sin(dot(x, y, z, 12.9898f, 78.233f, 1116.156f)) * (43758.5453123f + seed + z) + x);
    return rnd * 2.0 - 1.0f;
  }
  
  
}
