float posSin(float amp, float theta) { return amp * pow(sin(theta), 2); }
float modifyRed(vec2 pol) {
  if (swirl > 0) {
    return (pol.x * swirlAmount) + (swirlDirection * (pol.y / swirlAmount));
  }
  return pol.x + posSin(sin(TIME / 4), pol.y);
}

vec2 getPos() {
  float x = _uv.x * shapeOscillation * sin(TIME / 9) / 2;
  float y = _uv.y * shapeOscillation * (syn_BPMSin4 * syn_BPMSin2) / 2;
  return abs(_uv + vec2(x, y)) * 2 - 1;
}

vec4 renderMain(void) {
  vec2 pos = _rotate(getPos(), rotateDirection * syn_BPM * TIME / 600);
  vec2 pol = _toPolar(pos);
  pol = fract(pol * swirlRepeats);
  //   float rA = smoothstep(pow(sin(TIME / 5), 2), pow(sin(TIME / 7), 2),
  //   polar.x);
  //   float rB = smoothstep(pow(cos(TIME / 5), 2), pow(cos(TIME / 7), 2),
  //   polar.x);
  //   float r = fract((pow(rA + rB, 4) + pow(rA + rB, 2) / 2));
  float N = 6 * pow(sin(TIME / 7), 2) + 2;
  float r = 2 * PI / N;
  float aLin = atan(posSin(pos.x, syn_BPMSin2), posSin(pos.y, syn_BPMSin2));
  float aPoly;
  if (shapePower > 0) {
    aPoly = atan(log(pos.x * pos.x * pos.x * syn_BPMSin4),
                 posSin(pos.y * pos.y * pos.y, syn_BPMSin4));
  } else {
    aPoly = atan(posSin(pos.x * pos.x, syn_BPMSin4),
                 posSin(pos.y * pos.y, syn_BPMSin4));
  }

  float a = (shapeWeight * aLin) + ((1 - shapeWeight) * aPoly);
  float d = cos(floor(.5 + a / r) * r - a) * length(pos);

  vec3 colour = vec3(smoothstep(posSin(shapeSize, TIME / 7),
                                posSin(shapeSize + shapeFade, TIME / 7), d));
  colour.r *= modifyRed(pol);
  colour.g *= 1 - posSin(pol.x, TIME / 15);
  colour.b *= cos(pol.y);
  colour = fract(colour * 2);
  if (colour == vec3(0)) {
    colour =
        _loadUserImage(vec2(abs(_uvc.x), posSin(abs(_uvc.x), a / TIME))).xyz;
  }
  colour = abs(fract(colour * 2) -
               2 * fract(_loadUserImage().xyz * posSin(1.5, TIME / 17)));
  vec3 hsv = _rgb2hsv(colour);
  hsv.x *= 1 + (morphColours * syn_BPMSin4);
  colour = _hsv2rgb(hsv);

  return vec4(colour, 1.0);
}
