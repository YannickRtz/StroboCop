public class ColorPalette {

  public ArrayList<Color> colors;

  public ColorPalette(String... colors) {
    for (String color : colors) {
      colors.add(Color.decode(color));
    }
  }

  public void combinePalettes(ColorPalette toAdd) {
    for (Color color : toAdd.colors) {
      this.colors.add(color);
    }
  }

}
