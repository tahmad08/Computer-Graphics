// Fragment shader

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
    gl_FragColor = vec4(0.2, 0.4, 1.0, 0);

    float cx1 = (1.0/6.0);
    float cy1 = (1.0/3.0);
    float oCr = 0.16;
    float iCr = 0.14;

    //top 3 rings
    while(cx1 < 1.0) {
        float xd1 = vertTexCoord.x - cx1;
        float yd1 = vertTexCoord.y - cy1;

        if (( pow(xd1, 2) + pow(yd1, 2) <= pow(oCr, 2)) && ( pow(xd1, 2) + pow(yd1, 2) >= pow(iCr, 2) ) ) {
            gl_FragColor = vec4((13.0/255.0), (99.0/255.0), (19.0/255.0), 1);
        } 
        cx1 += (2.0/6.0);


    }

    //bottom 2 rings
    float cx2 = (1.0/3.0);
    float cy2 = (2.0/3.0) - (1.0/6.0);

    while(cx2 < 1.0) {
        float xd2 = vertTexCoord.x - cx2;
        float yd2 = vertTexCoord.y - cy2;

        if (( pow(xd2, 2) + pow(yd2, 2) <= pow(oCr, 2)) && ( pow(xd2, 2) + pow(yd2, 2) >= pow(iCr, 2) ) ) {
            gl_FragColor = vec4((13.0/255.0), (99.0/255.0), (19.0/255.0), 1);
        } 

        cx2 += (1.0/3.0);

    }

}

