/*
Tahirah Ahmad
My instanced objects are the boxes and the bear
The honeypot rotates, and the bear is translated forward
I use a spotlight towards the end of the scene

For anyone currently in the class, I guessed on a lot of the numbers
it was mostly guess and check for them, no clever calculations so don't waste time tryna figure out how
I got those decimals. 
Good luck
*/
import java.lang.Math;
float time = 0;  // keep track of passing of time
float time2, time3,t4,t5,t6, loc, mov;
float rad = 3.0;
float mBack = 85;
float mAround = 0.0;
float mUp = 0;

void setup() {
    size(800, 800, P3D);  // must use 3D here !!!
    noStroke();           // do not draw the edges of polygons
}

// Draw a scene with a cylinder, a sphere and a box
void draw() {  
    //resetMatrix();  // set the transformation matrix to the identity (important!)  
    background(50, 10, 5);  // clear the screen to dark red
    time += 0.01;  
    // set up for perspective projection
    perspective (PI * 0.333, 1.0, 0.01, 1000.0);
    // create an ambient light source
    ambientLight (102, 102, 102);
    // create two directional light sources
    lightSpecular (204, 204, 204);
    //directionalLight (102, 102, 102, -0.7, -0.7, -1);
    directionalLight (152, 152, 152, 0, 0, -1);
    
    //everything above this was there previously. I didn't write that code. 
    //spotlight turns on right before honeypot ascends
    if(time > 4) {
        spotLight(0, 0, 255, 0, -100, 105, 0, 1, 0, PI/12, 4);
    }
    
    //SETUP  
    // place the camera in the scene (just like gluLookAt())
    /*this sets it infront of the bear, while moving the center of the screen 
    to (45,0,0) instead of the default (0,0,0)., and while time<=1, the 
    camera pans backwards along the positive z-axis.
    */
    if(time <= 1.0) {
        camera (0.0, 0.0, mBack, 45.0, 0.0, -1.0, 0.0, 1.0, 0.0);
        mBack += 1;
        pushMatrix();
        drawBoi();
        popMatrix();
        time2 = time;
    }
    /* camera now pans around (rotating around the center) until time = 2.5, 
    where it stops. Note that the earlier change in center to (45,0,0) changed 
    around where the rotateY pans around
    */
    else if (time <= 2.5) {
        time3 = time - time2; //time3 holds the time at the end of this if statement 
        //i now realize that time at the end of this ifstatement is 2.5, per the boolean statement
        //wow. just wow.
        rotateY(time3);
        pushMatrix();
        drawBoi();
        popMatrix();
    } 
    //stops the camera at the position where it was stopped after panning to the side
    //of bear and boxes. Since time3 is not a changeing variable like time
    //the camera remains in positon
    else {
        rotateY(time3);
    }
    //action of the bear
    if(time > 2.28 && time < 3.5) {
        pushMatrix();
        mov = (time*80)%200;
        /* calculated based on time, so dynamic. Moves the bear forward
        until time =3.5, so it stops right in front of the boxes.
        i randomly managed to get the (time*80)%200; equation so idk how to explain it*/
        translate(0, 0, mov);
        drawBoi();
        popMatrix();
        loc = mov;
        //loc holds the value of mov at the end of this if, and is used later to position the bear properly
    } else if (time > 3.49 && time < 3.7) {
        pushMatrix();
        translate(0, 0, loc);//bear pauses where it moved to in last if
        drawBoi();
        popMatrix();
        t4 = time;
    }
    //honeypot entrance
    if (time > 3.69 && time < 6.5) {
        t5 = time - t4;
        //camera move to front of the bear and boxes, and pan upwards slowly
        camera (0.0, mUp, mBack, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
        pushMatrix();
        translate(0, 0, loc);
        drawBoi();
        popMatrix();
        //honey pot set, and rise slowly out of box
        pushMatrix();
        t6 = -(t5 * 5);
        translate(0, t6, 0);
        setPot(5);
        popMatrix();
        mUp -= .08;
    }
    if (time > 6.49 && time < 7) {
        //stop camera in prev position (mUp no longer updating)
        camera (0.0, mUp, mBack, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
        //bear prev position
        pushMatrix();
        translate(0, 0, loc);
        drawBoi();
        popMatrix();
        //pot in prev position. rotation done in setPot or pot
        pushMatrix();
        translate(0, t6, 0);
        setPot(5);
        popMatrix();
    }
    if (time > 7) {
        //purpose of this if is to draw the bear buff, and leave everything standing.
        camera (0.0, mUp, mBack, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
        pushMatrix();
        translate(0, 0, loc);
        drawBuffBoi();
        popMatrix();
        pushMatrix();
        translate(0, t6, 0);
        setPot(5);
        popMatrix();
    }
    //set up the chests.
    pushMatrix();
    chest(-30, 12, 100, 35);
    popMatrix();
    pushMatrix();
    chest(0, 12, 100, 35);  
    popMatrix();
    pushMatrix();
    chest(30, 12,100, 35);
    popMatrix();    

}

void setPot(int r) {
    pushMatrix();
    translate(0, 12, 100);
    //this causes the pot to rotate about itself constantly
    rotateY(time * .9);
    scale(.5);
    pot(r);
    popMatrix();
}

void pot(int r){
    //all these are the honey pot parts
    fill(86, 73, 6);
    pushMatrix();
    translate(0,13,0);
    scale(1, .3, 1);
    sphere(r);
    popMatrix();
    
    pushMatrix();
    translate(0,10,0);
    scale(1, .4, 1);
    sphere(r+2);
    popMatrix();
    
    pushMatrix();
    translate(0,6.5,0);
    scale(1, .5, 1);
    sphere(r+3);
    popMatrix();
    
    pushMatrix();
    translate(0,3.5,0);
    scale(1, .5, 1);
    sphere(r+3);
    popMatrix();
    
    pushMatrix();
    //translate(0,5,0);
    scale(1, .4, 1);
    sphere(r+2);
    popMatrix();
    
    //honey at top
    pushMatrix();
    fill(209, 139, 10);
    translate(0,-1,0);
    scale(1, .4, 1);
    sphere(r+1);
    popMatrix();
    
    //dripping honey parts
    pushMatrix();
    translate(-4.5,-.1,0);
    scale(1.3, 1.2, 1);
    sphere(2);
    popMatrix();
    
    pushMatrix();
    translate(3.6,1,0);
    scale(1.3, 1.2, 1);
    sphere(3);
    popMatrix();
}

void chest(float x, float y, float z, float fill){
    fill(fill);
    pushMatrix();
    translate(x, y, z);
    box(10,10,10);
    popMatrix();
    pushMatrix();
    translate(x, y+7, z);
    box(15,2,15);
    popMatrix();
    pushMatrix();
    translate(x, y+5, z);
    box(13,1,13);
    popMatrix();

}
void drawBuffBoi() {
    buffBelly();
    head();
    buffArms();
    buffLegs();
}
void drawBoi(){
    belly();
    arms();
    legs();
    head();
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
    fill(132, 117, 26);
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
    translate(0,0,4.7);
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
