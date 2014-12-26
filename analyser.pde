public class Analyser {
  
  private int BUFFER_SIZE = FRAMERATE * 4;
  private MainBufferObject[] buffer = new MainBufferObject[BUFFER_SIZE];
  private int bufferIndex = 0;
  private int SILENCE_THRESHOLD = FRAMERATE; // Two hits in during this period break the silence
  
  // Event types
  public final int ONSET = 0;
  public final int KICK = 1;
  public final int SNARE = 2;
  public final int HAT = 3;
  
  // Public variables
  public int regularity;
  public int mostRegularEvent;
  public int intensity;
  public int stereoness;
  public int mostLeftEvent;
  public int mostRightEvent;
  public float silenceDurationSeconds = 0;
  
  public Analyser() {
    // Constructor
  }
  
  class SubBufferObject {
    public boolean isOnset;
    public boolean isKick;
    public boolean isSnare;
    public boolean isHat;
  }
  
  class MainBufferObject {
    public SubBufferObject mix = new SubBufferObject();
    public SubBufferObject left = new SubBufferObject();
    public SubBufferObject right = new SubBufferObject();
  }
  
  // BeatDetect.detect() has to be executed before this.
  public void analyse() {
      
      fillBuffer();
      
      analyseSilence();
      
      /* What can we do here?
        - Analyse for silence / pauses
        - Analyse for regularity of a value
        - Analyse for intensity / levels
        - Analyse for stereoness (big differences in left / right channel)
        */
  }
  
  private void fillBuffer() {
    MainBufferObject newBufferItem = new MainBufferObject();
    
    newBufferItem.mix.isOnset = beatSoundMix.isOnset();
    newBufferItem.mix.isKick = beatFreqMix.isKick();
    newBufferItem.mix.isSnare = beatFreqMix.isSnare();
    newBufferItem.mix.isHat = beatFreqMix.isHat();
    
    newBufferItem.left.isOnset = beatSoundLeft.isOnset();
    newBufferItem.left.isKick = beatFreqLeft.isKick();
    newBufferItem.left.isSnare = beatFreqLeft.isSnare();
    newBufferItem.left.isHat = beatFreqLeft.isHat();
    
    newBufferItem.right.isOnset = beatSoundRight.isOnset();
    newBufferItem.right.isKick = beatFreqRight.isKick();
    newBufferItem.right.isSnare = beatFreqRight.isSnare();
    newBufferItem.right.isHat = beatFreqRight.isHat();
    
    bufferIndex = (bufferIndex + 1) % BUFFER_SIZE;
    buffer[bufferIndex] = newBufferItem;
  }
  
  private void analyseSilence() {
    silenceDurationSeconds += 1 / FRAMERATE;
    
    if (buffer[bufferIndex].mix.isOnset) {
      int index;
      for (int i = 0; i < SILENCE_THRESHOLD; i++) {
        index = (bufferIndex - i) % BUFFER_SIZE;
        if (buffer[index].mix.isOnset) {
          silenceDurationSeconds = 0; // Silence broken
        }
      }
    }
    
  }
}