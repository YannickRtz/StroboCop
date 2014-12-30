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

  // DECLARE EFFECTS HERE
  // Walkers:
  Effect walkingBlue = new WalkingEffect(Color.BLUE);
  Effect randomRedBeatWalker = new WalkingEffect(Analyser.BEAT, true, 0, new ColorPalette(Color.RED));
  Effect randomWhiteHatWalker = new WalkingEffect(Analyser.HAT, true, 0, new ColorPalette(Color.WHITE));
  
  // Backgrounds:
  Effect whiteBackground = new BackgroundColorEffect(Color.WHITE);
  
  // Stroboskops:
  Effect randomWhiteStroboskop = new StroboskopEffect(Analyser.BEAT, -1, 0.3, new ColorPalette(Color.WHITE));
  
  // Flashs:
  Effect whiteFlashOnBeat = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 1000, new ColorPalette(Color.WHITE));
  
  // Breathings:
  Effect darkRedBreathing = new BreathingEffect(0, 3000, 0, new ColorPalette(new Color(255, 0, 0, 70)));
  
  
  // DECLARE COMPOSITIONS HERE
  compositions = new ArrayList<Composition>();
  compositions.add(new Composition(darkRedBreathing, randomWhiteStroboskop));
  compositions.add(new Composition(whiteBackground, walkingBlue, randomRedBeatWalker));
  
  // Pick a random initial composition.
  currentComposition = compositions.get(0);
}