// Dummy routines for OpenGL commands.
// These are for you to write!
// You should incorporate your matrix stack routines from part A of this project.

//Tahirah Ahmad
import java.lang.Math;
import java.util.LinkedList;

LinkedList<Float[][]> mystack;
LinkedList<Float> infoPer;
LinkedList<Float> infoOrth;
LinkedList<Float[]> vertices;
Float[][] vector;
Float[][] product;
float x0, y0, z0;
float left, right, bottom, top;
boolean type;

void gtInitialize()
{
    mystack = new LinkedList<Float[][]>();
    Float[][] identity = {
        {1.0, 0.0, 0.0, 0.0},
        {0.0, 1.0, 0.0, 0.0},
        {0.0, 0.0, 1.0, 0.0},
        {0.0, 0.0, 0.0, 1.0},
      };
    mystack.add(identity);
}

void gtPushMatrix()
{
    Float[][] pushM = mystack.getLast();
    mystack.add(pushM);
}

void gtPopMatrix()
{
    if(mystack.size() <= 1) {
        print("Stack empty, cannot pop");
    } else {
        mystack.removeLast();
    }
}

void gtTranslate(float x, float y, float z)
{
    Float[][] translateM = {
        {1.0, 0.0, 0.0, x},
        {0.0, 1.0, 0.0, y},
        {0.0, 0.0, 1.0, z},
        {0.0, 0.0, 0.0, 1.0},
    };
    Float[][] translated = multiply(mystack.getLast(),translateM, 0);
    mystack.set(mystack.size()-1,translated);
}

void gtScale(float x, float y, float z)
{
    Float[][] scaleM = {
        {x, 0.0, 0.0, 0.0},
        {0.0, y, 0.0, 0.0},
        {0.0, 0.0, z, 0.0},
        {0.0, 0.0, 0.0, 1.0},
    };
    Float[][] scaled = multiply(mystack.getLast(),scaleM, 0);
    mystack.set(mystack.size()-1,scaled);
}

void gtRotateX(float theta)
{
    float cos = cos(radians(theta));
    float sin = sin(radians(theta));
    
    Float[][] rX = {
        {1.0, 0.0, 0.0, 0.0},
        {0.0, cos, -sin, 0.0},
        {0.0, sin, cos, 0.0},
        {0.0, 0.0, 0.0, 1.0},
    };
    Float[][] rotated = multiply(mystack.getLast(),rX, 0);
    mystack.set(mystack.size()-1,rotated);

}

void gtRotateY(float theta)
{
    float cos = cos(radians(theta));
    float sin = sin(radians(theta));
    Float[][] rY = {
        {cos, 0.0, sin, 0.0},
        {0.0, 1.0, 0.0, 0.0},
        {-sin, 0.0, cos, 0.0},
        {0.0, 0.0, 0.0, 1.0},
    };
    Float[][] rotated = multiply(mystack.getLast(),rY, 0);
    mystack.set(mystack.size()-1,rotated);
}

void gtRotateZ(float theta)
{
    float cos = cos(radians(theta));
    float sin = sin(radians(theta));
    Float[][] rZ = {
        {cos, -sin, 0.0, 0.0},
        {sin, cos, 0.0, 0.0},
        {0.0, 0.0, 1.0, 0.0},
        {0.0, 0.0, 0.0, 1.0},
    };
    Float[][] rotated = multiply(mystack.getLast(),rZ, 0);
    mystack.set(mystack.size()-1,rotated);
}

void print_ctm()
{
    Float[][] curr = mystack.getLast();
    for (int i = 0; i < curr.length; i++) {
        System.out.print("[ ");
        for (int j = 0; j < curr[i].length; j++) {
            System.out.print(curr[i][j] + " ");
        }
        System.out.print("]");
        System.out.println();
    }
    System.out.println();

}

Float[][] multiply(Float[][] m1, Float[][] m2, int type){
    //0 indicates its a matrix*matrix
    if(type == 0) {  
        Float[][] product = {
          {0.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 0.0},
          {0.0, 0.0, 0.0, 0.0},
        };
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 4; k++) {
                    product[i][j] += m1[i][k] * m2[k][j];
                }
            }
        }   
        return product;

    }
    //else its a matrix*vector
    else {
        Float[][] product = {
          {0.0},
          {0.0},
          {0.0},
          {0.0},
        };
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 1; j++) {
                for (int k = 0; k < 4; k++) {
                    product[i][j] += m1[i][k] * m2[k][j];
                }
            }
        }          
        return product;
    }
}

void gtPerspective(float f, float near, float far)
{
    infoPer = new LinkedList<Float>();
    type = true;
    infoPer.add(f); //index 0
    //infoPer.add(near);
    //infoPer.add(far);
    infoPer.add(tan((radians(f))/2.0)); //index 1 = k
}

void gtOrtho(float l, float r, float b, float t, float n, float f)
{
    infoOrth = new LinkedList<Float>();
    type = false;
    infoOrth.add(l);
    infoOrth.add(r);
    infoOrth.add(b);
    infoOrth.add(t);
    //infoOrth.add(n);
    //infoOrth.add(f);
}

void gtBeginShape()
{
    vertices = new LinkedList<Float[]>();
}

void gtVertex(float x, float y, float z)
{
    //perspective
    if (type) {
        setup(x, y, z);
        
        float k = infoPer.get(1);
        
        //x' and y'
        float x2 = (x0/abs(z0)) + k;
        float y2 = (y0/-abs(z0)) + k;
        
        //x'' and y''
        float x3 = x2 * (width / (2.0 * k));
        float y3 = y2 * (height / (2.0 * k));
        Float[] newV = {x3, y3, 0.0};
        vertices.add(newV);
    } 
    //orthographic
    else{
        setup(x, y, z);
        
        left = infoOrth.get(0);
        right = infoOrth.get(1);
        bottom = infoOrth.get(2);
        top = infoOrth.get(3);
        
        float x2 = x0 - left;
        float y2 = y0 - top;
        
        float x3 = x2 * (width/ (right - left));
        float y3 = y2 * (height/ (bottom - top));
        Float[] newV = {x3, y3, 0.0};
        vertices.add(newV);
        
    }
}

void gtEndShape()
{
    for(int i = 0; i < vertices.size(); i+=2) {
      float x0, y0, x1, y1;
      x0 = vertices.get(i)[0];
      y0 = vertices.get(i)[1];
      x1 = vertices.get(i+1)[0];
      y1 = vertices.get(i+1)[1];
      
      line(x0, y0, x1, y1);
    }
}

Float[][] setup(float x, float y, float z) {
    vector = new Float[4][1];
    vector[0][0] = x;
    vector[1][0] = y;
    vector[2][0] = z;
    vector[3][0] = 1.0;
    Float[][] product = multiply(mystack.getLast(), vector, 1);
    x0 = product[0][0];
    y0 = product[1][0];
    z0 = product[2][0];
    
    return product;
}
