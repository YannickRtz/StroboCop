// Server Code

public void setupServer() {
  server = new Server(this, 5204);
  minim = new Minim(this);
  audioIn = minim.getLineIn();

  beatSoundMix = new BeatDetect();
  beatSoundLeft = new BeatDetect();
  beatSoundRight = new BeatDetect();

  beatFreqMix = new BeatDetect();
  beatFreqLeft = new BeatDetect();
  beatFreqRight = new BeatDetect();
  beatFreqMix.detectMode(BeatDetect.FREQ_ENERGY);
  beatFreqLeft.detectMode(BeatDetect.FREQ_ENERGY);
  beatFreqRight.detectMode(BeatDetect.FREQ_ENERGY);

  faderComposition = new Composition(new FadeOnSilenceEffect(Color.BLACK));

  analyser = new Analyser();
  
  compose();
}

public void drawServer() {
  if (frameCount == 1) {
    println(server.ip());
  }

  beatSoundMix.detect(audioIn.mix);
  beatSoundLeft.detect(audioIn.left);
  beatSoundRight.detect(audioIn.right);
  beatFreqMix.detect(audioIn.mix);
  beatFreqLeft.detect(audioIn.left);
  beatFreqRight.detect(audioIn.right);
  analyser.analyse();

  writeMessageAll(Color.BLACK);

  // Pick a new, random composition on pause.
  if (analyser.secondsSincePause == 0) {
    currentComposition = compositions.get(randomInt(compositions.size()));
  }

  currentComposition.run();
  faderComposition.run();

  boolean somethingChanged = false;
  if (oldMessage != null) {
    for (int i = message.length - 1; i >= 0; i--) {
      if (message[i] != oldMessage[i]) {
        somethingChanged = true;
      }
    }
  } else {
    somethingChanged = true;
  }
  if (somethingChanged) {
    server.write(message);
    oldMessage = message.clone();
    colorScreens();
  }

  if (DEBUG_MODE) {
    fill(0);
    rect(0, 0, screenWidth, 100);
    fill(255);

    text("secondsSincePause: " + analyser.secondsSincePause, 20, 15);
    text("loudness: " + analyser.loudness, 20, 45);
    text("guessedTempo: " + analyser.guessedTempo, 20, 60);
    text("detectedRegularity: " + analyser.detectedRegularity, 20, 75);
    text("tempoGuessAge: " + analyser.tempoGuessAge, 20, 90);

    fill(100);
    if (analyser.getBeat()) { fill(255); }
    text("analyser.getBeat()", 300, 20);
    fill(255);
    text("stereonessHat: " + analyser.stereonessHat, 300, 35);
    text("stereonessOnset: " + analyser.stereonessOnset, 300, 50);
    text("stereonessKick: " + analyser.stereonessKick, 300, 65);
    text("stereonessSnare: " + analyser.stereonessSnare, 300, 80);

    analyser.drawCache();
  }
}

public void stopServer() {
  audioIn.close();
  minim.stop();
  server.stop();
}

public int mixColor(float c1, float c2, float alpha) {
  if (alpha == 255) { return (int)c2; }
  return (int)(c1 * ((255 - alpha) / 255) + c2 * (alpha / 255));
}

public void writeMessageAt(float c1, float c2, float c3, int index) {
  index = (index - 1) * 3;
  message[index] = intToByte((int)c1);
  message[index + 1] = intToByte((int)c2);
  message[index + 2] = intToByte((int)c3);
}

public void writeMessageAt(float c1, float c2, float c3, float alpha, int index) {
  index = (index - 1) * 3;
  message[index] = intToByte(mixColor(byteToInt(message[index]), c1, alpha));
  message[index + 1] = intToByte(mixColor(byteToInt(message[index + 1]), c2, alpha));
  message[index + 2] = intToByte(mixColor(byteToInt(message[index + 2]), c3, alpha));
}

public void writeMessageAt(Color c0, int index) {
  writeMessageAt(c0.getRed(), c0.getGreen(), c0.getBlue(), c0.getAlpha(), index);
}

public void writeMessageAll(Color c0) {
  for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
    writeMessageAt(c0, i);
  }
}

public void writeMessageAll(float c1, float c2, float c3) {
  for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
    writeMessageAt(c1, c2, c3, i);
  }
}

public void writeMessageAll(float c1, float c2, float c3, float alpha) {
  for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
    writeMessageAt(c1, c2, c3, alpha, i);
  }
}
