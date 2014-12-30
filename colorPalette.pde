public class ColorPalette {

  public ArrayList<Color> colors = new ArrayList<Color>();

  public ColorPalette(String... colorStrings) {
    for (String colorString : colorStrings) {
      colors.add(Color.decode(colorString));
    }
  }
  
  public ColorPalette(Color... colorArray) {
    for (Color c0 : colorArray) {
      colors.add(c0);
    }
  }

  public void combinePalettes(ColorPalette toAdd) {
    for (Color colorString : toAdd.colors) {
      colors.add(colorString);
    }
  }
  
  public Color[] toArray() {
    return colors.toArray();
  }

}
