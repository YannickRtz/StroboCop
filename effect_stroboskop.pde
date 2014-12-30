public class StroboskopEffect extends Effect {

  private Color[] colors;
  private boolean animating = false;
  private int screenNumber = 0; // 0: All screens -1: random Screens
  private int currentScreen = 0;
  private Color currentColor;
  private boolean animationState = false;
  private float propability = 0;
  private int eventType = Analyser.BEAT;
  
  public StroboskopEffect(int eventType,
                          int screenNumber,
                          float propability,
                          Color... colorArray) {
    this.screenNumber = screenNumber;
    this.propability = propability;
    this.eventType = eventType;
    colors = colorArray;
    currentColor = colors[randomInt(colors.length)];
    if (screenNumber == -1) {
      currentScreen = randomInt(NUMBER_OF_SCREENS) + 1;
    }
  }
  
  public void run() {
    if (analyser.getBeat(eventType)) {
      if (random(1) < 0.5 && animating) {
        animating = false;
      } else if (random(1) < propability && !animating) {
        animating = true;
      }
    }
    if (animating == false) {
      currentColor = colors[randomInt(colors.length)];
      if (screenNumber == -1) {
        currentScreen = randomInt(NUMBER_OF_SCREENS) + 1;
      }
    } else {
      if (animationState == false) {
        if (screenNumber > 0) {
          writeMessageAt(currentColor, screenNumber);
        } else if (screenNumber == 0) {
          for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
            writeMessageAt(currentColor, i + 1);
          }
        } else if (screenNumber == -1) {
          writeMessageAt(currentColor, currentScreen);
        }
        animationState = true;
      } else {
        animationState = false;
      }
    }
  }

}