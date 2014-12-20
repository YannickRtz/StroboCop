// Client Code

public void setupClient() {
  client = new Client(this, SERVER_IP, 5204);
}

public void drawClient() {
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