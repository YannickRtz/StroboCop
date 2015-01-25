public class TestEffect extends Effect {

  private int currentShade = 0;
  private int framesDistance = 0;
  private int MIN_DISTANCE = 4;

  public TestEffect() {
    // Constructor
  }

  public void run() {
  
    if (framesDistance > 0) { framesDistance--; }

    writeMessageAt(currentShade, currentShade, currentShade, NUMBER_OF_SCREENS);

    if (analyser.getBeat()) {
      framesDistance = MIN_DISTANCE;
      for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
        writeMessageAt(random(255), random(255), random(255), i);
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
