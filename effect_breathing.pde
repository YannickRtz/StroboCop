public class BreathingEffect extends Effect {

  private Color[] colors;
  private int duration = 0;
  private float animationFrame = 0;
  private int screenNumber = 0; // 0: All screens -1: random Screens
  private int currentScreen = 0;
  private Color currentColor;
  private int durationInFrames = 0;

  public BreathingEffect(int screenNumber, int duration, int offset, ColorPalette palette) {
    this.screenNumber = screenNumber;
    colors = palette.toArray();
    this.duration = duration;
    durationInFrames = duration / (1000 / FRAMERATE);
    animationFrame = (int)offset / (1000 / FRAMERATE);
    currentColor = colors[randomInt(colors.length)];
    if (screenNumber == -1) {
      currentScreen = randomInt(NUMBER_OF_SCREENS) + 1;
    }
  }

  public void run() {
    if (animationFrame == 0) {
      currentColor = colors[randomInt(colors.length)];
      if (screenNumber == -1) {
        currentScreen = randomInt(NUMBER_OF_SCREENS) + 1;
      }
    }

    animationFrame = (animationFrame + 1) % durationInFrames;

    int newAlpha;
    if (animationFrame < durationInFrames / 2) {
      newAlpha = (int)(250 * (animationFrame / (durationInFrames / 2)));
    } else {
      newAlpha = (int)(250 * ((durationInFrames - animationFrame) / (durationInFrames / 2)));
    }
    newAlpha = (int)(currentColor.getAlpha() * ((float)newAlpha / 255));

    if (screenNumber > 0) {
      writeMessageAt(currentColor.getRed(),
                     currentColor.getGreen(),
                     currentColor.getBlue(),
                     newAlpha,
                     screenNumber);
    } else if (screenNumber == 0) {
      for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
        writeMessageAt(currentColor.getRed(),
                       currentColor.getGreen(),
                       currentColor.getBlue(),
                       newAlpha,
                       i + 1);
      }
    } else if (screenNumber == -1) {
      writeMessageAt(currentColor.getRed(),
                     currentColor.getGreen(),
                     currentColor.getBlue(),
                     newAlpha,
                     currentScreen);
    }
  }

}
