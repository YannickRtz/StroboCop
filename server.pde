// Server Code

public void setupServer() {
  server = new Server(this, 5204);
  minim = new Minim(this);
  audioIn = minim.getLineIn();
  beat = new BeatDetect();
}

public void drawServer() {
  if (frameCount == 1) {
    println(server.ip());
  }
  if (framesDistance > 0) {
    framesDistance--;
  }
  beat.detect(audioIn.mix);
  if (beat.isOnset() && framesDistance == 0) {
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