public void compose() {
  // Declare effects here.
  Effect test = new TestEffect();
  Effect walking = new WalkingEffect(Color.BLUE);

  // Declare compositions here.
  Composition compositionOne = new Composition(test);
  Composition compositionTwo = new Composition(walking);

  // Pool with all compositions.
  compositions = new Composition[]{compositionOne, compositionTwo};

  // Pick a random initial composition.
  currentComposition = compositions[0];
}