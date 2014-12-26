public class Analyser {
  
  private int BUFFER_SIZE = FRAMERATE * 4;
  private byte[] buffer = new byte[BUFFER_SIZE];
  
  public int regularity;
  public int mostRegularEvent;
  public int intensity;
  public int stereoness;
  public int mostLeftEvent;
  public int mostRightEvent;
  
  public Analyser() {
    // Constructor
  }
  
  // BeatDetect.detect() has to be executed before this.
  public void analyse() {
      // First: Fill buffer with BeatDetect results
  
      /* What can we do here?
        - Analyse for silence / pauses
        - Analyse for regularity of a value
        - Analyse for intensity / levels
        - Analyse for stereoness (big differences in left / right channel)
        */
  }
}