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
  Effect darkBlueRunner = new WalkingEffect(Analyser.BEAT, false, 0, 60, new ColorPalette(new Color(0,0,255,100)));
  Effect pinkRunner = new WalkingEffect(Analyser.BEAT, false, 2, 80, new ColorPalette("#FF85BE"));
  
  // Backgrounds:
  Effect whiteBackground = new BackgroundColorEffect(Color.WHITE);
  Effect redBackground = new BackgroundColorEffect(Color.RED);
  
  // Stroboskops:
  Effect randomWhiteStroboskop = new StroboskopEffect(Analyser.BEAT, -1, 2, 0.3, new ColorPalette(Color.WHITE));
  Effect pastellishUltraStroboskop = new StroboskopEffect(Analyser.BEAT, 0, 2, 0.3, pastellish);
  
  // Flashs:
  Effect whiteFlashOnBeat = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 1000, new ColorPalette(Color.WHITE));
  Effect shrillFlickerOnBeat = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 500, shrill);
  Effect shrillFlickerOnBeat1 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.getRandom());
  Effect shrillFlickerOnBeat2 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.getRandom());
  Effect shrillFlickerOnBeat3 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.getRandom());
  Effect flashMeWhite = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 800, new ColorPalette(Color.WHITE));
  
  // Breathings:
  Effect darkRedBreathing = new BreathingEffect(0, 4000, 0, new ColorPalette(new Color(255, 0, 0, 120)));
  Effect randomEleganzBreathing = new BreathingEffect(-1, 2500, 0, almostEleganz);
  Effect whiteBreathing = new BreathingEffect(0, 5000, 0, new ColorPalette(Color.WHITE));
  Effect pinkSlowBreathing = new BreathingEffect(0, 10000, 0, new ColorPalette("#FF85BE"));
  Effect randomFireplaceBreathing1 = new BreathingEffect(-1, 300, 0, fireplace);
  Effect randomFireplaceBreathing2 = new BreathingEffect(-1, 310, 110, fireplace);
  Effect randomFireplaceBreathing3 = new BreathingEffect(-1, 230, 150, fireplace);
  
  
  // DECLARE COMPOSITIONS HERE
  compositions = new ArrayList<Composition>();
  compositions.add(new Composition(darkRedBreathing, randomWhiteStroboskop, randomWhiteStroboskop.clone()));
  compositions.add(new Composition(whiteBreathing, walkingBlue, randomRedHatWalker));
  compositions.add(new Composition(whiteBackground, randomEleganzWalker1, randomEleganzWalker2, randomEleganzWalker3, shrillFlickerOnBeat));
  compositions.add(new Composition(pastellishWalker1, pastellishWalker2, pastellishWalker3, pastellishWalker4, pastellishWalker5));
  compositions.add(new Composition(shrillFlickerOnBeat, shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone()));
  compositions.add(new Composition(pastellishWalker1, pastellishWalker3, flashMeWhite));
  compositions.add(new Composition(darkYellowRunner, shrillFlickerOnBeat, shrillFlickerOnBeat.clone()));
  compositions.add(new Composition(darkBlueRunner, pastellishUltraStroboskop));
  compositions.add(new Composition(randomEleganzBreathing, randomEleganzBreathing.clone(), randomEleganzBreathing.clone(), randomEleganzBreathing.clone(), randomRedHatWalker));
  compositions.add(new Composition(redBackground, whiteFlashOnBeat, whiteFlashOnBeat.clone()));
  compositions.add(new Composition(shrillFlickerOnBeat1,shrillFlickerOnBeat2));
  compositions.add(new Composition(pinkRunner, randomWhiteHatWalker));
  compositions.add(new Composition(pinkSlowBreathing, randomPastellishBeatFlickerWalker));
  compositions.add(new Composition(randomEleganzBeatFlickerWalker, randomEleganzBeatFlickerWalker.clone(), randomEleganzBeatFlickerWalker.clone()));
  compositions.add(new Composition(redBackground, randomFireplaceBreathing1, randomFireplaceBreathing2, randomFireplaceBreathing3, randomFireplaceBreathing1.clone(), randomFireplaceBreathing2.clone(), randomFireplaceBreathing3.clone()));
  
  
  
  // Pick a random initial composition.
  currentComposition = compositions.get(randomInt(compositions.size()));
}