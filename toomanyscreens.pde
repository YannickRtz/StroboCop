import javax.swing.JOptionPane;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.net.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Client client;
Server server;
AudioInput audioIn;
BeatDetect beat;
int screenHeight;
int screenWidth;
int errorCounter;
byte[] message;
int framesDistance = 0;
boolean sendMessage = false;

// Configuration variables:
int MIN_DISTANCE = 10;

// The following variables could be filled in via dialog boxes at a later point:
int NUMBER_OF_SCREENS = 4;
boolean SERVER_MODE = false;
int[] MY_SCREENS = {1, 2, 3};
String SERVER_IP = "192.168.178.78";

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  GraphicsDevice gd = GraphicsEnvironment.getLocalGraphicsEnvironment().getDefaultScreenDevice();
  screenWidth = gd.getDisplayMode().getWidth();
  screenHeight = gd.getDisplayMode().getHeight();
  size((int)(screenWidth * 2), screenHeight);
  message = new byte[NUMBER_OF_SCREENS * 3];
  // Only if not Server:
  client = new Client(this, SERVER_IP, 5204);
}

void draw() {
  if (frameCount == 1) {
    frame.setLocation(0,0);
  }
  
  if (client.available() > 0) {
    message = client.readBytes();
    if (message.length == 15) {
      colorScreens();
    } else {
      errorCounter++;
      println("bad message" + errorCounter);
    }
  }
}

public void colorScreen(int c1, int c2, int c3, int index) {
  index = index - 1;
  fill(c1, c2, c3);
  rect(1920 * index, 0, 1920, 1080);
}

public void colorScreens() {
  noStroke();
  for (int i = 0; i < 3; i++) {
    colorScreen(byteToInt(message[(MY_SCREENS[i] - 1) * 3]),
                byteToInt(message[(MY_SCREENS[i] - 1) * 3 + 1]),
                byteToInt(message[(MY_SCREENS[i] - 1) * 3 + 2]),
                i + 1);
  }
}

public int byteToInt(byte input) {
  return (int)input + 128;
}
