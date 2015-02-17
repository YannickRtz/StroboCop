public class FadeOnSilenceEffect extends Effect {

  private Color myColor;
  private float LOUDNESS_THRESHOLD = 0.02;
  
  public FadeOnSilenceEffect(Color c0) {
    myColor = c0;
  }

  public void run() {
    if (analyser.loudness < LOUDNESS_THRESHOLD) {
      int newAlpha = (int)(255 - 255 * (analyser.loudness / LOUDNESS_THRESHOLD));
      writeMessageAll((int)myColor.getRed(),
                      (int)myColor.getGreen(),
                      (int)myColor.getBlue(),
                      (int)newAlpha);
    }
  }

}
