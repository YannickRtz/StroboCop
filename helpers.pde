public int byteToInt(byte input) {
  return (int)input + 128;
}

public byte intToByte(int input) {
  if (input <= 255 && input >= 0) {
    return (byte)(input - 128);
  } else {
    println("Int out of range: " + input + "! Current composition: " + compositionIndex);
    return input > 255 ? (byte)128 : (byte)-128; // not supposed to happen
  }
}

public int randomInt(int max) {
  return (int)random(max);
}