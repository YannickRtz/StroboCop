public class SimpleChangeEffect extends Effect {

  private Color[] colors;
  private int screenNumber = -1; // 0: All screens same color, -1: All screens random color
  private int eventType = Analyser.BEAT;
  
  private Color currentColor;
  private int currentColorIndex = 0;
  private Color[] currentColorsArray = new Color[NUMBER_OF_SCREENS];
  
  public SimpleChangeEffect(int eventType,
                           int screenNumber,
                           ColorPalette palette) {
    this.screenNumber = screenNumber;
    colors = palette.toArray();
    this.eventType = eventType;
    currentColor = colors[0];
    for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
      currentColorsArray[i] = colors[randomInt(colors.length)];
    }
  }
  
  public void run() {
    if (analyser.getBeat(eventType)) {
      currentColor = colors[currentColorIndex];
      currentColorIndex = (currentColorIndex + 1) % colors.length;
      if (screenNumber == -1) {
        // all screens random color
        for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
          currentColorsArray[i] = colors[randomInt(colors.length)];
        }
      }
    }
    if (screenNumber > 0) {
      // single screen
      writeMessageAt(currentColor, screenNumber % NUMBER_OF_SCREENS);
    } else if (screenNumber == 0) {
      // all screens same color
      writeMessageAll(currentColor);
    } else if (screenNumber == -1) {
      for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
        writeMessageAt(currentColorsArray[i-1], i);
      }
    }
  }

}
