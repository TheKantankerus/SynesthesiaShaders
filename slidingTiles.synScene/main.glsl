float bassLevel = syn_BassLevel * syn_BassLevel / 60;
float trebleLevel = syn_HighLevel * syn_HighLevel / 60;

float sq(float x) { return x * x; }
float avg(float x, float y) { return (x + y) / 2; }
float hypoteneuse(float x, float y) { return sqrt(sq(x) + sq(y)); }
float parabola(float x) { return sq(4.0 * x * (1.0 - x)); }
vec4 temporal_morph(vec4 a, vec4 b) {
  float red = (sq(cos(TIME / 120)) * max(a.x, b.x)) +
              (sq(sin(TIME / 12)) * avg(a.x, b.x));
  float blue = (sq(sin(TIME / 110)) * max(a.y, b.y)) +
               (sq(cos(TIME / 11)) * avg(a.y, b.y));
  float green = (sq(sin(TIME / 90)) * hypoteneuse(a.z, b.z)) +
                (sq(cos(TIME / 9)) * avg(a.z, b.z));
  return vec4(red, blue, green, hypoteneuse(a.a, b.a));
}

vec4 renderMain(void) {
  float red, green, blue;
  vec2 position = _uv;
  vec2 offset = vec2(sin(TIME / 90) * x_trans_amt, cos(TIME / 130) * y_trans_amt);
  position += offset;
  float tileCount =
      1 + sin(syn_BassTime / 50) + sin(syn_HighTime/10) + sin(syn_MidTime / 30);
  vec2 tile = fract(_rotate(position * tileCount, 2*PI*_ncos(TIME/17)));
 
  red = parabola(tile.x * tile.x) * parabola(tile.y * tile.y);
  green = parabola(tile.x) + parabola(tile.y);
  blue = tan(2 * PI * (tile.x * tile.x - tile.y * tile.y));
  red *= 2 * sin(TIME);
  blue *= 3 * cos(bassLevel) * cos(TIME);
  green *= sq(cos(trebleLevel)) * sq(sin(TIME / 3));
  red *= red * 0.5;
  blue *= blue * 0.5;
  green *= green * 0.5;

  vec4 media = _loadUserImage(vec2(offset));
  media = fract(media * tileCount);

  return temporal_morph(media, vec4(red, green, blue, 1.0));
}
