// Tahirah Ahmad
// The most important part of this code is the interpreter, which will
// help you parse the scene description (.cli) files.
import java.util.ArrayList;
import java.util.HashMap;
import java.lang.Math;

ArrayList<Sphere> arrS;
ArrayList<Light> arrL;
ArrayList<Cone> arrC;
float Cdr0, Cdg0, Cdb0, Car0, Cab0, Cag0, Csr0, Csg0, Csb0, P0, K0;
float fov;
Scene scene;

//hit variables
Sphere hitSphere;
PVector hitOrig, hitNorm, hitShape;
PVector caphitOrig, caphitNorm, conehitOrig, conehitNorm, caphitShape, conehitShape;
PVector finOrig, finNorm; //final origin and normal between cap and body
Hit finHit; //final hit between cap and body
Cone finCone; //final hit between cap and body
boolean gotHit;
Cone hitCone, hitCap;

void setup() {
  size(400, 400);  
  noStroke();
  colorMode(RGB);
  background(0, 0, 0);
}

void reset_scene() {
  arrS = new ArrayList<Sphere>();
  arrL = new ArrayList<Light>();
  arrC = new ArrayList<Cone>();
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
            Car0 = Car;
            Cag0 = Cag;
            Cab0 = Cab;
            Csr0 = Csr;
            Csg0 = Csg;
            Csb0 = Csb;
            P0 = P;
            K0 = K;
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
            Cone cone = new Cone(x, y, z, h, k);
            cone.surface(Cdr0, Cdg0, Cdb0, Car0, Cag0, Cab0, Csr0, Csg0, Csb0, P0, K0);
            arrC.add(cone);
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
  Hit currHit;
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
      boolean found_hit = false;
      currHit = new Hit();
      currHit.rays(rayOrig, rayDir);
      
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
      //CONE SHIT
      float cap_t, body_t, ba, bb, bc, cap_x, cap_y, cap_z, dist, cdet;
      PVector intersect, cap_cent, base, dir;
      Hit cap_hit, body_hit;
      boolean found_cone = false;
      boolean found_cap = false;
      for(Cone cone : arrC) {
          direction = rayDir;
          dir = direction;//direction is too long to type out
          origin = rayOrig;
          cap_hit = null;
          body_hit = null;
          cap_t = -500;
          body_t = -500;
          
          //CAP intersection
          cap_cent = new PVector(cone.x, cone.y + cone.h, cone.z);
          base = new PVector(cone.x, cone.y, cone.z);
          cap_y = cone.y + cone.h;
          float findt = (cap_y - origin.y)/direction.y;
          //if t is negative, skip this cone?
          if (findt >= 0) {
  
              cap_x = (findt * direction.x) + origin.x;
              cap_z = (findt * direction.z) + origin.z;
              intersect = new PVector(cap_x, cap_y, cap_z);
              
              caphitNorm = new PVector(0,1,0);
              
              //distance between intersection and center of cap
              dist = sqrt(pow((cone.x - cap_x),2.0) + pow((cap_y - cap_y),2.0) + pow((cone.z - cap_z),2.0));
              
              //is the pt of intersection within the radius?
              if(dist <= cone.radius) {
                  cap_t = findt;
                  cap_hit = new Hit(cap_t, intersect, cone);
                  found_cap = true;
                  hitCap = cone;
                  caphitOrig = intersect;
              }
          }
          
          //BODY intersection
          //body_t = (PVector.dot((PVector.sub(cap_cent, origin)), caphitNorm))/(PVector.dot(direction, caphitNorm));
          
          ba = pow(dir.x,2.0) + pow(dir.z, 2.0) - (pow(cone.k, 2.0) * pow(dir.y, 2.0));
          bb = 2.0 * ((dir.x*(origin.x - cone.x)) + (dir.z*(origin.z - cone.z)) - (pow(cone.k, 2.0) * (dir.y*(origin.y + cone.y))));
          bc = pow(origin.x,2.0)+pow(origin.z,2.0)-(pow(cone.k,2.0)*pow(origin.y,2.0)) + pow(cone.x, 2.0) + pow(cone.z, 2.0) 
              - (pow(cone.k, 2.0) * pow(cone.y, 2.0)) - (2.0 * origin.x * cone.x) - (2.0 * origin.z * cone.z) 
              + (2.0 * pow(cone.k, 2.0) * origin.y * cone.y);
          
          //ba = (direction.x * direction.x) + (direction.z * direction.z) - ((direction.y * direction.y)*cone.k);
          //bb = 2.0*((cone.x * direction.x) + (cone.z * direction.z) + (cone.y * direction.y * (cone.k*cone.k)));
          //bc = (cone.x * cone.x) + (cone.z * cone.z) - (pow(cone.y,2.0) * pow(cone.k,2.0));
          
          cdet = pow(bb,2.0) - (4.0 * ba * bc);
          
          if(cdet >= 0){
              float ct1 = (-bb + sqrt(cdet))/(2.0*ba);
              float ct2 = (-bb - sqrt(cdet))/(2.0*ba);
              
              if (ct1 >= 0 && ct2 >= 0) {
                body_t = min(ct1, ct2);
              } else if (ct1 < 0 && ct2 >= 0) {
                body_t = ct2;
              } else if (ct2 < 0 && ct1 >= 0) {
                body_t = ct1; 
              } else {
                body_t = -1;
              }
              
              if(body_t >= 0) {
                  //calculate the P(x, y, z)
                  hitCone = cone;
                  float cxHit = origin.x + (body_t * direction.x);
                  float cyHit = origin.y + (body_t * direction.y);
                  float czHit = origin.z + (body_t * direction.z);
                  //print("got to body_t>=0");
                  
                  //distance from axis:
                  float axisDist = sqrt(pow((cxHit - cone.x),2.0) + pow((czHit - cone.z),2.0));
                  
                  if(axisDist <= cone.radius && (cyHit <= (cone.y + cone.h) && cyHit >= cone.y)) {
                      //print("axisDist <= cone.radius etc");
                  
                      //find the normal
                      PVector t1 = new PVector(cone.x - cxHit, 0, cone.z - czHit);
                      PVector t2 = new PVector(cxHit - cap_cent.x, cyHit - cap_cent.y, czHit - cap_cent.z);
                      //PVector t1 = new PVector(cone.z - czHit, 0, cone.x - cxHit);
                      //PVector t2 = new PVector(cxHit - cap_cent.x, cyHit - cap_cent.y, czHit - cap_cent.z);
                      
                      PVector nNum = t1.cross(t2);
                      PVector n = nNum.normalize();
                      
                      found_cone = true;
                      conehitShape = new PVector(cone.x, cone.y, cone.z);                      
                      conehitOrig = new PVector(cxHit, cyHit, czHit);
                      conehitNorm = n;
                      body_hit = new Hit(body_t, conehitOrig, cone);
                  }
              
              }
          }
          if(body_hit == null && cap_hit == null){
              continue;
          } else if (cap_hit == null && body_hit != null){
              finOrig = conehitOrig;
              finNorm = conehitNorm;
              finHit = body_hit;
              finCone = hitCone;
          } else if (cap_hit != null && body_hit == null){
              finOrig = caphitOrig;
              finNorm = caphitNorm;
              finHit = cap_hit;
              finCone = hitCap;
          } else {
              if(cap_t < body_t){
                  finOrig = caphitOrig;
                  finNorm = caphitNorm;
                  finHit = cap_hit;
                  finCone = hitCap;
              } else if (cap_t > body_t){
                  finOrig = conehitOrig;
                  finNorm = conehitNorm;
                  finHit = body_hit;
                  finCone = hitCone;

              }
          }
      }
      
      //color calculations
      //sphere hit = found_hit
     
      if(found_cap || found_cone) {
          PVector col = new PVector(0, 0, 0);
          PVector l;
          for (Light light : arrL) {
              l = (PVector.sub(light.origin, finOrig)).normalize();
              //max(0, hit normal . l)
              float maxo = max(0, (PVector.dot(l, finNorm)));
              col.x += light.r * maxo;
              col.y += light.g * maxo;
              col.z += light.b * maxo;
          }
          col.x = col.x * finCone.Cdr;
          col.y = col.y * finCone.Cdg;
          col.z = col.z * finCone.Cdb;

          fill(col.x *255, col.y *255, col.z *255);
          rect(x, y, 1, 1);
      } 
      else if(found_hit) {
          float kref = hitSphere.K;
          float phong = hitSphere.p;
          PVector col = new PVector(0, 0, 0);
          PVector amb = new PVector(0, 0, 0);
          PVector diff = new PVector(0, 0, 0);
          PVector spec = new PVector(0, 0, 0);
          PVector l;
          for (Light light : arrL) {
            
          }
          col.x = col.x * hitSphere.Cdr;
          col.y = col.y * hitSphere.Cdg;
          col.z = col.z * hitSphere.Cdb;

          fill(col.x *255, col.y *255, col.z *255);
          rect(x, y, 1, 1);
      }
      else {
          fill(scene.bg.x*255, scene.bg.y*255, scene.bg.z*255);
          rect(x, y, 1, 1);
      }
     
    }
  }
}

void draw() {
  // nothing should be placed here for this project!
}