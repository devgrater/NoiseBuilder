static class ImageChannel{
  public static final int RED = 1;
  public static final int GREEN = 2;
  public static final int BLUE = 4;
}


class ChannelExtractor{
  private int[] channelWeight = {0, 0, 0};
  private PImage image;
  private int sizeX;
  private int sizeY;
  
  private int targetSizeX;
  private int targetSizeY;
  public ChannelExtractor(String path, int packChannels){


    //if needed, you can downscale this.
  }
  
  public ChannelExtractor resize(int newX, int newY){
    this.targetSizeX = newX;
    this.targetSizeY = newY;
    return this;
  }
  
  public ChannelExtractor setImage(String path){
    this.image = loadImage(path); // assuming that the path exists.
    this.image.loadPixels();
    this.sizeX = image.width;
    this.sizeY = image.height;
    this.targetSizeX = this.sizeX;
    this.targetSizeY = this.sizeY;
    return this;
  }
  
  public ChannelExtractor setChannel(int bitwiseChannels){
    this.channelWeight[0] = 0;
    this.channelWeight[1] = 0;
    this.channelWeight[2] = 0;
    if((bitwiseChannels & ImageChannel.RED) == ImageChannel.RED){
      channelWeight[0] = 1;
    }
    if((bitwiseChannels & ImageChannel.GREEN) == ImageChannel.GREEN){
      channelWeight[1] = 1;
    }
    if((bitwiseChannels & ImageChannel.BLUE) == ImageChannel.BLUE){
      channelWeight[2] = 1;
    }
    return this;
  }
  
}
