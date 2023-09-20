
float posSin(float x) { return (sin(x) + 1) / 2; }

mat2 rotate2d(float _angle) {
  return mat2(cos(_angle), -sin(_angle), sin(_angle), cos(_angle));
}

vec3 petals(vec2 position, float a, float r) {
  float f;
  if (altPetalShape == 1) {
    float altR = 2. * PI / (4 * posSin(syn_BeatTime / 4.));
    float altA = (0.5 + posSin(TIME / 7.) / 2.) * a;
    f = pow(cos(floor(0.5 + altA / altR) * altR - altA) * length(position),
            petalPower / 2.0);
    vec3 output = vec3(0);
    for (float i = 0.1; i < 1.0; i += 0.05) {
      output += vec3(smoothstep(i, i + 0.01, f));
    }
    return fract(output * petalWaves / 100.0);
  }
  f = pow(cos((a * posSin(fract(TIME / 14)))), petalPower);
  return fract(vec3(smoothstep(f, f + r, r)) * petalWaves);
}

vec4 renderMain(void) {
  vec2 position = _uv;
  float red = 1; // posSin(TIME / 7);
  //(position.x * sin(TIME / 4)) + ((1 - position.x) * cos(TIME / 13));
  float blue = 0;
  //(position.y * cos(TIME / 2)) + ((1 - position.y) * sin(TIME * 2));
  float green = 0; // posSin(TIME / 8);
  vec2 centerPos = 0.5 - position;
  float r = length(centerPos) * 2;

  vec3 hsvColours = _rgb2hsv(vec3(red, blue, green));
  hsvColours.x = min(r, 1) * posSin(TIME / 4);
  vec3 rgbColours = _hsv2rgb(hsvColours);

  centerPos *=
      rotate2d(cos(TIME * r) / ((4 * posSin(TIME / 8)) + r * r * sqrt(TIME)));
  float a = atan(centerPos.x, centerPos.y) * clamp(2.0, 0.8, 1.2);
  vec3 petals = petals(centerPos, a, r);
    
    vec4 image = _loadUserImage();
  vec4 toRender = vec4(fract(image.xyz * (1 - petals * 4* cos(syn_BeatTime/PI))), 1.0);
  return max(image, toRender);
}
