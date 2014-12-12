import javax.swing.JOptionPane;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import processing.net.*;

Client client;
int screenHeight;
int screenWidth;
int errorCounter = 0;
int numberOfScreens;
byte[] dataIn;
int[] internScreens = {1, 2, 3};
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
  // We need to determine if there is a server before this:
  String inputValue = JOptionPane.showInputDialog("How many screens are involved?\n" +
                    "(Please do NOT type in \"too many\" Thanks.)");
  numberOfScreens = Integer.parseInt(inputValue);
  dataIn = new byte[numberOfScreens * 3];
  inputValue = JOptionPane.showInputDialog("Please type in a comma separated list of\n" +
                    "numbers which represent the screens connected\n" +
                    "to this machine. (e.g. \"1,2\" for the first two screens)");
  String[] inputValueArr = inputValue.split(",");
  internScreens = new int[inputValueArr.length];
  for (int i = inputValueArr.length - 1; i >= 0; i--) {
    internScreens[i] = Integer.parseInt(inputValueArr[i]);
  }
  size((int)(screenWidth * 2), screenHeight);
  client = new Client(this, SERVER_IP, 5204);
}

void draw() {
  if (frameCount == 1) {
    frame.setLocation(0,0);
  }
  
  if (client.available() > 0) {
    dataIn = client.readBytes();
    if (dataIn.length == 15) {
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
    colorScreen(byteToInt(dataIn[(internScreens[i] - 1) * 3]),
                byteToInt(dataIn[(internScreens[i] - 1) * 3 + 1]),
                byteToInt(dataIn[(internScreens[i] - 1) * 3 + 2]),
                i + 1);
  }
}

public int byteToInt(byte input) {
  return (int)input + 128;
}
