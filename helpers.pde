public int byteToInt(byte input) {
  return (int)input + 128;
}

public byte intToByte(int input) {
  if (input <= 255) {
    return (byte)(input - 128);
    } else {
      print("too high of an int ");
      println(input);
      return 0; // not supposed to happen
    }
}

public int randomInt(int max) {
  return (int)random(max);
}