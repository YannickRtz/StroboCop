// At a later point there could be more than one transition.

public void colorScreen(int c1, int c2, int c3, int index) {
  index = index - 1;
  fill(c1, c2, c3);
  rect(screenWidth * index, 0, screenWidth, screenHeight);
}

public void colorScreens() {
  if (SMALL_MODE) {
    colorScreensSmall();
    return;
  }
  noStroke();
  for (int i = 0; i < MY_SCREENS.length; i++) {
    colorScreen(byteToInt(message[(MY_SCREENS[i] - 1) * 3]),
                byteToInt(message[(MY_SCREENS[i] - 1) * 3 + 1]),
                byteToInt(message[(MY_SCREENS[i] - 1) * 3 + 2]),
                i + 1);
  }
}

public void colorScreenSmall(int c1, int c2, int c3, int index) {
  index = index - 1;
  fill(c1, c2, c3);
  rect((int)(screenWidth * index / NUMBER_OF_SCREENS),
        100,
        (int)(screenWidth / NUMBER_OF_SCREENS),
        (int)(screenHeight / NUMBER_OF_SCREENS));
}

public void colorScreensSmall() {
  for (int i = 0; i < NUMBER_OF_SCREENS; i++) {
    colorScreenSmall( byteToInt(message[i * 3]),
                      byteToInt(message[i * 3 + 1]),
                      byteToInt(message[i * 3 + 2]),
                      i + 1);
  }
}
