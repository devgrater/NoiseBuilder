class LazyExtractor{
  
  //spit in a few paths,
  //and it just spits out whatever you need,
  //in each channel.
  ///the rest are nullable but why would you?
  private HashMap<String, PImage> loadedImages = new HashMap<>();
  private PImage channel1;
  private PImage channel2;
  private PImage channel3;
  
  private int targetX = 1024;
  private int targetY = 1024;
  //private PImage output;
  
  public LazyExtractor(String path1, String path2, String path3){
    //assuming that there might be similar paths...
    //and then
    channel1 = loadImageByPath(path1);
    channel2 = loadImageByPath(path2);
    channel3 = loadImageByPath(path3);
  }
  
  private float frac(float value){
    return value - floor(value);
  }
  
  public int getPixelAt(PImage image, int channel, float u, float v){
    if(image == null){
      return 0; //no color at all
    }
    else{
      //bi-linearly filtered
      float pixelXPortion = u * image.width;
      float pixelYPortion = v * image.height;
      
      int flooredX = (int)floor(pixelXPortion);
      int flooredY = (int)floor(pixelYPortion);
      
      color imageColor = image.pixels[flooredY * image.width + flooredX];
      
      return (imageColor >> channel) & 0xFF;
    }
  }
  
  public LazyExtractor setDimensions(int targetX, int targetY){
    //squish and stretch needed
    this.targetX = targetX;
    this.targetY = targetY;
    
    return this;
  }
  
  public PImage paint(){
    //create a target image:
    PImage output = createImage(this.targetX, this.targetY, RGB);
    //and then, for each pixels...
    for(int y = 0; y < this.targetY; y++){
      for(int x = 0; x < this.targetX; x++){
        float u = x / ((float)this.targetX);
        float v = y / ((float)this.targetY);
        //and then, fetch the pixels:
        int rChannel = getPixelAt(channel1, 16, u, v);
        int gChannel = getPixelAt(channel2, 8, u, v);
        int bChannel = getPixelAt(channel3, 0, u, v);
        
        output.set(x, y, color(rChannel, gChannel, bChannel));
      }
    }
    return output;
      
  }
  
  public LazyExtractor saveImage(String filename){
      PImage result = paint();
      result.save(filename);
      return this;
  }
  
  private PImage loadImageByPath(String path){
    if(path == null){
      return null;
    }
    if(loadedImages.containsKey(path)){
      return loadedImages.get(path);
    }
    else{
      PImage image = loadImage(path);
      loadedImages.put(path, image);
      return image;
    }
  }
}
