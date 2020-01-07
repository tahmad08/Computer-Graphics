// Sample code for starting the subdivision project
import java.util.ArrayList;
import java.util.Arrays;

ArrayList<Integer> cornerT;
ArrayList<PVector> geoT;
Mesh m;

int seed;
boolean randc = false;
boolean vnorms = false;
float time = 0;  // keep track of passing of time
boolean rotate_flag = true;       // automatic rotation of model?

// initialize stuff
void setup() {
    size(700, 700, OPENGL);  // must use OPENGL here !!!
    noStroke();     // do not draw the edges of polygons
    cornerT = new ArrayList();
    geoT = new ArrayList();
}

// Draw the scene
void draw() {
    
    resetMatrix();  // set the transformation matrix to the identity (important!)
  
    background(0);  // clear the screen to black
    
    // set up for perspective projection
    perspective (PI * 0.333, 1.0, 0.01, 1000.0);
    
    // place the camera in the scene (just like gluLookAt())
    camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
      
    // create an ambient light source
    ambientLight(102, 102, 102);
    
    // create two directional light sources
    lightSpecular(204, 204, 204);
    directionalLight(102, 102, 102, -0.7, -0.7, -1);
    directionalLight(152, 152, 152, 0, 0, -1);
    
    pushMatrix();
  
    fill(200, 200, 200);
    ambient (200, 200, 200);
    specular(0, 0, 0);
    shininess(1.0);
    
    rotate (time, 0.0, 1.0, 0.0);
    
    // THIS IS WHERE YOU SHOULD DRAW THE MESH
    
    randomSeed(seed);
    for (int j = 0; j < cornerT.size()/3; j++) {
        PVector norm;
        int c1 = cornerT.get(3*j);
        int c2 = cornerT.get(3*j + 1);
        int c3 = cornerT.get(3*j + 2);
        PVector v1 = geoT.get(c1);
        PVector v2 = geoT.get(c2);
        PVector v3 = geoT.get(c3);
        beginShape();
        
        if(randc){
            fill(random(0,255),random(0,255),random(0,255));
        }
        if (vnorms) {
            //fill(200,200,200);
            norm = m.getvertnorm(c1);
            normal(norm.x, norm.y, norm.z);
        }
        vertex(v1.x, v1.y, v1.z);
        if (vnorms) {
            //fill(200,200,200);
            norm = m.getvertnorm(c2);
            normal(norm.x, norm.y, norm.z);
        }
        vertex(v2.x, v2.y, v2.z);
        if (vnorms) {
            //fill(200,200,200);
            norm = m.getvertnorm(c3);
            normal(norm.x, norm.y, norm.z);
        }
        vertex(v3.x, v3.y, v3.z);
        endShape();
    }
        
    popMatrix();
   
    // maybe step forward in time (for object rotation)
    if (rotate_flag )
        time += 0.02;
}

// handle keyboard input
void keyPressed() {
    if (key == '1') {
        read_mesh ("tetra.ply");
    }
    else if (key == '2') {
        read_mesh ("octa.ply");
    }
    else if (key == '3') {
        read_mesh ("icos.ply");
    }
    else if (key == '4') {
        read_mesh ("star.ply");
    }
    else if (key == '5') {
        read_mesh ("torus.ply");
    }
    else if (key == 'n') {
      vnorms = !vnorms;
      // toggle per-vertex normals
    }
    else if (key == 'r') {
      randc = !randc;
      // random colors
    }
    else if (key == 's') {
      // subdivide mesh
      //m = subdivide(m);
    }
    else if (key == ' ') {
        rotate_flag = !rotate_flag;          // rotate the model?
    }
    else if (key == 'q' || key == 'Q') {
        exit();                               // quit the program
    }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename)

  {
        cornerT = new ArrayList();
    geoT = new ArrayList();
    int i;
    String[] words;
    
    String lines[] = loadStrings(filename);
    
    words = split (lines[0], " ");
    int num_vertices = int(words[1]);
    println ("number of vertices = " + num_vertices);
    
    words = split (lines[1], " ");
    int num_faces = int(words[1]);
    println ("number of faces = " + num_faces);
    
    // read in the vertices
    for (i = 0; i < num_vertices; i++) {
        words = split (lines[i+2], " ");
        float x = float(words[0]);
        float y = float(words[1]);
        float z = float(words[2]);
        println ("vertex = " + x + " " + y + " " + z);
        
        //add to geometry table
        geoT.add(new PVector(x, y, z));
        
    }
    
    // read in the faces
      for (i = 0; i < num_faces; i++) {
        
        int j = i + num_vertices + 2;
        words = split (lines[j], " ");
        
        int nverts = int(words[0]);
        if (nverts != 3) {
            println ("error: this face is not a triangle.");
            exit();
        }
        
        int index1 = int(words[1]);
        int index2 = int(words[2]);
        int index3 = int(words[3]);
        println ("face = " + index1 + " " + index2 + " " + index3);
        cornerT.add(index1);
        cornerT.add(index2);
        cornerT.add(index3);
    }
    m = new Mesh();
    m.set(cornerT, geoT);
    int[] opp = m.getOppTable();
}

Mesh subdivide(Mesh oldmesh){
    //you have 3 for-loops: even vertices, odd vertices, corner table
    ArrayList<Integer> visited = new ArrayList();
    Mesh newmesh = new Mesh();

    for(PVector p:newmesh.gt){
        p = new PVector(-1.0, -1.0, -1.0);
    }
    
    //even vertices loop:
    for(int i = 0; i < oldmesh.ct.size(); i++){
        int oldV = oldmesh.ct.get(i);
        //if visited tracker hasn't already visited this vertex:
        if(!visited.contains(oldV)){
            ArrayList<Integer> neighbor = new ArrayList();
            neighbor.add(oldmesh.ct.get(oldmesh.prev(i)));
            int corner = oldmesh.getAdj(i);
            while(corner != i){
                neighbor.add(corner);
                corner = oldmesh.getAdj(corner);
            }
            float beta = 3.0/16.0;
            if(neighbor.size() > 3){
                beta = 3.0/(8.0*neighbor.size());
            }
            PVector newV = PVector.mult(oldmesh.gt.get(oldV), 1- neighbor.size()*beta);
            //for(int v : neighbor){
            //    newV = PVector.add(newV, PVector.mult(newmesh.gt.get(v), beta));
                
            //}
            newmesh.gt.set(oldV, newV);
            visited.add(oldV);
        
        }
    }
    int[] edget = new int[oldmesh.ct.size()];
    for(int i = 0; i < edget.length; i++){
        edget[i] = -1;
    }
    
    for(int i = 0; i < oldmesh.ct.size();i++){
        if(edget[oldmesh.getO(i)] != -1){
            edget[i] = edget[oldmesh.getO(i)];
        }
        else{
            PVector vert1 = oldmesh.gt.get(i);
            PVector vert2 = oldmesh.gt.get(oldmesh.getO(i));
            PVector vert3 = oldmesh.gt.get(oldmesh.next(i));
            PVector vert4 = oldmesh.gt.get(oldmesh.prev(i));
            
            PVector newV = PVector.mult(PVector.add(vert1, vert2), (1.0/8.0));
            newV = PVector.add(newV, PVector.mult(PVector.add(vert3, vert4), (3.0/8.0)));
            newmesh.addG(newV);
            edget[i] = newmesh.gt.size() - 1;
        
        }
    }
    
    //new corner table
    for(int c = 0; c < oldmesh.ct.size(); c+=3){
        int vert1 = oldmesh.ct.get(c);
        int vert2 = edget[oldmesh.next(c)];
        int vert3 = edget[oldmesh.prev(c)];
        newmesh.addcorners(vert1, vert2, vert3);
        
        int vert21 = oldmesh.ct.get(oldmesh.next(c));
        int vert22 = edget[c];
        int vert23 = edget[c];
        newmesh.addcorners(vert21, vert22, vert23);
        
        int vert31 = oldmesh.ct.get(oldmesh.prev(c));
        int vert32 = edget[oldmesh.next(c)];
        int vert33 = edget[c];
        newmesh.addcorners(vert31, vert32, vert33);
        
        int vert41 = edget[c];;
        int vert42 = edget[oldmesh.next(c)];
        int vert43 = edget[oldmesh.prev(c)];
        newmesh.addcorners(vert41, vert42, vert43);
    }
    
    newmesh.assemble();
    return newmesh;

}
