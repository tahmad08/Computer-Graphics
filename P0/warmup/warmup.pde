//Warmup Exercise
float a;
void setup() {
  size(600, 600);
}
void draw() {
    //black backgrounf
    background(0);
    smooth();
    fill(-1);
    /*translate the center of the screen (which is usually in the upper left corner)
    to the actual center of what pops up
    */
    translate(300, 300);
    
    //this is the moving left to right funcitonality
    rotate(radians(mouseX*(.6)));
    
    //the main circle
    ellipse(0, 0, width, height);
    
    //radius of the main circle
    float r1 = width/2;
    
    /*first call to recursive function
    takes in the position of mousey, the x + y of the center, 
    the radius, current is for color. col is useless
    */
    circle(mouseY, 0, 0, r1, 5, 200);
}


void circle(float mY, float x, float y, float rad, int curr, int col) {
    //every other iteration fills circles with a diff color
    if (curr%2 == 0) {
        fill(200, 88, 88);
        stroke(100, 88, 88);
    } else {
        fill(120, 88, 88);
        stroke(220, 88, 88);
    }
    
    float radi = mY; //radius of the current circle being drawn
    float ratio = rad * (width - mY)/(width*.75);
  
    float x0 = (rad - ratio/2) * cos(radians(270)) + x;
    float y0 = (rad - ratio/2) * sin(radians(270)) + y;
    ellipse(x0, y0, ratio, ratio);
  
    float x1 = (rad - ratio/2) * cos(radians(150)) + x;
    float y1 = (rad - ratio/2) * sin(radians(150)) + y;
    ellipse(x1, y1, ratio, ratio);
  
    float x2 = (rad - ratio/2) * cos(radians(30)) + x;
    float y2 = (rad - ratio/2) * sin(radians(30)) + y;
    ellipse(x2, y2, ratio, ratio);
  
    curr--;
    col -= 500;
    
    if (curr <= 5 && curr > 0) {
        circle(radi, x0, y0, ratio/2, curr, col);
        circle(radi, x1, y1, ratio/2, curr, col);
        circle(radi, x2, y2, ratio/2, curr, col);
    } else {
        return;
    }
}
