class VoronoiMaker3D extends NoiseMaker3D{
  private ArrayList<PVector> pointCloud;
  public VoronoiMaker3D(int scale, float seed){
    super(scale, seed);
    this.name = "Simplex";
    initialize();
  }
  
  @Override
  public void initialize(){
    pointCloud = new ArrayList<>(); 
    for(int i = 0; i < scale; i++){
      for(int j = 0; j < scale; j++){
        for(int k = 0; k < scale; k++){
          PVector scatter = getRandomScatter(i, j, k);
          print(scatter);
          pointCloud.add(scatter);
        }
      }
    }
  }
  
  private PVector getNoiseAt(int x, int y, int z){
    //wrap around if that happens
    x = (x + this.scale) % this.scale;
    y = (y + this.scale) % this.scale;
    z = (z + this.scale) % this.scale;
    //retrieve data:
    
    int index = x * this.scale * this.scale + y * this.scale + z;
    return pointCloud.get(index);
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
    
    return nearestDistance(flooredX - 1, flooredY - 1, flooredZ - 1, ceiledX, ceiledY, ceiledZ, loopX, loopY, loopZ);
  }
  
  private float nearestDistance(int fx, int fy, int fz, int cx, int cy, int cz, float x, float y, float z){
    float minDistance = this.scale; //you can never go beyond this distance, no matter what.
    for(int xId = fx; xId <= cx; xId += 1){
      for(int yId = fy; yId <= cy; yId += 1){
        for(int zId = fz; zId <= cz; zId += 1){
          PVector offset = new PVector(xId, yId, zId).add(getNoiseAt(xId, yId, zId)).sub(new PVector(x, y, z));
          PVector testPoint = new PVector(xId, yId, zId).add(getNoiseAt(xId, yId, zId));
          if((floor(testPoint.x) > xId) || (floor(testPoint.y) > yId) || (floor(testPoint.z) > zId)){
             print("warning");
          }
          minDistance = min(offset.mag(), minDistance);
        }
      }
    }
    return minDistance;
  }
  
  private PVector getRandomScatter(int x, int y, int z){
    return new PVector(
    //noisefunction is fucking expensive...
    //only record the offset from the original position, as we have wrap arounds.
      noiseFunction(y, z),
      noiseFunction(x, z),
      noiseFunction(x, y)
    );
  }
}
