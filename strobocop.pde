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
int framesDistance = 0;
boolean sendMessage = false;

// Configuration constants:
int MIN_DISTANCE = 0;
int FRAMERATE = 30;  //NOTE(yannick): All effects should be framerate independent

//NOTE(yannick): The following constants could be initialized via dialog boxes
// at a later point. For now we should put them in a separate properties file
// and put it on .gitignore
int NUMBER_OF_SCREENS = 4;  //NOTE(yannick): Only the server needs the right number
                            // and propagate it somehow to the clients.
                            //TODO: Can we set this automatically?
boolean SERVER_MODE = true; //TODO: Can we set this automatically?
int[] MY_SCREENS = {1,2};
String SERVER_IP = "192.168.178.78"; //TODO: Can we set this automatically?

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
      sendMessage = true;
      framesDistance = MIN_DISTANCE;
      for (int i = 1; i <= NUMBER_OF_SCREENS; i++) {
        writeMessageAt((int)random(255), (int)random(255), (int)random(255), i);
      }
    }
    if (sendMessage) {
      server.write(message);
      sendMessage = false;
    }
    colorScreens();

  } else { // Client mode

    if (client.available() > 0) {
      message = client.readBytes();
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
  index = index - 1;
  fill(c1, c2, c3);
  rect(screenWidth * index, 0, screenWidth, screenHeight);
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

public int byteToInt(byte input) {
  return (int)input + 128;
}

public byte intToByte(int input) {
  if (input <= 255) {
    return (byte)(input - 128);
  } else {
    println("too high of an int");
    return 0; // not supposed to happen
  }
}
