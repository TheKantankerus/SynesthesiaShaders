float box(vec2 st, vec2 size) {
  size = vec2(0.5) - size * 0.5;
  vec2 uv = smoothstep(size, size + 0.05, st);
  uv *= smoothstep(size, size + 0.05, vec2(1) - st);
  uv *= smoothstep(size, size + 0.05, vec2(rectHeight, rectWidth) - st);
  uv *= smoothstep(size, size + 0.05, vec2(1 - rectHeight, 1 - rectWidth) + st);
  uv = _toRect(uv);
  return uv.x * uv.y;
}

float avg(float a, float b) { return (a + b) / 2; }

float compare(float p, float i) {
  if (p <= 0.1)
    return i;
  return avg(p, i * i);
}

vec3 combine(vec3 pattern, vec3 image) {
  return vec3(compare(pattern.r, image.r), compare(pattern.g, image.g),
              compare(pattern.b, image.b));
}

vec4 renderMain(void) {
  float r, g, b, f;
  vec2 pos = _uv;
  vec2 polPos = _toPolarTrue(_uv);
  _uv2uvc(pos);
  pos = fract(_rotate(pos, rotSpeed * TIME / 10) * (1 + 8 * sin(TIME / 1370)) *
              (1 / rectHeight) * (1 / rectWidth));

  vec3 rgb = vec3(0);
  vec3 image_rgb = _loadUserImage().rgb;
  for (float i = 0.1; i < 1; i += 0.1) {
    f = pow(cos(i - sin(TIME / 45)), 2);
    r = box(pos, vec2(f * (1 + sin(syn_HighTime / 15))));
    g = box(pos, vec2(f * pow(cos(syn_MidTime / 35), 2)));
    b = box(pos, vec2(f * _pixelate(syn_BassLevel, 0.3))) * pos.y;
    rgb += vec3(r, g, b);
  }

  rgb *= fract(rgb * (1 + pow((syn_BPMSin4 / 4), 2)));
  rgb = combine(rgb, image_rgb);

  // rgb.r = max(rgb.r, image_rgb.r);
  // rgb.g = (rgb.g + image_rgb.g) / 2;
  // rgb.b = (min(rgb.b, image_rgb.b) + pow(syn_BPMSin4, 2)) / 2;

  vec3 hsv = _rgb2hsv(rgb);
  vec2 refracted =
      refract(polPos, atan(polPos + sin(TIME / 11)),
              atan(polPos.x) * (polPos.y * (2 + sin(TIME / 13)) * (2 * PI)));
  hsv.x =
      hsv.x + refracted.x - refracted.y + (0.15 * syn_BPMSin4) + (TIME / 31);
  rgb = _hsv2rgb(hsv);

  return (vec4(rgb, 1.0));
}
