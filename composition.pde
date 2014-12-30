public class Composition {

  private Effect[] effectsList;

  public Composition(Effect... effects) {
    this.effectsList = effects;
  }

  public void run() {
    for (Effect effect : effectsList) {
      effect.run();
    }
  }

}
