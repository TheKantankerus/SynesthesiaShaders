float _piTime = 32 * PI * (0.5 + _triWave(TIME, 13 * PI));

vec4 renderMain(void) {
  vec2 cart = _uvc;
  if (rotDirection < 0) {
    cart.x = -cart.x;
  }
  vec2 pol = _toPolar(cart);
  pol.y += _piTime / 31;
  vec4 img = _loadUserImage(pol);

  img.g = img.g * (1 - pow(sin(pol.y), 2));

  for (int i = 0; i < rotCount + (syn_BPMSin4 * rotMod * rotModAmount); i++) {
    pol = _rotate(pol, _piTime / (13 + rotCount) * rotDirection);
  }

  pol = fract(pol * (1 + 3 * sin(_piTime / 8)));

  img = fract(img * (1 + pol.x) *
              (PI * sin(rotDirection * _piTime / 7) / 2 + pol.y));

  img.x = img.x * (1 + sin(_piTime / 9) * pol.x);

  if (useDiff > 0) {
    return abs(img - _loadUserImage());
  }
  return img - _loadUserImage();
}
