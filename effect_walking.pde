public class WalkingEffect extends Effect {

  private int walkerPosition = 0; // Zero based...
  private Color[] colors;
  private boolean timedMode = false;
  private int timedTempo;
  private int startFrame = 0;
  private boolean randomMode = false;
  private int eventType = Analyser.BEAT;

  public WalkingEffect(ColorPalette palette) {
    colors = palette.toArray();
  }

  public WalkingEffect(int eventType,
                       boolean randomMode,
                       int offset,
                       ColorPalette palette) {
    colors = palette.toArray();
    this.eventType = eventType;
    this.randomMode = randomMode;
    walkerPosition += offset;
  }

  public WalkingEffect(int eventType,
                       boolean randomMode,
                       int offset,
                       int tempo,
                       ColorPalette palette) {
    colors = palette.toArray();
    this.eventType = eventType;
    this.randomMode = randomMode;
    walkerPosition += offset;
    timedMode = true;
    startFrame = frameCount;
    timedTempo = tempo; // milliseconds
  }

  public void run() {
    if (timedMode) {
      int frameDistance = (int)((frameCount - startFrame) % (float)(timedTempo / (1000 / FRAMERATE)));
      if (frameDistance == 0) {
        advanceWalker();
      }
    } else {
      if (analyser.getBeat(eventType)) {
        advanceWalker();
      }
    }

    Color randomColor = colors[randomInt(colors.length)];
    writeMessageAt(randomColor, walkerPosition + 1); // Not zero based...
  }

  public void advanceWalker() {
    if (randomMode) {
      walkerPosition = randomInt(NUMBER_OF_SCREENS);
    } else {
      walkerPosition = (walkerPosition + 1) % NUMBER_OF_SCREENS;
    }
  }
}
