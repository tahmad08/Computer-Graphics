// This is the starter code for the CS 3451 Ray Tracing project.
// Tahirah Ahmad
// The most important part of this code is the interpreter, which will
// help you parse the scene description (.cli) files.
import java.util.ArrayList;
import java.util.HashMap;
import java.lang.Math;

ArrayList<Sphere> arrS;
ArrayList<Light> arrL;
float Cdr0, Cdg0, Cdb0;
float fov;
Scene scene;

//hit variables
Sphere hitSphere;
PVector hitOrig, hitNorm, hitShape;
boolean gotHit;

void setup() {
  size(400, 400);  
  noStroke();
  colorMode(RGB);
  background(0, 0, 0);
}

void reset_scene() {
  arrS = new ArrayList<Sphere>();
  arrL = new ArrayList<Light>();
  Cdr0 = 0;
  Cdg0 = 0;
  Cdb0 = 0;
  fov = 0;
  scene = new Scene();
  //reset your global scene variables here
}

void keyPressed() {
  reset_scene();
  switch(key) {
    case '1':  interpreter("01_one_sphere.cli"); break;
    case '2':  interpreter("02_three_spheres.cli"); break;
    case '3':  interpreter("03_shiny_sphere.cli"); break;
    case '4':  interpreter("04_one_cone.cli"); break;
    case '5':  interpreter("05_more_cones.cli"); break;
    case '6':  interpreter("06_ice_cream.cli"); break;
    case '7':  interpreter("07_colorful_lights.cli"); break;
    case '8':  interpreter("08_reflective_sphere.cli"); break;
    case '9':  interpreter("09_mirror_spheres.cli"); break;
    case '0':  interpreter("10_reflections_in_reflections.cli"); break;
    case 'q':  exit(); break;
  }
}


// this routine helps parse the text in a scene description file
void interpreter(String filename) {
  
  println("Parsing '" + filename + "'");
  String str[] = loadStrings(filename);
  if (str == null) println("Error! Failed to read the file.");
  
  for (int i = 0; i < str.length; i++) {
    
    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    
    if (token.length == 0) continue; // Skip blank line.
    
    if (token[0].equals("fov")) {
      fov = float(token[1]);
      // call routine to save the field of view
    }
    else if (token[0].equals("background")) {
      float r = float(token[1]);
      float g = float(token[2]);
      float b = float(token[3]);
      // call routine to save the background color
      scene.setBG(r,g,b);
    }
    else if (token[0].equals("eye")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      // call routine to save the eye position
      scene.setEye(x, y, z);
    }
    else if (token[0].equals("uvw")) {
      float ux = float(token[1]);
      float uy = float(token[2]);
      float uz = float(token[3]);
      float vx = float(token[4]);
      float vy = float(token[5]);
      float vz = float(token[6]);
      float wx = float(token[7]);
      float wy = float(token[8]);
      float wz = float(token[9]);
      // call routine to save the camera u,v,w
      scene.setCam(ux, uy, uz, vx, vy, vz, wx, wy, wz);
    }
    else if (token[0].equals("light")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float r = float(token[4]);
      float g = float(token[5]);
      float b = float(token[6]);
      // call routine to save light information
      Light l = new Light(x, y, z, r, g, b);
      arrL.add(l);
    }
    else if (token[0].equals("surface")) {
      float Cdr = float(token[1]);
      float Cdg = float(token[2]);
      float Cdb = float(token[3]);
      float Car = float(token[4]);
      float Cag = float(token[5]);
      float Cab = float(token[6]);
      float Csr = float(token[7]);
      float Csg = float(token[8]);
      float Csb = float(token[9]);
      float P = float(token[10]);
      float K = float(token[11]);
      // call routine to save surface materials
      //P3B
      Cdr0 = Cdr;
      Cdg0 = Cdg;
      Cdb0 = Cdb;
    }    
    else if (token[0].equals("sphere")) {
      float r = float(token[1]);
      float x = float(token[2]);
      float y = float(token[3]);
      float z = float(token[4]);
      // call routine to save sphere
      Sphere s = new Sphere(x,y,z,r);
      s.diffuse(Cdr0, Cdg0, Cdb0);
      arrS.add(s);
    }
    else if (token[0].equals("cone")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float h = float(token[4]);
      float k = float(token[5]);
      // call routine to save cone
    }
    else if (token[0].equals("write")) {
      draw_scene();   // this is where you actually perform the ray tracing
      println("Saving image to '" + token[1] + "'");
      save(token[1]); // this saves your ray traced scene to a PNG file
    }
    else if (token[0].equals("#")) {
      // comment symbol
    }
    else {
      println ("cannot parse line: " + str[i]);
    }
  }
}

// This is where you should put your code for creating eye rays and tracing them.
void draw_scene() {
  float d, u, v, radius, a, b, c, det, t;
  PVector rayOrig, rayDir, direction, origin, center;
  Ray currRay;

  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {

      // create and cast an eye ray
      d = 1.0/tan(radians(fov)/2.0);
      u = -1.0 + ((2.0*x)/width);
      v = -1.0 + ((2.0*y)/height);
      rayOrig = scene.eye;
      
      //arraylist has u, v, w vectors of camera
      ArrayList<PVector> cam = scene.getCam();
      //sending the camera and origin to a new ray 
      currRay = new Ray(rayOrig, cam);
      
      //pVector from -dw + uu + vv
      //now filled with dx, dy, dz
      rayDir = currRay.calcRay(d, u, -v);
      float nearest_t;
      boolean found_hit = false;
      Sphere hit_shape;
      for(Sphere s: arrS) {
          direction = rayDir;
          origin = rayOrig;
          center = s.center;
          radius = s.r;
          
          a = (direction.x * direction.x) + (direction.y * direction.y) + (direction.z * direction.z);
          b = 2.0 * PVector.dot(direction, PVector.sub(origin, center));
          c = PVector.dot(PVector.sub(origin, center), PVector.sub(origin, center)) -  pow(radius, 2.0);
          
          //determinant
          det = pow(b, 2.0) - 4.0*a*c;
          
          
          if(det >= 0) {
              float t1 = (-b + sqrt(det))/(2*a);
              float t2 = (-b - sqrt(det))/(2*a);
              
              if (t1 > 0 && t2 > 0) {
                t = min(t1, t2);
              } else if (t1 < 0 && t2 > 0) {
                t = t2;
              } else if (t2 < 0 && t1 > 0) {
                t = t1; 
              } else {
                t = -1;
              }
            
              //HIT, do the calculations
              if(t>=0) {
                  found_hit = true;
                  hitSphere = s;
                  hitShape = new PVector(s.x, s.y, s.z);
                  float xHit = origin.x + (t * direction.x);
                  float yHit = origin.y + (t * direction.y);
                  float zHit = origin.z + (t * direction.z);
                  hitOrig = new PVector(xHit, yHit, zHit);
                  hitNorm = (PVector.sub(hitOrig, hitShape)).normalize();
                  
              } 
          }
      }
      if(found_hit) {
          PVector col = new PVector(0, 0, 0);
          PVector l;
          for (Light light : arrL) {
              l = (PVector.sub(light.origin, hitOrig)).normalize();
              //max(0, hit normal . l)
              float maxo = max(0, (PVector.dot(l, hitNorm)));
              col.x += light.r * maxo;
              col.y += light.g * maxo;
              col.z += light.b * maxo;
          }
          col.x = col.x * hitSphere.Cdr;
          col.y = col.y * hitSphere.Cdg;
          col.z = col.z * hitSphere.Cdb;

          fill(col.x *255, col.y *255, col.z *255);
          rect(x, y, 1, 1);
      }
      else{
          fill(scene.bg.x*255, scene.bg.y*255, scene.bg.z*255);
          rect(x, y, 1, 1);
      }
     
    }
  }
}

void draw() {
  // nothing should be placed here for this project!
}

class Sphere {
    public float x, y, z, r;
    public float Cdr, Cdg, Cdb, Car, Cag, Cab, Csr, Csg, Csb, P, K;
    PVector center;
    Sphere(){}
    Sphere(float x0, float y0, float z0, float radius){
        this.x = x0;
        this.y = y0;
        this.z = z0;
        this.r = radius;
        this.center = new PVector(x0, y0, z0);
    }
    public void surface(float Cdr0, float Cdg0, float Cdb0, float Car0, float Cag0, 
        float Cab0, float Csr0, float Csg0, float Csb0, float P0, float Kref){
        this.Cdr = Cdr0;
        this.Cdg = Cdg0;
        this.Cdb = Cdb0;
        this.Car = Car0;
        this.Cag = Cag0;
        this.Cab = Cab0;
        this.Csr = Csr0;
        this.Csg = Csg0;
        this.Csb = Csb0;
        this.P = P0;
        this.K = Kref;
    }
    public void diffuse(float Cdr0, float Cdg0, float Cdb0) {
        this.Cdr = Cdr0;
        this.Cdg = Cdg0;
        this.Cdb = Cdb0;
    }
}

class Light{
    public float x, y, z, r, g, b;
    public PVector origin, clr;
    Light(float x0, float y0, float z0, float r0, float g0, float b0){
        this.x = x0;
        this.y = y0;
        this.z = z0;
        this.r = r0;
        this.g = g0;
        this.b = b0;
        this.origin = new PVector(x, y, z);
        this.clr = new PVector(r,g,b);
    }
}
class Ray{
    public PVector origin, dir, normal;
    public ArrayList<PVector> cam;
    //nX, nY, nZ = normal x, y, z
    float dx, dy, dz, xHit, yHit, zHit, nX, nY, nZ;
    Ray(PVector orig, ArrayList<PVector> camera) {
        this.origin = orig;
        this.cam = camera;
    }
    Ray(PVector orig, PVector direction) {
        this.origin = orig;
        this.dir = direction;
    }
    public PVector calcRay(float d, float u, float v) {
        PVector uV = cam.get(0);
        PVector vV = cam.get(1);
        PVector wV = cam.get(2);
        dx = (-d*wV.x + u*uV.x +v*vV.x);
        dy = (-d*wV.y + u*uV.y +v*vV.y);
        dz = (-d*wV.z + u*uV.z +v*vV.z);
        this.dir = new PVector(dx, dy, dz);
        return dir;
    }
    public Hit closest(float t, Sphere s){
        xHit = origin.x + t * dx;
        yHit = origin.y + t * dy;
        zHit = origin.z + t * dz;
        nX = xHit - s.x;
        nY = yHit - s.y;
        nZ = zHit - s.z;
        
        normal = new PVector(nX, nY, nZ);
        normal = normal.normalize();
        Hit close = new Hit(t, xHit, yHit, zHit, s, normal);
        return close;
    }
  
}

class Hit{
    float x, y, z, t;
    PVector normal, inter; //surface normal
    Sphere shape;
    Hit(){}
    Hit(float t, float xHit, float yHit, float zHit, Sphere s, PVector norm){
        this.x = xHit;
        this.y = yHit;
        this.z = zHit;
        this.t = t;
        this.inter = new PVector(x, y, z);
        this.shape = s;
        this.normal = norm;
    }
}
class Scene{
    PVector eye, camU, camV, camW, origin, bg;
    ArrayList<PVector> cam;
    Scene(){}
    public void setCam(float ux0, float uy0, float uz0, float vx0, float vy0,
        float vz0, float wx0, float wy0, float wz0){
          this.camU = new PVector(ux0, uy0, uz0);
          this.camV = new PVector(vx0, vy0, vz0);
          this.camW = new PVector(wx0, wy0, wz0);
          cam = new ArrayList<PVector>();
          cam.add(camU); 
          cam.add(camV);
          cam.add(camW);
    }
    public PVector setEye(float x, float y, float z) {
        this.eye = new PVector(x, y, z);
        return eye;
    }
    public void setBG(float r, float g, float b) {
        this.bg = new PVector(r, g, b);
    } 
    public ArrayList<PVector> getCam() {
        return cam;
    }
}
