/* Client Code */

public void setupClient() {
  message = new byte[512];
  client = new Client(this, SERVER_IP, 5204);
}

public void drawClient() {
  if (client.available() > 0) {
    byte interesting = 1;
    if (message.length == 512) {
      int success = client.readBytesUntil(interesting, message);
      println("Got message length: " + success);
      if (success > 0 && success == lastSuccess) {
        message = new byte[success];
        NUMBER_OF_SCREENS = (int)((success - 1) / 3);
      } else {
        lastSuccess = success;
      }
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