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
  
  compositions = new ArrayList<Composition>();
  
  // Declare compositions here.
  compositions.add(new Composition(test));
  compositions.add(new Composition(background, walking));
  
  // Pick a random initial composition.
  currentComposition = compositions.get(0);
}