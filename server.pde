// Server Code

public void setupServer() {
  message = new byte[NUMBER_OF_SCREENS * 3 + 1];
  
  oldDebugMode = DEBUG_MODE;
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
  
  beatFreq = new BeatDetect(1024, 44100);
  beatFreq.setSensitivity(100);
  
  delayCompensation = 0;

  faderComposition = new Composition(new FadeOnSilenceEffect(Color.BLACK));

  analyser = new Analyser();
  
  JOptionPane.showMessageDialog(null, "The server IP is: " + server.ip(),
             "Server IP", JOptionPane.INFORMATION_MESSAGE);
  
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
  beatFreq.detect(audioIn.mix);
  analyser.analyse();

  writeMessageAll(Color.BLACK);

  // Pick a new, random composition on pause.
  if (analyser.secondsSincePause % 100 < 0.5) {
    compositionIndex = randomInt(compositions.size());
    currentComposition = compositions.get(compositionIndex);
  }

  currentComposition.run();
  faderComposition.run();
  
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {
        compositionIndex = (compositionIndex + 1) % compositions.size();
        currentComposition = compositions.get(compositionIndex);
      }
      if (keyCode == DOWN) {
        compositionIndex = (compositionIndex + compositions.size() - 1) % compositions.size();
        currentComposition = compositions.get(compositionIndex);
      }
      if (keyCode == LEFT) {
        DEBUG_MODE = true;
      }
      if (keyCode == RIGHT) {
        DEBUG_MODE = false;
      }
    } else {
      Boolean newBuffer = false;
      if (key == 'k' || key == 'K') {
        delayCompensation++;
        newBuffer = true;
      }
      if ((key == 'j' || key == 'J') && delayCompensation > 0) {
        delayCompensation--;
        newBuffer = true;
      }
      if (newBuffer && delayCompensation > 0) {
        serverMessageBuffer = new byte[delayCompensation][message.length];
        for (int i = 0; i < delayCompensation; i++) {
          for (int j = 0; j < message.length; j++) {
            serverMessageBuffer[i][j] = 40;
          }
        }
        for (int i = 0; i < message.length; i++) {
          if (i != message.length - 1) {
            message[i] = 40;
          } else {
            message[i] = 1;
          }
        }
      }
    }
  }

  // Check for the interesting character (we don't want it in there)
  for (int i = message.length - 1; i >= 0; i--) {
    message[i] = message[i] == 1 ? 0 : message[i];
  }
  message[NUMBER_OF_SCREENS * 3] = (byte)1;
  
  if (delayCompensation > 0) {
    serverMessageBuffer[frameCount % delayCompensation] = message;
    message = serverMessageBuffer[(frameCount+1) % delayCompensation];
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
    rect(0, 0, screenWidth, 100);
    fill(255);

    text("secondsSincePause: " + analyser.secondsSincePause, 20, 15);
    text("Composition Nr: " + compositionIndex, 20, 30);
    text("loudness: " + analyser.loudness, 20, 45);
    text("guessedTempo: " + analyser.guessedTempo, 20, 60);
    text("detectedRegularity: " + analyser.detectedRegularity, 20, 75);
    fill(100);
    if (analyser.tempoGuessAge < analyser.secondsSincePause && analyser.tempoGuessAge < 45) {
      fill(255);
    }
    text("tempoGuessAge: " + analyser.tempoGuessAge, 20, 90);
    fill(255);
    
    fill(100);
    if (analyser.getBeat()) { fill(255); }
    text("analyser.getBeat()", 300, 20);
    fill(255);
    text("stereonessHat: " + analyser.stereonessHat, 300, 35);
    text("stereonessOnset: " + analyser.stereonessOnset, 300, 50);
    text("stereonessKick: " + analyser.stereonessKick, 300, 65);
    text("stereonessSnare: " + analyser.stereonessSnare, 300, 80);
    text("delayCompensation: " + delayCompensation, 300, 95);
    
    analyser.drawBuffer();
    if (!SMALL_MODE) {
      image(logo, screenWidth / 2 - logo.width / 2, 200);
    }
  }
}

public void stopServer() {
  audioIn.close();
  minim.stop();
  server.stop();
}

public int alphaBlend(float c1, float c2, float alpha) {
  if (alpha == 255) { return (int)c2; }
  int result = (int)(c1 * (1 - (alpha / 255)) + c2 * (alpha / 255));
  return result;
}

public void writeMessageAt(float c1, float c2, float c3, int index) {
  index = (index - 1) * 3;
  message[index] = intToByte((int)c1);
  message[index + 1] = intToByte((int)c2);
  message[index + 2] = intToByte((int)c3);
}

public void writeMessageAt(float c1, float c2, float c3, float alpha, int index) {
  index = (index - 1) * 3;
  if (index < message.length - 2 && index >= 0) {
    message[index] = intToByte(alphaBlend(byteToInt(message[index]), c1, alpha));
    message[index + 1] = intToByte(alphaBlend(byteToInt(message[index + 1]), c2, alpha));
    message[index + 2] = intToByte(alphaBlend(byteToInt(message[index + 2]), c3, alpha));
  } else {
    println("Message index out of bounds: " + index + "! Current composition: " + compositionIndex);
  }
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
