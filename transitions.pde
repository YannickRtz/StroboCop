// At a later point there could be more than one transition.

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
