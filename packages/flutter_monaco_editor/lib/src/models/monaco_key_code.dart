// Monaco KeyCode and KeyMod constants as Dart-side ints.
//
// Values are lifted directly from Monaco's TypeScript definitions (see
// `assets/monaco.d.ts` — declare enum KeyCode). Combine KeyMod flags with
// KeyCode using bitwise OR:
//
//   final save = MonacoKeyMod.ctrlCmd | MonacoKeyCode.keyS;
//
// Only the commonly-used subset is enumerated here. Raw integers are
// accepted everywhere keybindings are expected, so uncommon keys can still
// be expressed: e.g. `MonacoKeyMod.ctrlCmd | 117` for AudioVolumeMute.

/// Monaco KeyMod flags. `ctrlCmd` is Cmd on macOS and Ctrl elsewhere —
/// which is almost always what you want. Use `winCtrl` for literal Ctrl on
/// macOS too.
class MonacoKeyMod {
  const MonacoKeyMod._();
  static const int ctrlCmd = 2048;
  static const int shift = 1024;
  static const int alt = 512;
  static const int winCtrl = 256;
}

/// Monaco KeyCode numeric constants. The values must match Monaco's runtime
/// enum exactly — see `assets/monaco.d.ts`.
class MonacoKeyCode {
  const MonacoKeyCode._();

  static const int unknown = 0;
  static const int backspace = 1;
  static const int tab = 2;
  static const int enter = 3;
  static const int shift = 4;
  static const int ctrl = 5;
  static const int alt = 6;
  static const int pauseBreak = 7;
  static const int capsLock = 8;
  static const int escape = 9;
  static const int space = 10;
  static const int pageUp = 11;
  static const int pageDown = 12;
  static const int end = 13;
  static const int home = 14;
  static const int leftArrow = 15;
  static const int upArrow = 16;
  static const int rightArrow = 17;
  static const int downArrow = 18;
  static const int insert = 19;
  static const int delete = 20;

  static const int digit0 = 21;
  static const int digit1 = 22;
  static const int digit2 = 23;
  static const int digit3 = 24;
  static const int digit4 = 25;
  static const int digit5 = 26;
  static const int digit6 = 27;
  static const int digit7 = 28;
  static const int digit8 = 29;
  static const int digit9 = 30;

  static const int keyA = 31;
  static const int keyB = 32;
  static const int keyC = 33;
  static const int keyD = 34;
  static const int keyE = 35;
  static const int keyF = 36;
  static const int keyG = 37;
  static const int keyH = 38;
  static const int keyI = 39;
  static const int keyJ = 40;
  static const int keyK = 41;
  static const int keyL = 42;
  static const int keyM = 43;
  static const int keyN = 44;
  static const int keyO = 45;
  static const int keyP = 46;
  static const int keyQ = 47;
  static const int keyR = 48;
  static const int keyS = 49;
  static const int keyT = 50;
  static const int keyU = 51;
  static const int keyV = 52;
  static const int keyW = 53;
  static const int keyX = 54;
  static const int keyY = 55;
  static const int keyZ = 56;

  static const int meta = 57;
  static const int contextMenu = 58;

  static const int f1 = 59;
  static const int f2 = 60;
  static const int f3 = 61;
  static const int f4 = 62;
  static const int f5 = 63;
  static const int f6 = 64;
  static const int f7 = 65;
  static const int f8 = 66;
  static const int f9 = 67;
  static const int f10 = 68;
  static const int f11 = 69;
  static const int f12 = 70;

  static const int numLock = 83;
  static const int scrollLock = 84;
  static const int semicolon = 85;
  static const int equal = 86;
  static const int comma = 87;
  static const int minus = 88;
  static const int period = 89;
  static const int slash = 90;
  static const int backquote = 91;
  static const int bracketLeft = 92;
  static const int backslash = 93;
  static const int bracketRight = 94;
  static const int quote = 95;
}
