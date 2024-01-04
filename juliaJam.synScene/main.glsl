vec4 renderMain(void)
{
    vec2 z;
    vec2 c = vec2(sin(TIME / 3), cos(TIME / 4)) ;
    int iter=2;
    z.x = 3.0 * (_uv.x - 0.5);
    z.y = 2.0 * (_uv.y - 0.5);
 
    for(int i=0; i<10 * _nsin(TIME/7) + iterOffset; i++) {
        float x = (z.x * z.x - z.y * z.y) + c.x;
        float y = (z.y * z.x + z.x * z.y) + c.y;

        if((x * x + y * y) > 4.0) break;
        z.x = x;
        z.y = y;
    }
    
    float fractFactor = sin(TIME / 5);
    
    return z.x > fractFactor && z.y > fractFactor ? _loadUserImage(z* 0.1) : vec4(1)-_loadUserImage(z*0.1);
}
