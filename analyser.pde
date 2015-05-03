public class Analyser {
  
  /*
   * Note: At the moment there is a thing called buffer and a thing called freqCache
   * in this class. The cache is the newer thing and is supposed to replace the
   * buffer in the long run.
   */
  
  private int BUFFER_SIZE = FRAMERATE * 5;
  private int CACHE_SIZE = FRAMERATE * 10;
  private int FREQ_BAND_COUNT = 27; // Number of frequency bands beatdetect is looking at
  private MainBufferObject[] buffer = new MainBufferObject[BUFFER_SIZE];
  private boolean[][] freqCache = new boolean[CACHE_SIZE][FREQ_BAND_COUNT];
  
  private int bufferIndex = 0;
  private int cacheIndex = 0;
  private int guessedBeatIndex = 0;
  private int lastPauseIndex = 0;
  private float guessedTempoInFrames = 0;
  private int representativeFrame = 0;
  private int lastRepresentativeFrame = 0;
  
  private int onsetCooldown = 0;
  private int kickCooldown = 0;
  private int snareCooldown = 0;
  private int hatCooldown = 0;

  private float SILENCE_THRESHOLD = FRAMERATE * 2.5;
  private int HIT_THRESHOLD = 8;
  private int MIN_EXPECTED_TEMPO = 55;
  private int MAX_EXPECTED_TEMPO = 240;
  private float LOUDNESS_THRESHOLD = 0.015; // If loudness is below this, it's considered silence
  private int MAX_TEMPO_AGE = 45;
  private int COOLDOWN_FRAMES = 5;
  
  // Event types enumeration
  static final int ONSET = 0;
  static final int KICK = 1;
  static final int SNARE = 2;
  static final int HAT = 3;
  static final int BEAT = 4;
  
  // Public variables
  public float stereonessOnset = 0;
  public float stereonessKick = 0;
  public float stereonessHat = 0;
  public float stereonessSnare = 0;
  public int detectedRegularity = 0;
  public float guessedTempo = 0;
  public float tempoGuessAge = 0;
  public float secondsSincePause = 0;
  public float loudness = 0;
  public boolean coolOnset = false;
  public boolean coolKick = false;
  public boolean coolHat = false;
  public boolean coolSnare = false;
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
    // fillCache();
    
    onsetCooldown--;
    kickCooldown--;
    snareCooldown--;
    hatCooldown--;
    
    if (buffer[bufferIndex].mix.isOnset && onsetCooldown <= 0) {
      onsetCooldown = COOLDOWN_FRAMES;
      coolOnset = true;
    } else {
      coolOnset = false;
    }
    if (buffer[bufferIndex].mix.isKick && kickCooldown <= 0) {
      kickCooldown = COOLDOWN_FRAMES;
      coolKick = true;
    } else {
      coolKick = false;
    }
    if (buffer[bufferIndex].mix.isSnare && snareCooldown <= 0) {
      snareCooldown = COOLDOWN_FRAMES;
      coolSnare = true;
    } else {
      coolSnare = false;
    }
    if (buffer[bufferIndex].mix.isHat && hatCooldown <= 0) {
      hatCooldown = COOLDOWN_FRAMES;
      coolHat = true;
    } else {
      coolHat = false;
    }
    
    analyseSilence();
    analyseBufferTempo();
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
  }
  
  private void fillCache() {
    for (int bandIndex = 0; bandIndex < FREQ_BAND_COUNT; bandIndex++) {
      freqCache[cacheIndex][bandIndex] = beatFreq.isOnset(bandIndex);
    }
    cacheIndex = (cacheIndex + 1) % CACHE_SIZE;
  }
  
  private void analyseSilence() {    
    int onsetCounter = 0;
    int kickCounter = 0;
    int snareCounter = 0;
    int hatCounter = 0;
    
    int index;
    for (int i = 0; i < SILENCE_THRESHOLD; i++) {
      index = (bufferIndex + BUFFER_SIZE - i) % BUFFER_SIZE;
      if (buffer[index].mix.isOnset) { onsetCounter++; }
      if (buffer[index].mix.isKick) { kickCounter++; }
      if (buffer[index].mix.isHat) { hatCounter++; }
      if (buffer[index].mix.isSnare) { snareCounter++; }
    }
    
    // Onset is more usefull for pause detection, kick less usefull
    loudness = ((float)(onsetCounter * 2 + hatCounter + snareCounter) / 4) / (float)BUFFER_SIZE;
    
    if (loudness <= LOUDNESS_THRESHOLD) {
      lastPauseIndex = frameCount;
    }
    secondsSincePause = (float)(frameCount - lastPauseIndex) / FRAMERATE;
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
  
  public void analyseBufferTempo() {
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
      
      if (detectedRegularity >= (float)BUFFER_SIZE / 50 &&
          tmpGuessedTempo <= MAX_EXPECTED_TEMPO &&
          tmpGuessedTempo >= MIN_EXPECTED_TEMPO) {
        if (tmpGuessedTempo < 80) {
          guessedTempo = tmpGuessedTempo * 2;
          guessedTempoInFrames = beatDistanceInFrames / 2;
        } else if (tmpGuessedTempo > 200) {
          guessedTempo = tmpGuessedTempo / 2;
          guessedTempoInFrames = beatDistanceInFrames * 2;
        } else {
          guessedTempo = tmpGuessedTempo;
          guessedTempoInFrames = beatDistanceInFrames;
        }
        
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
    
    float tempoOffset = ((frameCount + delayCompensation) - guessedBeatIndex) % guessedTempoInFrames;
    if (tempoOffset < 0.5 || tempoOffset > guessedTempoInFrames + 0.5) {
      isGuessedBeat = true;
    } else {
      isGuessedBeat = false;
    }
    
    tempoGuessAge = (float)(frameCount - guessedBeatIndex) / FRAMERATE;
  }

public void analyseCacheTempo() {
    // First step: Where are potential hits in time?
    ArrayList<Integer> hitList = new ArrayList<Integer>();
    // for (int index = 0; index < CACHE_SIZE; index++) {
    for (int index = CACHE_SIZE - 1; index >= 0; index--) {
      int relativeIndex = (cacheIndex + CACHE_SIZE - index) % CACHE_SIZE;
      int hitCount = 0;
      for (int band = 0; band < FREQ_BAND_COUNT; band++) {
        if (freqCache[relativeIndex][band]) {
          hitCount++;
        }
      }
      if (hitCount >= HIT_THRESHOLD) {
        hitList.add(frameCount - index);
      }
    }
    
    // Second step: What are the distances between potential hits?
    // And what is the most common speed they are suggesting?
    HashMap<Float, Integer> hitDistances = new HashMap<Float, Integer>();
    lastRepresentativeFrame = representativeFrame;
    representativeFrame = 0;
    detectedRegularity = 0;
    
    for (int hitIndex = 0; hitIndex < hitList.size(); hitIndex++) {
      for (int startHitIndex = hitIndex + 1;
           startHitIndex < startHitIndex + 2 && startHitIndex < hitList.size();
           startHitIndex++) {
        int distance = hitList.get(startHitIndex) - hitList.get(hitIndex);
        float potentialSpeed;
        if (distance > 2) {
          potentialSpeed = 60 * ((float)FRAMERATE / (float)distance);
        } else {
          potentialSpeed = 0;
        }
        if (potentialSpeed > MAX_EXPECTED_TEMPO && potentialSpeed < MAX_EXPECTED_TEMPO * 2) {
          potentialSpeed /= 2;
        } else if (potentialSpeed < MIN_EXPECTED_TEMPO && potentialSpeed > MIN_EXPECTED_TEMPO / 2) {
          potentialSpeed *= 2;
        } else if (potentialSpeed < MIN_EXPECTED_TEMPO / 2 || potentialSpeed > MAX_EXPECTED_TEMPO * 2) {
          potentialSpeed = 0;
        }
        if (potentialSpeed != 0) {
          if (!hitDistances.containsKey(potentialSpeed)) {
            hitDistances.put(potentialSpeed, 1);
          } else {
            hitDistances.put(potentialSpeed, hitDistances.get(potentialSpeed) + 1);
            if (hitDistances.get(potentialSpeed) > detectedRegularity) {
              detectedRegularity = hitDistances.get(potentialSpeed);
              guessedTempo = potentialSpeed;
              representativeFrame = hitList.get(startHitIndex);
            }
          }
        }
      }
    }
    
    float beatDistanceInFrames = (60 * FRAMERATE) / guessedTempo;
    
    float tempoOffset = (frameCount - lastRepresentativeFrame) % beatDistanceInFrames;
    println("TempoOffset: " + tempoOffset + " beatDist: " + beatDistanceInFrames + " representativeFrame: " + lastRepresentativeFrame);
    if (tempoOffset < 0.5 || tempoOffset > beatDistanceInFrames + 0.5) {
      isGuessedBeat = true;
    } else {
      isGuessedBeat = false;
    }
    
    tempoGuessAge = (float)(frameCount - representativeFrame) / FRAMERATE;
  }
  
  public boolean getBeat() {
    return getBeat(BEAT);
  }
  
  public boolean getBeat(int eventType) {
    boolean result = false;
    switch (eventType) {
      case BEAT:
        if (tempoGuessAge < secondsSincePause && tempoGuessAge < MAX_TEMPO_AGE) {
          return isGuessedBeat;
        } else {
          return coolOnset;
        }
      case HAT:
        return coolHat;
      case SNARE:
        return coolSnare;
      case KICK:
        return coolKick;
      default:
        return false;
    }
  }
  
  // Debug function
  public void drawCache() {
    fill(150);
    int relativeIndex;
    int hitCount;
    for (int indexToDraw = 0; indexToDraw < CACHE_SIZE; indexToDraw++) {
      relativeIndex = (cacheIndex + CACHE_SIZE - indexToDraw - 1) % CACHE_SIZE;
      hitCount = 0;
      for (int bandToDraw = 0; bandToDraw < FREQ_BAND_COUNT; bandToDraw++) {
        if (freqCache[indexToDraw][bandToDraw]) { hitCount++; }
      }
      if (hitCount >= HIT_THRESHOLD) { fill(255); } else { fill(150); }
      if (relativeIndex == frameCount - lastRepresentativeFrame - 1) { fill(255,0,0); }
      for (int bandToDraw = 0; bandToDraw < FREQ_BAND_COUNT; bandToDraw++) {
        if (freqCache[indexToDraw][bandToDraw]) {
          rect(screenWidth - 10 - relativeIndex * 3,
              5 + bandToDraw * 3, 3, 3);
        }
      }
    }
  }
  
  // Debug function
  public void drawBuffer() {
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
        rect(screenWidth - 105 - i * 3, 10, 2, 10);
      }
      if (buffer[index].mix.isKick) {
        rect(screenWidth - 105 - i * 3, 25, 2, 10);
      }
      if (buffer[index].mix.isSnare) {
        rect(screenWidth - 105 - i * 3, 40, 2, 10);
      }
      if (buffer[index].mix.isHat) {
        rect(screenWidth - 105 - i * 3, 55, 2, 10);
      }
    }
  }
}