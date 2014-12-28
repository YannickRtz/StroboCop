public class Composition {

  private ArrayList<Effect> effectsList;

  public Composition(String[] effectNames) {
      this.effectsList = new ArrayList<Effect>();
      for (String name : effectNames) {
        String effectName = name + "Effect";
        this.effectsList.add(Class.forName(effectName).newInstance());
      }
  }

  public void run() {
    for (Effect effect : effectsList) {
      effect.run();
    }
  }

}
