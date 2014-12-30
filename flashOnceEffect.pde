public class FlashOnceEffect extends Effect {

  private Color[] colors;
  private boolean flickerMode = false;
  private int startFrame = 0;
  private int screenNumber = 1;
  private int duration = 0;
  int durationFrames = 0;
  
  public FlashOnceEffect(int screenNumber, int duration, Color... colorArray) {
    colors = colorArray;
    this.screenNumber = screenNumber;
    this.duration = duration;
    durationFrames = duration / (1000 / FRAMERATE);
  }
  
  public FlashOnceEffect(int screenNumber, int duration, boolean mode, Color... colorArray) {
    colors = colorArray;
    durationFrames = duration / (1000 / FRAMERATE);
    this.screenNumber = screenNumber;
    this.duration = duration;
    flickerMode = mode;
  }
  
  public void start() {
    startFrame = frameCount;
  }
  
  public void setColors(Color... colorArray) {
    colors = colorArray;
  }
  
  public void run() {
    int framesPast = frameCount - startFrame + 1;
    if (framesPast < durationFrames) {
      float progress = (float)framesPast / (float)durationFrames;
      if (flickerMode) {
        // TODO(yannick)
      } else {
        Color randomColor = colors[randomInt(colors.length)];
        writeMessageAt(randomColor.getRed(),
                       randomColor.getGreen(),
                       randomColor.getBlue(),
                       randomColor.getAlpha() * (1 - progress),
                       screenNumber);
      }
    }
  }

}