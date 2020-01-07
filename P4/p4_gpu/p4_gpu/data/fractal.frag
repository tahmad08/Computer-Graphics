// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float cx;
uniform float cy;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

vec2 sqr(vec2 zVal){
    //z^2, it's done this way because z is a complex# (a + bi)
    float zx = pow(zVal.x,2) - pow(zVal.y, 2);
    float zy = 2 * (zVal.x * zVal.y);
    //f(z) + c;
    vec2 newZ = vec2(zx, zy) + vec2(cx, cy);
    return newZ;
}

void main() {
    //initially set white
    vec4 color = vec4(1.0);
    
    //[0,1] scale to [-1.5, 1.5] scale
    vec2 z = vec2((vertTexCoord.s * 3.0) - 1.5, (vertTexCoord.t * 3.0) - 1.5);

    for (float i = 1.0; i <= 20.0; i++) {

        //if z is outside the 4.0 radius, then set to diffused RED
        if(sqrt(pow(z.x,2) + pow(z.y,2)) >= 4.0) {
            vec4 diffuse_color = vec4(1.0, 0.0, 0.0, 1.0); //red color
            float diffuse = clamp(dot (vertNormal, vertLightDir),0.0,1.0); //diffuse shit
            color = vec4(diffuse * diffuse_color.rgb, 1.0); //diffuse shit
        }
        //updating z now
        z = sqr(z); 
    }
    gl_FragColor = color;
}


