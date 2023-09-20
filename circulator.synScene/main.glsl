vec4 renderMain(void) {
  vec2 pos = _uvc * 4;
  vec2 pol = _toPolar(pos);
  pos = _rotate(pos, TIME / 15);
  pol = _rotate(pol, -TIME / 16);
  float colour = sqrt(tan(pos.y / pol.y * pos.x / pol.x)) / pol.x;
  float r = _pixelate(colour * pol.x, 14);
  float g = _pixelate(colour * pol.y, 10);
  float b = _pixelate(colour - pos.x, 17);
  vec3 colours = vec3(r, g, b);
  colours = fract(colours * ((sin(pol.y) / 4) + 1));

  if (_toPolar(_uvc).x < sin(TIME / 19)) {
    colours = _loadUserImage(abs(pos * sin(TIME / 17))).xyz, colours;
  }

  return vec4(_pixelate(colours, 3 + (2 * sin(TIME / 4))), 1.0);
}
