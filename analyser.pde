public class Analyser {
  
  private int BUFFER_SIZE = FRAMERATE * 5;
  private MainBufferObject[] buffer = new MainBufferObject[BUFFER_SIZE];
  private int bufferIndex = 0;
  private int guessedBeatIndex = 0;
  private int SILENCE_THRESHOLD = FRAMERATE; // Two hits in during this period break the silence
  private boolean bufferIsFull = false;
  private float guessedTempoInFrames = 0;
  private int MIN_EXPECTED_TEMPO = 55;
  private int MAX_EXPECTED_TEMPO = 145;
  
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
  public int detectedRegularity = 0;
  public float guessedTempo = 0;
  public float tempoGuessAge = 0;
  public boolean isGuessedBeat = false;
  
  public Analyser() {
    for (int i = 0; i < BUFFER_SIZE; i++) {
      buffer[i] = new MainBufferObject();
    }
  }
  
  class SubBufferObject {
    public boolean isOnset = false;
    public boolean isKick = false;
    public boolean isSnare = false;
    public boolean isHat = false;
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
    analyseIntensity();
    analyseTempo();
    analyseStereoness();
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
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
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
  
  public void analyseTempo() {
    int index = 0;
    int hits;
    int lastHit = -1;
    HashMap<Integer, Integer> hitDistances = new HashMap<Integer, Integer>();

    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      index = (bufferIndex + BUFFER_SIZE - i) % BUFFER_SIZE;
      hits = 0;
      if (buffer[index].mix.isOnset) { hits++; }
      if (buffer[index].mix.isKick) { hits++; }
      if (buffer[index].mix.isHat) { hits++; }
      if (buffer[index].mix.isSnare) { hits++; }
      
      if (hits >= 3) {
        if (lastHit != -1) {
          if (i - lastHit >= (int)(FRAMERATE / 4)) {
            hitDistances.put(frameCount - i, i - lastHit);
            lastHit = i;
          }
        } else {
          lastHit = i;
        }
      }
    }
    
    HashMap<Integer, Integer> hitMap = new HashMap<Integer, Integer>();
    
    int currentNumber;
    int frequentNumber = -1;
    for (int distance : hitDistances.values()) {
      if (hitMap.containsKey(distance)) {
        currentNumber = distance;
        hitMap.put(distance, hitMap.get(currentNumber) + 1);
        if (frequentNumber == -1) {
          frequentNumber = currentNumber;
        } else {
          if (hitMap.get(currentNumber) > hitMap.get(frequentNumber)) {
            frequentNumber = currentNumber;
          }
        }
      } else {
        hitMap.put(distance, 1);
      }
    }
    
    if (frequentNumber > 1) {
      int average = hitMap.get(frequentNumber) * frequentNumber;
      detectedRegularity = hitMap.get(frequentNumber);
      if (hitMap.containsKey(frequentNumber + 1)) {
        detectedRegularity += hitMap.get(frequentNumber + 1);
        average += hitMap.get(frequentNumber + 1) * (frequentNumber + 1);
      }
      if (hitMap.containsKey(frequentNumber - 1)) {
        detectedRegularity += hitMap.get(frequentNumber - 1);
        average += hitMap.get(frequentNumber - 1) * (frequentNumber - 1);
      }
      
      float beatDistanceInFrames = average / detectedRegularity;
      
      // If one beat was missed:
      if (hitMap.containsKey((int)(frequentNumber / 2))) {
        detectedRegularity += hitMap.get((int)(frequentNumber / 2));
      }
      
      float tmpGuessedTempo = FRAMERATE * 60 / beatDistanceInFrames;
      
      if (detectedRegularity >= 3 &&
          tmpGuessedTempo <= MAX_EXPECTED_TEMPO &&
          tmpGuessedTempo >= MIN_EXPECTED_TEMPO) {
          
        guessedTempo = tmpGuessedTempo;
        guessedTempoInFrames = beatDistanceInFrames;
        
        Set<Integer> keySet = hitDistances.keySet();
        Iterator<Integer> mapIterator = keySet.iterator();
        while (mapIterator.hasNext()) {
          int key = mapIterator.next();
          if (hitDistances.get(key) == frequentNumber) {
            guessedBeatIndex = key;
            break;
          }
        }
        
      }
    } else {
      detectedRegularity = 0;
    }
    
    float tempoOffset = (frameCount - guessedBeatIndex) % guessedTempoInFrames;
    if (tempoOffset < 0.5 || tempoOffset > guessedTempoInFrames + 0.5) {
      isGuessedBeat = true;
    } else {
      isGuessedBeat = false;
    }
    
    tempoGuessAge = (float)(frameCount - guessedBeatIndex) / FRAMERATE;
  }
  
  // Debug function
  public void drawCache() {
    fill(100);
    if (buffer[bufferIndex].mix.isOnset) { fill(255); }
    text("isOnset", screenWidth - 100, 20);
    fill(100);
    if (buffer[bufferIndex].mix.isKick) { fill(255); }
    text("isKick", screenWidth - 100, 35);
    fill(100);
    if (buffer[bufferIndex].mix.isSnare) { fill(255); }
    text("isSnare", screenWidth - 100, 50);
    fill(100);
    if (buffer[bufferIndex].mix.isHat) { fill(255); }
    text("isHat", screenWidth - 100, 65);
    fill(100);
    if (isGuessedBeat) { fill(255); }
    text("isGuessedBeat", screenWidth - 100, 85);
    fill(255);
    
    int index = 0;
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      index = (bufferIndex + BUFFER_SIZE - i) % BUFFER_SIZE;
      if (buffer[index].mix.isOnset) {
        rect(screenWidth - 105 - i * 5, 10, 3, 10);
      }
      if (buffer[index].mix.isKick) {
        rect(screenWidth - 105 - i * 5, 25, 3, 10);
      }
      if (buffer[index].mix.isSnare) {
        rect(screenWidth - 105 - i * 5, 40, 3, 10);
      }
      if (buffer[index].mix.isHat) {
        rect(screenWidth - 105 - i * 5, 55, 3, 10);
      }
    }
  }
}