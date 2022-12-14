import java.util.Iterator;
import java.util.Set;
import java.awt.Color;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import javax.swing.UIManager;
import javax.swing.JOptionPane;
import javax.swing.LookAndFeel;

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
BeatDetect beatFreq; // Used for "advanced" analysis code
Analyser analyser;
int screenHeight;
int screenWidth;
int errorCounter;
int compositionIndex;
byte[] message;
byte[] delayedMessage;
byte[] oldMessage;
ArrayList<Composition> compositions;
Composition currentComposition;
Composition faderComposition;
boolean oldDebugMode;
PImage logo;
int lastSuccess;
int delayCompensation;
byte[][] serverMessageBuffer;

// Configuration constants:
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
  if (SERVER_IP == "") {
    try {
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
    } catch (Exception e) {
      println(e);
    }
    int serverValue = JOptionPane.showConfirmDialog(null,
                                                    "Is this computer the server?",
                                                    "Check",
                                                    JOptionPane.YES_NO_OPTION);
    SERVER_MODE = (serverValue == JOptionPane.YES_OPTION);
    if (SERVER_MODE) {
      String inputValue = JOptionPane.showInputDialog("How many screens are involved?");
      NUMBER_OF_SCREENS = Integer.parseInt(inputValue);
    }
    String inputValue = JOptionPane.showInputDialog("Which screens are connected to this computer?\n" +
                                                    "Comma separated list of numbers e.g. for the first two screens:\n" +
                                                    "\"1,2\"");
    String[] strArray = inputValue.split(",");
    MY_SCREENS = new int[strArray.length];
    for (int i = 0; i < strArray.length; i++) {
      MY_SCREENS[i] = Integer.parseInt(strArray[i]);
    }
    if (!SERVER_MODE) {
      Server testServer = new Server(this, 5205);
      String myIP = testServer.ip();
      String[] myIPArray = myIP.split("\\.");
      testServer.stop();
      String lastNumber = JOptionPane.showInputDialog("What is the last number of the server IP?");
      SERVER_IP = myIPArray[0] + "." + myIPArray[1] + "." + myIPArray[2] + "." + lastNumber;
    }
  }
  logo = loadImage("logo.png");
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

  if (SERVER_MODE) {
    setupServer();
  } else {
    setupClient();
  }
}

void draw() {
  if (frameCount < FRAMERATE) {
    //NOTE(yannick): This is supposed to work better when done in draw()
    // instead of setup()
    //TODO: Check if this is true for us
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
