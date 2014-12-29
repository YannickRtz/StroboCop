import java.util.*;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

// Globals:
Client client;
Server server;
Minim minim;
AudioInput audioIn;
BeatDetect beatSoundMix;
BeatDetect beatSoundLeft;
BeatDetect beatSoundRight;
BeatDetect beatFreqMix;
BeatDetect beatFreqLeft;
BeatDetect beatFreqRight;
Analyser analyser;
int screenHeight;
int screenWidth;
int errorCounter;
byte[] message;
byte[] oldMessage;
int framesDistance = 0;
TestEffect currentEffect;

// Configuration constants:
int MIN_DISTANCE = 0;
int FRAMERATE = 30;  //NOTE(yannick): All effects should be framerate independent

public void init() {
  if (!SMALL_MODE) {
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
  }
  super.init();
}

void setup() {
  GraphicsDevice gd = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();
  screenWidth = gd.getDisplayMode().getWidth();
  screenHeight = gd.getDisplayMode().getHeight();
  if (SMALL_MODE) {
    if (!SERVER_MODE) {
      println("Small Mode can only be used in server mode.");
      return;
    }
    size(screenWidth, 400);
  } else {
    size(screenWidth * MY_SCREENS.length, screenHeight);
  }

  frameRate(FRAMERATE);

  message = new byte[NUMBER_OF_SCREENS * 3];

  if (SERVER_MODE) {
    setupServer();
  } else {
    setupClient();
  }
}

void draw() {
  if (frameCount == 1) {
    //NOTE(yannick): This is supposed to work better when done in draw()
    // instead of setup()
    //TODO: Check if this is true for us.
    frame.setLocation(0,0);
  }

  if (SERVER_MODE) {
    drawServer();
  } else {
    drawClient();
  }
}

void stop() {
  if (SERVER_MODE) {
    stopServer();
  }
  super.stop();
}
