// Client Code

public void setupClient() {
  client = new Client(this, SERVER_IP, 5204);
}

public void drawClient() {
  if (client.available() > 0) {
    message = client.readBytes();
    //TODO: Better check for message integrity:
    if (message.length >= NUMBER_OF_SCREENS * 3) {
      colorScreens();
    } else {
      errorCounter++;
      print("bad message" + errorCounter + ": ");
      for (int i = 0; i < message.length; i++){
        print(message[i] + " ");
      }
      println(".");
    }
  }
}