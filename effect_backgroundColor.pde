public class BackgroundColorEffect extends Effect {

  private Color myColor;
  
  public BackgroundColorEffect(Color c0) {
    myColor = c0;
  }
  
  public void run() {
    writeMessageAll(myColor);
  }

}