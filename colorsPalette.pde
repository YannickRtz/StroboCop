public class ColorPalette {

  public ArrayList<Color> colors;

  public ColorPalette(String... colors) {
    for (String colorString : colors) {
      colors.add(Color.decode(colorString));
    }
  }

  public void combinePalettes(ColorPalette toAdd) {
    for (Color colorString : toAdd.colors) {
      this.colors.add(colorString);
    }
  }

}
