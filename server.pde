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
  
  if (beatFreqMix.isKick() && framesDistance == 0) {
    framesDistance = MIN_DISTANCE;
    for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
      writeMessageAt((int)random(255), (int)random(255), (int)random(255), i);
    }
  }
  
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
    rect(0, 0, 300, 100);
    fill(255);
    text("silenceDurationSeconds: " + analyser.silenceDurationSeconds, 20, 20);
    text("intensity: " + analyser.intensity, 20, 35);
    text("stereonessOnset: " + analyser.stereonessOnset, 20, 50);
    text("stereonessKick: " + analyser.stereonessKick, 20, 65);
    text("stereonessSnare: " + analyser.stereonessSnare, 20, 80);
    text("stereonessHat: " + analyser.stereonessHat, 20, 95);
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