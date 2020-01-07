
class Sphere {
      public float x, y, z, r;
      public float Cdr, Cdg, Cdb, Car, Cag, Cab, Csr, Csg, Csb, P, K;
      PVector center;
      SurfaceMat surf;
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
          surf = new SurfaceMat(Cdr, Cdg, Cdb, Car, Cag, Cab, Csr, Csg, Csb, P, Kref);

      }
      public void diffuse(float Cdr0, float Cdg0, float Cdb0) {
          this.Cdr = Cdr0;
          this.Cdg = Cdg0;
          this.Cdb = Cdb0;
      }
  }
  
  class Cone {
      public float x, y, z, h, k, radius;
      public float Cdr, Cdg, Cdb, Car, Cag, Cab, Csr, Csg, Csb, P, Kref;
      SurfaceMat surf;
      Cone(){}
      Cone(float x0, float y0, float z0, float h0, float k0){
          this.x = x0;
          this.y = y0;
          this.z = z0;
          this.h = h0;
          this.k = k0;
          this.radius = h * k;
      }
      public void surface(float Cdr0, float Cdg0, float Cdb0, float Car0, float Cag0, 
          float Cab0, float Csr0, float Csg0, float Csb0, float P0, float Kref0){
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
          this.Kref = Kref0;
          surf = new SurfaceMat(Cdr, Cdg, Cdb, Car, Cag, Cab, Csr, Csg, Csb, P, Kref);
      }
      
  }
  class Color{
      public PVector diffuse, ambient, specular, reflec, fin_col;
      float depth;
      Color(PVector col){
          fin_col = col;
      }
  
  }
  
  class SurfaceMat{
      
      public float Cdr, Cdg, Cdb, Car, Cag, Cab, Csr, Csg, Csb, P, Kref;
      SurfaceMat(){}
      SurfaceMat(float Cdr0, float Cdg0, float Cdb0, float Car0, float Cag0, 
          float Cab0, float Csr0, float Csg0, float Csb0, float P0, float Kref0){
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
              this.Kref = Kref0;
      }
      PVector getDiff(){
          return new PVector(Cdr, Cdg, Cdb);
      }
      PVector getAmb(){
          return new PVector(Car, Cag, Cab);
      }
      PVector getSpec(){
          return new PVector(Csr, Csg, Csb);
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
    
  }
  
  class Hit{
      boolean hitO;
      float x, y, z, t, depth; //point of intersection
      PVector normal, pt; //surface normal
      Sphere sphere;
      Cone cone;
      Object obj;
      SurfaceMat surface;
      Ray eyeRay;
      Hit(){}
      Hit(float t, PVector hit, PVector norm, Sphere s){
          this.x = hit.x;
          this.y = hit.y;
          this.z = hit.z;
          this.t = t;
          this.sphere = s;
          obj = (Sphere) s;
          this.pt = hit;
          this.normal = norm;
          surface = s.surf;
      }
      Hit(float t, PVector hit, PVector norm, Cone c){
          this.x = hit.x;
          this.y = hit.y;
          this.z = hit.z;
          this.t = t;
          this.cone = c;
          obj = (Cone) c;
          this.pt = hit;
          this.normal = norm;
          surface = cone.surf;
      }
      public void foundHit(boolean yn){
          hitO = yn;
      }
      public void setDepth(float d){
          this.depth = d;
      }
      public void setEye(Ray ray){
        this.eyeRay = ray;
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
