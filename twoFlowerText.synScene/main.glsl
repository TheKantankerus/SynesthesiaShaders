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
  return vec2(i / 2.0,
              4.0 * _ncos(TIME / (i / 10.0 + ratio)) + textCount / 2.0);
}

int getLetter(int i) {
  if (glitchLetters > 0) {
    return i +
           int(_statelessContinuousChaotic(TIME + i / 500.0) * glitchFactor *
               _sqPulse(0.2, sin(TIME + i), 0.1)) %
               14;
  }
  return i;
}

sampler2D getFont() {
  if (fontSelector > 2.0) {
    return telegramma;
  }
  if (fontSelector > 1.0) {
    return canterbury;
  }
  return spacemono;
}

vec4 getChar(vec2 pos, int i, int j) {
  int letter = getLetter(i) + int(11 * sin(j * TIME / 10.0));
  int diff = letter - i;
  return texture(
      getFont(),
      _nclamp(vec2(fract(pos.x + diff / 14.0),
                   (pos.y - 0.1) * 6 -
                       oscOffset(i + j, 2.0 + j * textSpacing / textCount).y +
                       j)));
}

vec4 renderMain() {
  vec2 pos = _uv * 0.8 + vec2(0.05, 0.1);
  vec4 col = _loadUserImage();
  for (int i = 2; i < 11; i++) {
    if (floor(pos.x * 14) == i) {
      for (int j = 0; j < textCount; j++) {
        vec4 fontText = getChar(pos, i, j);
        fontText.b += fontText.r;
        col *= fontText.b;
      }
    }
    if (col == vec4(0.0)) {
      col = vec4(1.0) - _loadUserImage();
    }
  }
  return col;
}