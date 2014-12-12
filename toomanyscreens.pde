import processing.net.*;

Client client;
int errorCounter = 0;
byte[] dataIn = new byte[15];
int[] internScreens = {1, 2, 3};
String SERVER_IP = "192.168.178.78";

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  super.init();
}

void setup() {
  size((int)(1920 * 2),1080);
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
