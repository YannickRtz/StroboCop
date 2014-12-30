public class FlashOnBeatEffect extends Effect {

  private Color[] colors;
  private boolean flickerMode = false;
  private int screenNumber = -1; // 0: All Screens, -1: Random Screen
  private FlashOnceEffect[] flashs;
  private int eventType = Analyser.BEAT;

  public FlashOnBeatEffect(int eventType,
                           boolean mode,
                           int screenNumber,
                           int duration,
                           ColorPalette palette) {
    flickerMode = mode;
    this.screenNumber = screenNumber;
    colors = palette.toArray();
    this.eventType = eventType;
    flashs = new FlashOnceEffect[NUMBER_OF_SCREENS];
    for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
      flashs[i] = new FlashOnceEffect(i + 1, duration, flickerMode, colorArray);
    }
  }

  public void run() {
    if (analyser.getBeat(eventType)) {
      if (screenNumber > 0) {
        flashs[screenNumber - 1].start();
      } else if (screenNumber == 0) {
        for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
          flashs[i].start();
        }
      } else if (screenNumber == -1) {
        flashs[randomInt(NUMBER_OF_SCREENS)].start();
      }
    }
    for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
      flashs[i].run();
    }
  }

}
