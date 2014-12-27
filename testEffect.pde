public class TestEffect {

  private int currentShade = 0;

  public TestEffect() {
    // Constructor
  }

  public void run() {

    writeMessageAt(currentShade, currentShade, currentShade, NUMBER_OF_SCREENS);

    if (beatFreqMix.isKick() && framesDistance == 0) {
      framesDistance = MIN_DISTANCE;
      for (int i = 1; i <= (NUMBER_OF_SCREENS - 1); i++) {
        writeMessageAt((int)random(255), (int)random(255), (int)random(255), i);
      }
    }

    if (beatFreqMix.isSnare() && framesDistance == 0) {
      framesDistance = MIN_DISTANCE;
      if (currentShade == 0) {
        currentShade = 255;
      } else {
        currentShade = 0;
      }
      writeMessageAt(currentShade, currentShade, currentShade, NUMBER_OF_SCREENS);
    }
  }

}
