/// SETTINGS ///

#define _EXC _ 33  // " ! "
#define _DBQ _ 34  // " " "
#define _NUM _ 35  // " # "
#define _DOL _ 36  // " $ "
#define _PER _ 37  // " % "
#define _AMP _ 38  // " & "
#define _QUOT _ 39 // " ' "
#define _LPR _ 40  // " ( "
#define _RPR _ 41  // " ) "
#define _MUL _ 42  // " * "
#define _ADD _ 43  // " + "
#define _COM _ 44  // " , "
#define _SUB _ 45  // " - "
#define _DOT _ 46  // " . "
#define _DIV _ 47  // " / "
#define _COL _ 58  // " : "
#define _SEM _ 59  // " ; "
#define _LES _ 60  // " < "
#define _EQU _ 61  // " = "
#define _GRE _ 62  // " > "
#define _QUE _ 63  // " ? "
#define _AT _ 64   // " @ "
#define _LBR _ 91  // " [ "
#define _ANTI _ 92 // " \ "
#define _RBR _ 93  // " ] "
#define _UND _ 95  // " _ "

/// CHARACTER DEFINITIONS ///

// Uppercase letters (65-90)
#define _A _ 65
#define _B _ 66
#define _C _ 67
#define _D _ 68
#define _E _ 69
#define _F _ 70
#define _G _ 71
#define _H _ 72
#define _I _ 73
#define _J _ 74
#define _K _ 75
#define _L _ 76
#define _M _ 77
#define _N _ 78
#define _O _ 79
#define _P _ 80
#define _Q _ 81
#define _R _ 82
#define _S _ 83
#define _T _ 84
#define _U _ 85
#define _V _ 86
#define _W _ 87
#define _X _ 88
#define _Y _ 89
#define _Z _ 90

// Lowercase letters (97-122)
#define _a _ 97
#define _b _ 98
#define _c _ 99
#define _d _ 100
#define _e _ 101
#define _f _ 102
#define _g _ 103
#define _h _ 104
#define _i _ 105
#define _j _ 106
#define _k _ 107
#define _l _ 108
#define _m _ 109
#define _n _ 110
#define _o _ 111
#define _p _ 112
#define _q _ 113
#define _r _ 114
#define _s _ 115
#define _t _ 116
#define _u _ 117
#define _v _ 118
#define _w _ 119
#define _x _ 120
#define _y _ 121
#define _z _ 122

// Digits (48-57)
#define _0 _ 48
#define _1 _ 49
#define _2 _ 50
#define _3 _ 51
#define _4 _ 52
#define _5 _ 53
#define _6 _ 54
#define _7 _ 55
#define _8 _ 56
#define _9 _ 57

uniform int word[9] = int[](84, 87, 79, 70, 76, 79, 87, 69, 82);

// Print character
float _char(vec2 u, int id) {
  u = max(min(u, 1.0), 0.0);
  vec2 p = vec2(id % 16, 15. - floor(float(id) / 16.));
  p = (u + p) / 16.;
  u = step(abs(u - .5), vec2(.5));
  return texture(image49, p).r * u.x * u.y;
}

vec2 oscOffset(int i, float ratio) {
  if (noOsc > 0) {
    if (glitchyOsc > 0) {
      return vec2(i / 2.0,
                  4.0 - ratio / 4.0 + _sqPulse(0.1, sin(TIME + i), 0.1));
    }
    return vec2(i / 2.0, 4.0 - ratio / 3.0);
  }
  if (glitchyOsc > 0) {
    return _pixelate(vec2(i / 2.0, (4.0 * _ncos(TIME / (i / 10.0 + ratio)))),
                     4);
  }
  return vec2(i / 2.0, 4.0 * _ncos(TIME / (i / 10.0 + ratio)));
}

int getLetter(int i) {
  if (glitchLetters > 0) {
    return word[i] + int(_statelessContinuousChaotic(TIME / 500) *
                         glitchFactor * _sqPulse(0.1, sin(TIME + i), 0.1));
  }
  return word[i];
}

vec4 wordColor() {
  vec4 col = _loadUserImage();
  vec2 pos = _uv * (word.length() + 1.0) / 2.0;

  for (int i = 0; i < word.length(); i++) {

    float wordCol = 1.0;
    for (int j = 0; j < textCount + noOsc * textCount; j++) {
      wordCol +=
          _char(pos - oscOffset(i, 2.0 + j / 2 * textSpacing), getLetter(i));
    }

    if (wordCol > 1.0 + _ncos(TIME / 50.0)) {
      wordCol = 0.0;
    }
    col *= wordCol;
  }
  if (col == vec4(0.0)) {
    return vec4(1.0) - _loadUserImage();
  }
  return col;
}

vec4 renderMain() { return wordColor(); }