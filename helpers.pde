public int byteToInt(byte input) {
  return (int)input + 128;
}

public byte intToByte(int input) {
  if (input <= 255) {
    return (byte)(input - 128);
    } else {
      println("too high of an int");
      return 0; // not supposed to happen
    }
}
