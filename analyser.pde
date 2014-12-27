public class Analyser {
  
  private int BUFFER_SIZE = FRAMERATE * 4;
  private MainBufferObject[] buffer = new MainBufferObject[BUFFER_SIZE];
  private int bufferIndex = 0;
  private int SILENCE_THRESHOLD = FRAMERATE; // Two hits in during this period break the silence
  private int INTENSITY_DELAY = FRAMERATE * 3; // What sample size should be used for intensity?
  private boolean bufferIsFull = false;
  
  // Event types
  public final int ONSET = 0;
  public final int KICK = 1;
  public final int SNARE = 2;
  public final int HAT = 3;
  
  // Public variables
  public int regularity;
  public int mostRegularEvent;
  public int intensity = 0;
  public float stereonessOnset = 0;
  public float stereonessKick = 0;
  public float stereonessHat = 0;
  public float stereonessSnare = 0;
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
      
      if (bufferIsFull) {
        analyseSilence();
        analyseIntensity();
        analyseStereoness();
      }
      
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
    
    if (bufferIndex == BUFFER_SIZE - 1) {
      bufferIsFull = true;
    }
  }
  
  private void analyseSilence() {
    silenceDurationSeconds += 1 / (float)FRAMERATE;
    
    if (buffer[bufferIndex].mix.isOnset) {
      int index;
      for (int i = 1; i < SILENCE_THRESHOLD; i++) {
        index = (bufferIndex + BUFFER_SIZE - i) % BUFFER_SIZE;
        if (buffer[index].mix.isOnset) {
          silenceDurationSeconds = 0; // Silence broken
        }
      }
    }
    
  }
  
  private void analyseIntensity() {
    int index;
    intensity = 0;
    for (int i = 0; i < INTENSITY_DELAY; i++) {
      index = (bufferIndex + BUFFER_SIZE - i) % BUFFER_SIZE;
      if (buffer[index].mix.isOnset) {
        intensity += 1;
      }
    }
  }
  
  private void analyseStereoness() {
    int index;
    stereonessOnset = 0;
    stereonessKick = 0;
    stereonessHat = 0;
    stereonessSnare = 0;
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      index = (bufferIndex + BUFFER_SIZE - i) % BUFFER_SIZE;
      if (buffer[index].left.isOnset && !buffer[index].right.isOnset) {
        stereonessOnset--;
      }
      if (!buffer[index].left.isOnset && buffer[index].right.isOnset) {
        stereonessOnset++;
      }
      if (buffer[index].left.isKick && !buffer[index].right.isKick) {
        stereonessKick--;
      }
      if (!buffer[index].left.isKick && buffer[index].right.isKick) {
        stereonessKick++;
      }
      if (buffer[index].left.isHat && !buffer[index].right.isHat) {
        stereonessHat--;
      }
      if (!buffer[index].left.isHat && buffer[index].right.isHat) {
        stereonessHat++;
      }
      if (buffer[index].left.isSnare && !buffer[index].right.isSnare) {
        stereonessSnare--;
      }
      if (!buffer[index].left.isSnare && buffer[index].right.isSnare) {
        stereonessSnare++;
      }
    }
    stereonessOnset /= BUFFER_SIZE;
    stereonessKick /= BUFFER_SIZE;
    stereonessHat /= BUFFER_SIZE;
    stereonessSnare /= BUFFER_SIZE;
  }
}