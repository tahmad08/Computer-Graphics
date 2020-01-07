// 3D Scene Example
//Tahirah

float time = 0;  // keep track of passing of time
float rad = 3.0;

void setup() {
  size(800, 800, P3D);  // must use 3D here !!!
  noStroke();           // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a sphere and a box
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(0);  // clear the screen to black

  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);

  // place the camera in the scene (just like gluLookAt())
  camera (0.0, 0.0, 85.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
    
  // create an ambient light source
  ambientLight (102, 102, 102);

  // create two directional light sources
  lightSpecular (204, 204, 204);
  directionalLight (102, 102, 102, -0.7, -0.7, -1);
  directionalLight (152, 152, 152, 0, 0, -1);
  rotateY(.5*time);
  drawBuffBoi();


  // step forward in time
  time += 0.02;
}
void drawBoi() {
  belly();
  arms();
  legs();
  head();
}
void drawBuffBoi() {
  buffBelly();
  buffArms();
  buffLegs();
  buffHead();
}
void buffHead() {
    fill(132, 117, 26);
    pushMatrix();
    translate(0, -18, 0);
    scale(1.5, 1.3, 1.1);
    sphere(5.5);
    popMatrix();
    
    //ears
    pushMatrix();
    translate(-5,-23,1);
    scale(1.5,1.5,1);
    sphere(2);
    popMatrix();
    //pink part
    fill(119, 31, 108);
    pushMatrix();
    translate(-5,-23,1.9);
    scale(1.5,1.5,.9);
    sphere(1.3);
    popMatrix();
    
    //right ear
    fill(132, 117, 26);
    pushMatrix();
    translate(5,-23,1);
    scale(1.5,1.5,1);
    sphere(2);
    popMatrix();
    //pink part
    fill(119, 31, 108);
    pushMatrix();
    translate(5,-23,1.9);
    scale(1.5,1.5,.9);
    sphere(1.3);
    popMatrix();
    
    //snout
    fill(81,71,8);
    pushMatrix();
    translate(0,-17,5);
    scale(1.2, 1, 1.01);
    sphere(3);
    popMatrix();
    
    //nose
    fill(0);
    pushMatrix();
    translate(0,-17,7.5);
    scale(1.2, 1, 1.01);
    sphere(1);
    popMatrix();
    
    fill(255, 0, 0);
    pushMatrix();
    translate(-3,-19.5,5);
    scale(1.5,1.5,1);
    sphere(.85);
    popMatrix();
    
    //eyes
    fill(255,0,0);
    pushMatrix();
    translate(3,-19.5,5);
    scale(1.5,1.5,1);
    sphere(.85);
    popMatrix();
}
void head() {
    fill(132, 117, 26);
    pushMatrix();
    translate(0, -18, 0);
    scale(1.5, 1.3, 1.1);
    sphere(5.5);
    popMatrix();
    
    //ears
    pushMatrix();
    translate(-5,-23,1);
    scale(1.5,1.5,1);
    sphere(2);
    popMatrix();
    //pink part
    fill(119, 31, 108);
    pushMatrix();
    translate(-5,-23,1.9);
    scale(1.5,1.5,.9);
    sphere(1.3);
    popMatrix();
    
    //right ear
    fill(132, 117, 26);
    pushMatrix();
    translate(5,-23,1);
    scale(1.5,1.5,1);
    sphere(2);
    popMatrix();
    //pink part
    fill(119, 31, 108);
    pushMatrix();
    translate(5,-23,1.9);
    scale(1.5,1.5,.9);
    sphere(1.3);
    popMatrix();
    
    //snout
    fill(81,71,8);
    pushMatrix();
    translate(0,-17,5);
    scale(1.2, 1, 1.01);
    sphere(3);
    popMatrix();
    
    //nose
    fill(0);
    pushMatrix();
    translate(0,-17,7.5);
    scale(1.2, 1, 1.01);
    sphere(1);
    popMatrix();
    
    float r;
    //eyes
    if (time > 6.49) {
      fill(255, 0, 0);
      r = .85;
    } else {
      fill(22);
      r = .75;
    }
    pushMatrix();
    translate(-3,-19.5,5);
    scale(1.5,1.5,1);
    sphere(r);
    popMatrix();
    
    //eyes
    if (time > 6.49) {
      fill(255, 0, 0);
      r = .85;
    } else {
      fill(22);
      r = .75;
    }
    pushMatrix();
    translate(3,-19.5,5);
    scale(1.5,1.5,1);
    sphere(r);
    popMatrix();
    
}

void buffLegs() {
    //leg
    fill(132, 117, 26);
    float r = 4.5;
    float x0 = -5;
    float y0 = 10;
    for(int i = 0; i < 30; i++){
        //left leg
        pushMatrix();
        translate(x0, y0, 0);
        sphere(r);
        popMatrix();
        
        //right leg
        pushMatrix();
        translate(x0*-1, y0, 0);
        sphere(r);
        popMatrix();
        r-=.03;
        y0+=.5;
    }
    
    //left foot
    float x1 = x0;
    float y1 = y0;
    pushMatrix();
    translate(x1,y1,1.5);
    scale(1.01,1,1.4);
    sphere(3);
    popMatrix();
    
    //right foot
    pushMatrix();
    translate(x1*-1,y1,1.5);
    scale(1.01,1,1.2);
    sphere(3);
    popMatrix();
}
void buffBelly() {
      //make this bitch chubby asf
    fill(132, 117, 26);
    pushMatrix();
    scale(1.15, 1.4, .7);
    sphere(10);
    popMatrix();
    //pink part
    fill(119, 31, 108);
    pushMatrix();
    translate(0,0,3);
    scale(1,1.1,.5);
    sphere(9);
    popMatrix();
}
void belly(){
    //make this bitch chubby asf
    fill(132, 117, 26);
    pushMatrix();
    scale(1.15, 1.4, .9);
    sphere(10);
    popMatrix();
    //pink part
    fill(119, 31, 108);
    pushMatrix();
    translate(0,0,5);
    scale(1,1.1,.5);
    sphere(9);
    popMatrix();
}

void legs(){
  //leg
    fill(132, 117, 26);
    float r = 4;
    float x0 = -5;
    float y0 = 10;
    for(int i = 0; i < 21; i++){
        //left leg
        pushMatrix();
        translate(x0, y0, 0);
        sphere(r);
        popMatrix();
        
        //right leg
        pushMatrix();
        translate(x0*-1, y0, 0);
        sphere(r);
        popMatrix();
        r-=.03;
        y0+=.5;
    }
    
    //left foot
    float x1 = x0;
    float y1 = y0;
    pushMatrix();
    translate(x1,y1,1.5);
    scale(1.01,1,1.4);
    sphere(3);
    popMatrix();
    
    //right foot
    pushMatrix();
    translate(x1*-1,y1,1.5);
    scale(1.01,1,1.2);
    sphere(3);
    popMatrix();
    
}
void buffArms() {
  fill(132, 117, 26);
      //top half of arms (should be a cylinder)
    float r = 3.5;
    float x0 = -7;
    float y0 = -8;
    for(int i = 0; i < 10; i++){
        pushMatrix();
        translate(x0, y0, 0);
        if (i == 0) {
          sphere(4.5);
        }
        else if (i == 5) {
          sphere(4.5);
        } if (i == 9) {
          sphere(4);
        }else {
          sphere(3.3);
        }
        popMatrix();
        
        pushMatrix();
        translate(x0*-1, y0, 0);
        if (i == 0) {
          sphere(4.5);
        }
        else if (i == 5) {
          sphere(4.5);
        } if (i == 9) {
          sphere(4);
        }else {
          sphere(3.3);
        }
        popMatrix();
        x0 -= 1;

    }
    float x1 = x0;
    float y1 = y0;
    for(int i = 0; i < 14; i++){
        pushMatrix();
        translate(x1, y1, 0);
        sphere(r);
        popMatrix();
        
        //right arm part
        pushMatrix();
        translate(x1*-1, y1, 0);
        sphere(r);
        popMatrix();
        r-=.05;
        x1 -= .10;
        y1 -=.7;
    }
    //hands
    float x2 = x1;
    float y2 = y1;
    pushMatrix();
    translate(x2, y2, 0);
    scale(1.1, 1.1, 1);
    sphere(3);
    popMatrix();
    
    pushMatrix();
    translate(x2*-1, y2, 0);
    scale(1.1, 1.1, 1);
    sphere(3);
    popMatrix();
}
void arms(){
  fill(132, 117, 26);
    //top half of arms (should be a cylinder)
    float r = 2.8;
    float x0 = -7;
    float y0 = -8;
    for(int i = 0; i < 10; i++){
        pushMatrix();
        translate(x0, y0, 0);
        sphere(3);
        popMatrix();
        pushMatrix();
        translate(x0*-1, y0, 0);
        sphere(3);
        popMatrix();
        x0 -= .5;
        y0+=.5;

    }
    float x1 = x0;
    float y1 = y0;
    for(int i = 0; i < 14; i++){
        pushMatrix();
        translate(x1, y1, 0);
        sphere(r);
        popMatrix();
        
        //right arm part
        pushMatrix();
        translate(x1*-1, y1, 0);
        sphere(r);
        popMatrix();
        r-=.05;
        x1 -= .10;
        y1 +=.5;
    }
    //hands
    float x2 = x1;
    float y2 = y1;
    pushMatrix();
    translate(x2, y2, 0);
    scale(1.1, 1.1, 1);
    sphere(2.5);
    popMatrix();
    
    pushMatrix();
    translate(x2*-1, y2, 0);
    scale(1.1, 1.1, 1);
    sphere(2.5);
    popMatrix();
    
    
    
}

// Draw a cylinder of a given radius, height and number of sides.
// The base is on the y=0 plane, and it extends vertically in the y direction.
void cylinder (float radius, float height, int sides) {
  int i,ii;
  float []c = new float[sides];
  float []s = new float[sides];

  for (i = 0; i < sides; i++) {
    float theta = TWO_PI * i / (float) sides;
    c[i] = cos(theta);
    s[i] = sin(theta);
  }
  
  // bottom end cap
  
  normal (0.0, -1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (0.0, 0.0, 0.0);
    endShape();
  }
  
  // top end cap

  normal (0.0, 1.0, 0.0);
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape(TRIANGLES);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    vertex (0.0, height, 0.0);
    endShape();
  }
  
  // main body of cylinder
  for (i = 0; i < sides; i++) {
    ii = (i+1) % sides;
    beginShape();
    normal (c[i], 0.0, s[i]);
    vertex (c[i] * radius, 0.0, s[i] * radius);
    vertex (c[i] * radius, height, s[i] * radius);
    normal (c[ii], 0.0, s[ii]);
    vertex (c[ii] * radius, height, s[ii] * radius);
    vertex (c[ii] * radius, 0.0, s[ii] * radius);
    endShape(CLOSE);
  }
}
