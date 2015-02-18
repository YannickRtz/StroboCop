public void compose() {

/* EFFECTS CHEAT SHEET:
 *
 * EventTypes: Analyser.BEAT, Analyser.KICK, Analyser.HAT & Analyser.SNARE
 * ScreenNumber: 0 ist all screens, -1 is random screens
 * 
 * Constructors:
 * SimpleChangeEffect(eventType, screenNumber, colors)
 * BackgroundColorEffect(color) <= Use always as first effect
 * StroboskopEffect(eventType, screenNumber, framesDuration, propability, colors)
 * BreathingEffect(screenNumber, duration, offset, colors)
 * FlashOnBeatEffect(eventType, isFlickerMode, screenNumber, duration, colors)
 * WalkingEffect(eventType, isRandomMode, offset, colors)
 * Timed Mode: WalkingEffect(eventType, isRandomMode, offset, tempo, colors)
 */

  // DECLARE EFFECTS HERE
  // Simple changer:
  Effect simpleHard = new SimpleChangeEffect(Analyser.BEAT, -1, hardMode);
  Effect simpleAlmostCold = new SimpleChangeEffect(Analyser.BEAT, -1, almostCold);
  Effect simpleSolidHard = new SimpleChangeEffect(Analyser.BEAT, 0, hardMode);
  Effect simpleCircus = new SimpleChangeEffect(Analyser.BEAT, -1, circus);
  
  // Walkers:
  Effect walkingBlue = new WalkingEffect(Analyser.BEAT, false, 0, new ColorPalette(Color.BLUE));
  Effect randomRedHatWalker = new WalkingEffect(Analyser.BEAT, true, 0, new ColorPalette(Color.RED));
  Effect randomWhiteHatWalker = new WalkingEffect(Analyser.HAT, true, 0, new ColorPalette(Color.WHITE));
  Effect randomShrillBeatFlickerWalker = new WalkingEffect(Analyser.BEAT, true, 0, shrill);
  Effect randomPastellishBeatFlickerWalker = new WalkingEffect(Analyser.BEAT, true, 0, pastellish);
  Effect randomEleganzBeatFlickerWalker = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz);
  Effect randomEleganzWalker1 = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz.get(0));
  Effect randomEleganzWalker2 = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz.get(1));
  Effect randomEleganzWalker3 = new WalkingEffect(Analyser.BEAT, true, 0, almostEleganz.get(2));
  Effect pastellishWalker1 = new WalkingEffect(Analyser.BEAT, false, 0, pastellish.get(0));
  Effect pastellishWalker2 = new WalkingEffect(Analyser.BEAT, false, 1, pastellish.get(1));
  Effect pastellishWalker3 = new WalkingEffect(Analyser.BEAT, false, 2, pastellish.get(2));
  Effect pastellishWalker4 = new WalkingEffect(Analyser.BEAT, false, 3, pastellish.get(3));
  Effect pastellishWalker5 = new WalkingEffect(Analyser.BEAT, false, 4, pastellish.get(4));
  Effect darkYellowRunner = new WalkingEffect(Analyser.BEAT, false, 0, 100, new ColorPalette("#D4DB00"));
  Effect darkBlueRunner = new WalkingEffect(Analyser.BEAT, false, 0, 60, new ColorPalette(new Color(0,0,255,100)));
  Effect pinkRunner = new WalkingEffect(Analyser.BEAT, false, 2, 110, new ColorPalette("#FF85BE"));
  Effect greenRunner = new WalkingEffect(Analyser.BEAT, false, 1, 110, new ColorPalette(Color.GREEN));
  Effect yellowRunner = new WalkingEffect(Analyser.BEAT, false, 3, 110, new ColorPalette(Color.YELLOW));
  Effect cyanRunner = new WalkingEffect(Analyser.BEAT, false, 0, 110, new ColorPalette(Color.CYAN));
  Effect randomBlackWalker = new WalkingEffect(Analyser.BEAT, true, 0, new ColorPalette(Color.BLACK));
  Effect randomCircusWalker1 = new WalkingEffect(Analyser.BEAT, true, 0, circus.get(0));
  Effect randomCircusWalker2 = new WalkingEffect(Analyser.KICK, true, 0, circus.get(1));
  Effect randomCircusWalker3 = new WalkingEffect(Analyser.HAT, true, 0, circus.get(2));
  Effect randomCircusWalker4 = new WalkingEffect(Analyser.BEAT, true, 0, circus.get(3));
  Effect randomCircusWalker5 = new WalkingEffect(Analyser.BEAT, true, 0, circus.get(4));
  
  // Backgrounds:
  Effect whiteBackground = new BackgroundColorEffect(Color.WHITE);
  Effect redBackground = new BackgroundColorEffect(Color.RED);
  Effect blueBackground = new BackgroundColorEffect(Color.BLUE);
  
  // Stroboskops:
  Effect randomWhiteStroboskop = new StroboskopEffect(Analyser.BEAT, -1, 1, 1, new ColorPalette(Color.WHITE));
  Effect pastellishUltraStroboskop = new StroboskopEffect(Analyser.BEAT, 0, 2, 0.3, pastellish);
  Effect coldRandomStroboskop = new StroboskopEffect(Analyser.BEAT, -1, 2, 0.2, almostCold);
  Effect coldUltraStroboskop = new StroboskopEffect(Analyser.BEAT, 0, 2, 0.2, cold);
  Effect hotUltraStroboskop = new StroboskopEffect(Analyser.BEAT, 0, 1, 0.2, fireplace);
  Effect eleganzRandomStroboskop = new StroboskopEffect(Analyser.BEAT, -1, 2, 0.9, almostEleganz);
  Effect whiteUltraStroboskop = new StroboskopEffect(Analyser.BEAT, 0, 1, 0.2, new ColorPalette(Color.WHITE));
  Effect greySubtleStroboskop1 = new StroboskopEffect(Analyser.KICK, 0, 1, 1, new ColorPalette(new Color(0, 0, 0, 50)));
  Effect greySubtleStroboskop2 = new StroboskopEffect(Analyser.HAT, 0, 1, 1, new ColorPalette(new Color(0, 0, 0, 50)));
  Effect greySubtleStroboskop3 = new StroboskopEffect(Analyser.SNARE, 0, 1, 1, new ColorPalette(new Color(0, 0, 0, 50)));
  
  // Flashs:
  Effect whiteFlashOnBeat = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 1000, new ColorPalette(Color.WHITE));
  Effect shrillFlickerOnBeat = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 500, shrill);
  Effect shrillFlickerOnBeat1 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.get(0));
  Effect shrillFlickerOnBeat2 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.get(1));
  Effect shrillFlickerOnBeat3 = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 2000, shrill.get(2));
  Effect flashMeWhite = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 800, new ColorPalette(Color.WHITE));
  Effect flashMeRed = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 600, new ColorPalette(Color.RED));
  Effect flashMeGreen = new FlashOnBeatEffect(Analyser.KICK, false, 0, 600, new ColorPalette(Color.GREEN));
  Effect flashMeBlue = new FlashOnBeatEffect(Analyser.SNARE, false, 0, 600, new ColorPalette(Color.BLUE));
  Effect flashMeCircus1 = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 400, circus.get(0));
  Effect flashMeCircus2 = new FlashOnBeatEffect(Analyser.HAT, false, 0, 400, circus.get(1));
  Effect flashMeCircus3 = new FlashOnBeatEffect(Analyser.SNARE, false, 0, 400, circus.get(2));
  Effect flashMeCircus4 = new FlashOnBeatEffect(Analyser.KICK, false, 0, 400, circus.get(3));
  Effect flashMeShrill1 = new FlashOnBeatEffect(Analyser.KICK, false, 0, 700, shrill.get(0));
  Effect flashMeShrill2 = new FlashOnBeatEffect(Analyser.HAT, false, 0, 700, shrill.get(1));
  Effect flashMeShrill3 = new FlashOnBeatEffect(Analyser.SNARE, false, 0, 700, shrill.get(2));
  Effect flashMeShrill4 = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 700, shrill.get(3));
  Effect randomIkeaFlash = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 500, ikea);
  Effect randomIkeaFlash1 = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 700, ikea.get(0));
  Effect randomIkeaFlash2 = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 700, ikea.get(1));
  Effect randomIkeaFlash3 = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 700, ikea.get(2));
  Effect randomIkeaFlash4 = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 700, ikea.get(3));
  Effect randomYellowFlash = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 1000, new ColorPalette(Color.YELLOW));
  Effect randomCyanFlash = new FlashOnBeatEffect(Analyser.KICK, false, -1, 1000, new ColorPalette(Color.CYAN));
  Effect randomMagentaFlash = new FlashOnBeatEffect(Analyser.BEAT, false, -1, 1000, new ColorPalette(Color.MAGENTA));
  Effect randomFireplaceFlicker = new FlashOnBeatEffect(Analyser.SNARE, true, -1, 400, fireplace.getRandom());
  Effect eightiesFlashback = new FlashOnBeatEffect(Analyser.BEAT, true, 0, 400, eighties);
  Effect pumpingBlack = new FlashOnBeatEffect(Analyser.BEAT, false, 0, 500, new ColorPalette(Color.BLACK));
  Effect randomBlackFlicker = new FlashOnBeatEffect(Analyser.BEAT, true, -1, 400, new ColorPalette(Color.BLACK));
  
  // Breathings:
  Effect darkRedBreathing = new BreathingEffect(0, 4000, 0, new ColorPalette(new Color(255, 0, 0, 120)));
  Effect randomEleganzBreathing = new BreathingEffect(-1, 2500, 0, almostEleganz);
  Effect whiteBreathing = new BreathingEffect(0, 5000, 0, new ColorPalette(Color.WHITE));
  Effect blueBreathing = new BreathingEffect(0, 4000, 0, new ColorPalette(Color.BLUE));
  Effect redBreathing = new BreathingEffect(0, 4000, 2000, new ColorPalette(Color.RED));
  Effect pinkSlowBreathing = new BreathingEffect(0, 10000, 0, new ColorPalette("#FF85BE"));
  Effect randomFireplaceBreathing1 = new BreathingEffect(-1, 300, 0, fireplace);
  Effect randomFireplaceBreathing2 = new BreathingEffect(-1, 310, 110, fireplace);
  Effect randomFireplaceBreathing3 = new BreathingEffect(-1, 350, 150, fireplace);
  Effect randomColdBreathing1 = new BreathingEffect(-1, 700, 0, cold);
  Effect randomColdBreathing2 = new BreathingEffect(-1, 800, 50, cold);
  Effect randomColdBreathing3 = new BreathingEffect(-1, 750, 60, cold);
  Effect fastEightiesBreathing = new BreathingEffect(-1, 800, 0, eighties);
  
  
  
  // DECLARE COMPOSITIONS HERE
  compositions = new ArrayList<Composition>();
  // compositions.add(new Composition(darkRedBreathing, randomWhiteStroboskop, randomWhiteStroboskop.clone()));
  // compositions.add(new Composition(whiteBreathing, walkingBlue, randomRedHatWalker));
  // compositions.add(new Composition(whiteBackground, randomEleganzWalker1, randomEleganzWalker2, randomEleganzWalker3, shrillFlickerOnBeat));
  // compositions.add(new Composition(pastellishWalker1, pastellishWalker2, pastellishWalker3, pastellishWalker4, pastellishWalker5));
  compositions.add(new Composition(shrillFlickerOnBeat, shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone(), shrillFlickerOnBeat.clone()));
 compositions.add(new Composition(pastellishWalker1, pastellishWalker2, pastellishWalker3, pastellishWalker4, pastellishWalker5, flashMeWhite));
  // compositions.add(new Composition(darkYellowRunner, shrillFlickerOnBeat, shrillFlickerOnBeat.clone()));
  //compositions.add(new Composition(darkBlueRunner, pastellishUltraStroboskop));
  compositions.add(new Composition(randomEleganzBreathing, randomEleganzBreathing.clone(), randomEleganzBreathing.clone(), randomEleganzBreathing.clone(), randomEleganzBreathing.clone(),randomEleganzBreathing.clone(), randomEleganzBreathing.clone(), randomEleganzBreathing.clone(), randomRedHatWalker));
  compositions.add(new Composition(redBackground, whiteFlashOnBeat, whiteFlashOnBeat.clone()));
  compositions.add(new Composition(shrillFlickerOnBeat1,shrillFlickerOnBeat2, shrillFlickerOnBeat3, shrillFlickerOnBeat1.clone(), shrillFlickerOnBeat2.clone(), shrillFlickerOnBeat3.clone()));
  // compositions.add(new Composition(pinkRunner, randomWhiteHatWalker));
  compositions.add(new Composition(pinkSlowBreathing, pumpingBlack, darkBlueRunner));
  // compositions.add(new Composition(randomEleganzBeatFlickerWalker, randomEleganzBeatFlickerWalker.clone(), randomEleganzBeatFlickerWalker.clone()));
  compositions.add(new Composition(redBackground, randomFireplaceBreathing1, randomFireplaceBreathing2, randomFireplaceBreathing3, randomFireplaceBreathing1.clone(), randomFireplaceBreathing2.clone(), randomFireplaceBreathing3.clone(), randomFireplaceFlicker));
  //compositions.add(new Composition(blueBreathing, coldRandomStroboskop, coldRandomStroboskop.clone()));
  compositions.add(new Composition(randomIkeaFlash, randomIkeaFlash.clone(), randomIkeaFlash.clone(), randomIkeaFlash.clone(), randomIkeaFlash.clone(), randomIkeaFlash.clone()));
  compositions.add(new Composition(randomIkeaFlash1, randomIkeaFlash2, randomIkeaFlash3, randomIkeaFlash4, randomIkeaFlash1.clone(), randomIkeaFlash2.clone(), randomIkeaFlash3.clone(), randomIkeaFlash4.clone(), whiteUltraStroboskop));
  // compositions.add(new Composition(darkBlueRunner, randomFireplaceFlicker));
  // compositions.add(new Composition(whiteBackground, yellowRunner, greenRunner, pinkRunner, cyanRunner, randomBlackWalker));
  compositions.add(new Composition(randomYellowFlash, randomCyanFlash, randomMagentaFlash));
  compositions.add(new Composition(flashMeGreen, flashMeBlue, flashMeRed));
  //compositions.add(new Composition(coldUltraStroboskop, randomRedHatWalker, randomRedHatWalker));
  compositions.add(new Composition(randomCircusWalker1, randomCircusWalker2, randomCircusWalker3, randomCircusWalker4, randomCircusWalker5, randomCircusWalker1.clone(), randomCircusWalker2.clone(), randomCircusWalker3.clone()));
  compositions.add(new Composition(flashMeWhite, eightiesFlashback));
  compositions.add(new Composition(blueBackground, randomColdBreathing1, randomColdBreathing2, randomColdBreathing3, randomCircusWalker1, randomCircusWalker2, randomCircusWalker3, greySubtleStroboskop1));
  compositions.add(new Composition(blueBreathing, redBreathing, eleganzRandomStroboskop, eleganzRandomStroboskop.clone()));
  compositions.add(new Composition(fastEightiesBreathing, fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), fastEightiesBreathing.clone(), pastellishUltraStroboskop));
  // compositions.add(new Composition(pumpingPurple, randomCyanFlash, walkingBlue));
  compositions.add(new Composition(flashMeCircus4, flashMeCircus2, flashMeCircus3, flashMeCircus1));
  compositions.add(new Composition(flashMeShrill1, flashMeShrill2, flashMeShrill3, flashMeShrill4));
  compositions.add(new Composition(simpleHard, randomBlackFlicker, randomBlackFlicker.clone(), randomBlackFlicker.clone(), randomBlackFlicker.clone(), randomBlackFlicker.clone(), randomBlackFlicker.clone()));
  compositions.add(new Composition(simpleAlmostCold, hotUltraStroboskop));
  compositions.add(new Composition(simpleSolidHard, randomEleganzBeatFlickerWalker, randomPastellishBeatFlickerWalker, randomShrillBeatFlickerWalker));
  compositions.add(new Composition(simpleCircus, greySubtleStroboskop1, greySubtleStroboskop2, greySubtleStroboskop3));
  
  // Pick a random initial composition.
  currentComposition = compositions.get(randomInt(compositions.size()));
}