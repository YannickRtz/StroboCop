/* Client Code */

public void setupClient() {
  client = new Client(this, SERVER_IP, 5204);
}

public void drawClient() {
  if (client.available() > 0) {
    byte interesting = 1;
    if (message.length == 512) {
      int success = client.readBytesUntil(interesting, message);
      println(success);
    } else {
      int success = client.readBytesUntil(interesting, message);
      if (message.length == success) {
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
}