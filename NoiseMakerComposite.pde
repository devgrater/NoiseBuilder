class NoiseMakerComposite extends NoiseMaker3D{
  private ArrayList<NoiseMaker3D> noiseMakers;
  public NoiseMakerComposite(){
    this.name = "Composite_";
    noiseMakers = new ArrayList<>();
  }
  
  public NoiseMakerComposite add(NoiseMaker3D noise){
    noiseMakers.add(noise);
    this.name += noise.getMakerShortHand();
    return this;
  }
  
  @Override
  public float noise(float x, float y, float z){
    float noiseCompo = 0.0f;
    float weight = 1.0f;
    for(int i = 0; i < noiseMakers.size(); i++){
      weight *= 0.5f;
      noiseCompo += weight * noiseMakers.get(i).noise(x, y, z);
    }
    if(this.flipped){
      return 1 - noiseCompo;
    }
    else{
      return noiseCompo;
    }
  }
}
