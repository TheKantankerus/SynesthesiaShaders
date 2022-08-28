vec4 iMouse = vec4(MouseXY*RENDERSIZE, MouseClick, MouseClick); 


			//******** BuffA Code Begins ********

#define s1 sin(TIME*5.0)
#define c1 cos(TIME*5.0)
#define s2 sin((TIME+(TIME/float(FRAMECOUNT))/4.0)*5.0)
#define c2 cos((TIME+(TIME/float(FRAMECOUNT))/4.0)*5.0)
#define s3 sin((TIME+2.0*(TIME/float(FRAMECOUNT))/4.0)*5.0)
#define c3 cos((TIME+2.0*(TIME/float(FRAMECOUNT))/4.0)*5.0)
#define s4 sin((TIME+3.0*(TIME/float(FRAMECOUNT))/4.0)*5.0)
#define c4 cos((TIME+3.0*(TIME/float(FRAMECOUNT))/4.0)*5.0)

vec4 renderPassA() {
	vec4 fragColor = vec4(0.0);
	vec2 fragCoord = _xy;

    float col = 0.0;
    vec2 uv = (fragCoord-(RENDERSIZE.xy/2.0))/RENDERSIZE.y;
    vec2 off1 = uv - vec2(s1, c1)/vec2(2.0,5.0);
    vec2 off2 = uv - vec2(s2, c2)/vec2(2.0,5.0);
    vec2 off3 = uv - vec2(s3, c3)/vec2(2.0,5.0);
    vec2 off4 = uv - vec2(s4, c4)/vec2(2.0,5.0);
    if(dot(off1, off1)<0.1){
        col += 0.25;
    }
    if(dot(off2, off2)<0.1){
        col += 0.25;
    }
    if(dot(off3, off3)<0.1){
        col += 0.25;
    }
    if(dot(off4, off4)<0.1){
        col += 0.25;
    }
    col = (col+texture(BuffA,fragCoord/RENDERSIZE.xy).r)/2.0;
    fragColor = vec4(col,col,col,1.0);
	return fragColor; 
 } 


vec4 renderMainImage() {
	vec4 fragColor = vec4(0.0);
	vec2 fragCoord = _xy;
   
    fragColor = texture(BuffA,fragCoord/RENDERSIZE.xy).rgba;
	return fragColor; 
 } 


vec4 renderMain(){
	if(PASSINDEX == 0){
		return renderPassA();
	}
	if(PASSINDEX == 1){
		return renderMainImage();
	}
}