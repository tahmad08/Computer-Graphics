// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

// Set in Processing
uniform sampler2D texture;

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() { 
    //make a vector with the current s and t
    float stp = 1.0/256.0;
    vec4 color = vec4(1.0);
    for(float i = 0; i < 20; i++){
        for(float j = 0; j < 20; j++) {
            float currX = (vertTexCoord.s - (stp * 10.0));
            float currY = (vertTexCoord.t - (stp * 10.0));
            vec2 pos = vec2(currX + (stp*i), currY + (stp*j));
            color += texture2D(texture, pos.xy);
        }
    }
    vec3 col = (color.rgb/400.0);
    gl_FragColor = vec4(col, 1.0);
}



