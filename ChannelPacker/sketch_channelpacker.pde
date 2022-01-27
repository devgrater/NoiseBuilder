
//String[] defaultArgs = {"img1.png", "img2.png"};

final int windowSize = 512;

void settings(){
  size(windowSize, windowSize);
}

void setup(){
  //load the images...
  
  //
  LazyExtractor le = new LazyExtractor("noise3D_8.png", "Perlin3D_8.png", null)
  .setDimensions(4096, 4096);
  PImage result = le.paint();
  image(result, 0, 0, windowSize, windowSize);
  result.save("output.png");
  print("Output saved as output.png.");
}
