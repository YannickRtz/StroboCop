import javax.swing.JOptionPane;
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
BeatDetect beat;
int screenHeight;
int screenWidth;
int errorCounter;
byte[] message;
byte[] oldMessage;
int framesDistance = 0;

// Configuration constants:
int MIN_DISTANCE = 0;
int FRAMERATE = 30;  //NOTE(yannick): All effects should be framerate independent

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

  frameRate(FRAMERATE);

  message = new byte[NUMBER_OF_SCREENS * 3];

  if (SERVER_MODE) {
    server = new Server(this, 5204);
    minim = new Minim(this);
    audioIn = minim.getLineIn();
    beat = new BeatDetect();
  } else {
    client = new Client(this, SERVER_IP, 5204);
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

  } else { // Client mode

    if (client.available() > 0) {
      message = client.readBytes();
      //TODO: Better check for message integrity:
      if (message.length > 5) {
        colorScreens();
      } else {
        errorCounter++;
        println("bad message" + errorCounter);
      }
    }

  }
}

void stop() {
  if (SERVER_MODE) {
    audioIn.close();
    minim.stop();
    server.stop();
  }
  super.stop();
}

public void colorScreen(int c1, int c2, int c3, int index) {
  int radius = screenHeight/4;
  index = index - 1;
  fill(c1, c2, c3);
  rect(screenWidth * index, 0, screenWidth, screenHeight);
  ellipseMode(CENTER);
  fill(Math.min(c1 + 20, 255), Math.min(c2 + 20, 255), Math.min(c3 + 20, 255));
  ellipse((screenWidth/2) + (index * screenWidth), screenHeight/2, radius, radius);
}

public void colorScreens() {
  noStroke();
  for (int i = 0; i < MY_SCREENS.length; i++) {
    colorScreen(byteToInt(message[(MY_SCREENS[i] - 1) * 3]),
                byteToInt(message[(MY_SCREENS[i] - 1) * 3 + 1]),
                byteToInt(message[(MY_SCREENS[i] - 1) * 3 + 2]),
                i + 1);
  }
}

public void writeMessageAt(int c1, int c2, int c3, int index) {
  index = (index - 1) * 3;
  message[index] = intToByte(c1);
  message[index + 1] = intToByte(c2);
  message[index + 2] = intToByte(c3);
}
