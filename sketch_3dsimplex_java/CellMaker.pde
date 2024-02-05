class CellMaker3D extends NoiseMaker3D{
  
    
  private ArrayList<PVector> pointCloud; 
  private ArrayList<Float> pval;
  
  
  public CellMaker3D(){
    
  }
  
  public CellMaker3D(int scale, float seed){
    super(scale, seed);
    initialize();
  }
  
  @Override
  public NoiseMaker3D initialize(){
    randomSeed((long)this.seed * 100000);
    this.name = "Cell";
    pointCloud = new ArrayList<>(); 
    pval = new ArrayList<>();
    for(int i = 0; i < scale; i++){
      for(int j = 0; j < scale; j++){
        for(int k = 0; k < scale; k++){
          //PVector scatter = getRandomScatter(i, j, k);
          pointCloud.add(new PVector(random(0,1), random(0,1), random(0,1)));
          pval.add(random(0, 1));
        }
      }
    }
    return this;
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
  
  private float getNoiseValAt(int x, int y, int z){
    //wrap around if that happens
    x = (x + this.scale) % this.scale;
    y = (y + this.scale) % this.scale;
    z = (z + this.scale) % this.scale;
    int index = x * this.scale * this.scale + y * this.scale + z;
    return pval.get(index);
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
    float minColor = 0;
    for(int xId = fx; xId <= cx; xId += 1){
      for(int yId = fy; yId <= cy; yId += 1){
        for(int zId = fz; zId <= cz; zId += 1){
          PVector offset = new PVector(xId, yId, zId).add(getNoiseAt(xId, yId, zId)).sub(new PVector(x, y, z));
          //minDistance = min(offset.mag(), minDistance);
          if(offset.mag() < minDistance){
            minDistance = offset.mag();
            minColor = getNoiseValAt(xId, yId, zId);
          }
        }
      }
    }
    if(this.flipped){
      return 1 - minColor;
    }
    else{
      return minColor;
    }
    
  } 
}
