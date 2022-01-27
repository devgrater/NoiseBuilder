
class NoiseMaker3D{
  int scale = 1;
  float seed = 1.661;
  boolean flipped = false;
  protected String name = "Generic";
  
  public NoiseMaker3D(){
    
  }
  
  public NoiseMaker3D(int scale, float seed){
    this.scale = scale;
    this.seed = seed;
  }
  
  public NoiseMaker3D setScale(int scale){
    this.scale = scale;
    return this;
  }
  
  public NoiseMaker3D setSeed(float seed){
    this.seed = seed;
    return this;
  }
  
  public NoiseMaker3D setFlipped(boolean flipped){
    this.flipped = flipped;
    return this;
  }
  
  public NoiseMaker3D setFlipped(){
    return setFlipped(true);
  }
  
  public String getMakerName(){
    return this.name;
  }
  
  public String getMakerShortHand(){
    return "" + name.charAt(0);
  }
  
  public NoiseMaker3D initialize(){
    return this;
  }
  
  public float noise(float x, float y, float z){
    return 0.0f;
  }
  
  public color coloredNoise(float x, float y, float z){
    return color((int)floor(noise(x, y, z) * 255));
  }
  
  public int toIntColor(float floatColor){
    return (int)floor(floatColor * 255);
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
