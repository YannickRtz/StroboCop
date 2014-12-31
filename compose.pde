public void compose() {

/* EFFECTS CHEAT SHEET:
 *
 * EventTypes: Analyser.BEAT, Analyser.KICK, Analyser.HAT & Analyser.SNARE
 * ScreenNumber: 0 ist all screens, -1 is random screens
 * 
 * Constructors:
 * BackgroundColorEffect(color) <= Use always as first effect
 * StroboskopEffect(eventType, screenNumber, framesDuration, propability, colors)
 * BreathingEffect(screenNumber, duration, offset, colors)
 * FlashOnBeatEffect(eventType, isFlickerMode, screenNumber, duration, colors)
 * WalkingEffect(eventType, isRandomMode, offset, colors)
 * Timed Mode: WalkingEffect(eventType, isRandomMode, offset, tempo, colors)
 */

  // DECLARE EFFECTS HERE
  // Walkers:
  Effect walkingBlue = new WalkingEffect(Analyser.BEAT, false, 0, new ColorPalette(Color.BLUE));
  Effect randomRedHatWalker = new WalkingEffect(Analyser.HAT, true, 0, new ColorPalette(Color.RED));
  Effect randomWhiteHatWalker = new WalkingEffect(Analyser.HAT, true, 0, new ColorPalette(Color.WHITE));
  Effect randomShrillBeatFlickerWalker = new WalkingEffect(Analyser.BEAT, true, 0, shrill);
  Effect randomPastellishBeatFlickerWalker = new WalkingEffect(Analyser.BEAT, true, 0, pastellish);
  Effect randomEleganzBeatFlickerWalker = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz);
  Effect randomEleganzWalker1 = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz.getRandom());
  Effect randomEleganzWalker2 = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz.getRandom());
  Effect randomEleganzWalker3 = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz.getRandom());
  Effect pastellishWalker1 = new WalkingEffect(Analyser.BEAT, false, 0, pastellish.getRandom());
  Effect pastellishWalker2 = new WalkingEffect(Analyser.BEAT, false, 1, pastellish.getRandom());
  Effect pastellishWalker3 = new WalkingEffect(Analyser.BEAT, false, 2, pastellish.getRandom());
  Effect pastellishWalker4 = new WalkingEffect(Analyser.BEAT, false, 3, pastellish.getRandom());
  Effect pastellishWalker5 = new WalkingEffect(Analyser.BEAT, false, 4, pastellish.getRandom());
  Effect darkYellowRunner = new WalkingEffect(Analyser.BEAT, false, 0, 100, new ColorPalette("#D4DB00"));
  
  // Backgrounds:
  Effect whiteBackground = new BackgroundColorEffect(Color.WHITE);
  Effect redBackground = new BackgroundColorEffect(Color.RED);
  
  // Stroboskops:
  Effect randomWhiteStroboskop = new StroboskopEffect(Analyser.BEAT, -1, 2, 0.3, new ColorPalette(Color.WHITE));
  
  // Flashs:
  Effect whiteFlashOnBeat = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 1000, new ColorPalette(Color.WHITE));
  Effect shrillFlickerOnBeat = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 500, shrill);
  Effect shrillFlickerOnBeat1 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.getRandom());
  Effect shrillFlickerOnBeat2 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.getRandom());
  Effect shrillFlickerOnBeat3 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.getRandom());
  Effect flashMeWhite = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 1500, new ColorPalette(Color.WHITE));
  
  // Breathings:
  Effect darkRedBreathing = new BreathingEffect(0, 4000, 0, new ColorPalette(new Color(255, 0, 0, 120)));
  
  
  // DECLARE COMPOSITIONS HERE
  compositions = new ArrayList<Composition>();
  
  compositions.add(new Composition(randomShrillBeatFlickerWalker,
                                   randomShrillBeatFlickerWalker.clone(),
                                   randomShrillBeatFlickerWalker.clone()));
  compositions.add(new Composition(darkRedBreathing,
                                   randomWhiteStroboskop,
                                   randomWhiteStroboskop.clone()));
  compositions.add(new Composition(whiteBackground,
                                   walkingBlue,
                                   randomRedHatWalker));
  compositions.add(new Composition(whiteBackground,
                                   randomEleganzWalker1,
                                   randomEleganzWalker2,
                                   randomEleganzWalker3));
  compositions.add(new Composition(pastellishWalker1, pastellishWalker2, pastellishWalker3, pastellishWalker4, pastellishWalker5));
  compositions.add(new Composition(shrillFlickerOnBeat, shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone()));
  compositions.add(new Composition(pastellishWalker1, pastellishWalker3, flashMeWhite));
  
  // Pick a random initial composition.
  currentComposition = compositions.get(randomInt(compositions.size()));
}