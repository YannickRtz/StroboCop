public class WalkingEffect extends Effect {

  private int walkerPosition = 0; // Zero based...
  private Color[] colors;
  private boolean timedMode = false;
  private int timedTempo;
  private int startFrame = 0;
  
  public WalkingEffect(Color... colorArray) {
    colors = colorArray;
  }
  
  public WalkingEffect(int offset, Color... colorArray) {
    colors = colorArray;
    walkerPosition += offset;
  }
  
  public WalkingEffect(int offset, int tempo, Color... colorArray) {
    colors = colorArray;
    walkerPosition += offset;
    timedMode = true;
    startFrame = frameCount;
    timedTempo = tempo; // milliseconds
  }

  public void run() {
    
    if (timedMode) {
      int frameDistance = (int)((frameCount - startFrame) % (float)(timedTempo / (1000 / FRAMERATE)));
      if (frameDistance == 0) {
        walkerPosition = (walkerPosition + 1) % NUMBER_OF_SCREENS;
      }
    } else {
      if (analyser.getBeat()) {
        walkerPosition = (walkerPosition + 1) % NUMBER_OF_SCREENS;
      }
    }
    
    Color randomColor = colors[randomInt(colors.length)];
    writeMessageAt(randomColor, walkerPosition + 1); // Not zero based...
  }

}
