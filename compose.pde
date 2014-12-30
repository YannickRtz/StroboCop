public void compose() {

/* EFFECTS CHEAT SHEET:
 *
 * EventTypes: Analyser.BEAT, Analyser.KICK, Analyser.HAT & Analyser.SNARE
 * ScreenNumber: 0 ist all screens, -1 is random screens
 * 
 * Constructors:
 * BackgroundColorEffect(color) <= Use always as first effect
 * StroboskopEffect(eventType, screenNumber, propability, colors)
 * BreathingEffect(screenNumber, duration, offset, colors)
 * FlashOnBeatEffect(eventType, isFlickerMode, screenNumber, duration, colors)
 * WalkingEffect(eventType, isRandomMode, offset, colors)
 */

  // Declare effects here.
  Effect test = new TestEffect();
  Effect walking = new WalkingEffect(Color.BLUE);
  Effect background = new BackgroundColorEffect(Color.YELLOW);

  // Declare compositions here.
  Composition compositionOne = new Composition(test);
  Composition compositionTwo = new Composition(background, walking);

  // Pool with all compositions.
  compositions = new Composition[]{compositionOne, compositionTwo};

  // Pick a random initial composition.
  currentComposition = compositions[0];
}