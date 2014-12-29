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

  currentEffect = new TestEffect();

  analyser = new Analyser();
}

public void drawServer() {
  if (frameCount == 1) {
    println(server.ip());
  }
  if (framesDistance > 0) {
    framesDistance--;
  }

  beatSoundMix.detect(audioIn.mix);
  beatSoundLeft.detect(audioIn.left);
  beatSoundRight.detect(audioIn.right);
  beatFreqMix.detect(audioIn.mix);
  beatFreqLeft.detect(audioIn.left);
  beatFreqRight.detect(audioIn.right);
  analyser.analyse();

  currentEffect.run();

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

public void writeMessageAt(int c1, int c2, int c3, int index) {
  index = (index - 1) * 3;
  message[index] = intToByte(c1);
  message[index + 1] = intToByte(c2);
  message[index + 2] = intToByte(c3);
}
