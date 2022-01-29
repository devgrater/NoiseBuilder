class NoiseMakerMultiChannel extends NoiseMaker3D{
  private ArrayList<NoiseMaker3D> noiseMakers;
  
  private NoiseMaker3D channelR;
  private NoiseMaker3D channelG;
  private NoiseMaker3D channelB;

  
  public NoiseMakerMultiChannel(){
    this.name = "MultiChannel_";
  }
  
  public NoiseMakerMultiChannel setR(NoiseMaker3D noise){
    this.channelR = noise;
    return this;
  }
  
  public NoiseMakerMultiChannel setG(NoiseMaker3D noise){
    this.channelG = noise;
    return this;
  }
  
  public NoiseMakerMultiChannel setB(NoiseMaker3D noise){
    this.channelB = noise;
    return this;
  }
  
  public NoiseMakerMultiChannel add(NoiseMaker3D noise){
    noiseMakers.add(noise);
    this.name += noise.getMakerShortHand();
    return this;
  }
  
  @Override
  public color coloredNoise(float x, float y, float z){
    float rChannel = channelR != null? channelR.noise(x, y, z) : this.noise(x, y, z);
    float gChannel = channelG != null? channelG.noise(x, y, z) : this.noise(x, y, z);
    float bChannel = channelB != null? channelB.noise(x, y, z) : this.noise(x, y, z);
    
    return color(
      toIntColor(rChannel),
      toIntColor(gChannel),
      toIntColor(bChannel)
    );
  }
}
