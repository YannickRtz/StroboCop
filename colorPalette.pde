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
    for (Color colorToAdd : toAdd.colors) {
      colors.add(colorToAdd);
    }
  }

  public Color[] toArray() {
    return colors.toArray(new Color[colors.size()]);
  }
  
  public ColorPalette getRandom() {
    return new ColorPalette(colors.get(randomInt(colors.size())));
  }
  
  public ColorPalette get(int index) {
    return new ColorPalette(colors.get(index % colors.size()));
  }

}
