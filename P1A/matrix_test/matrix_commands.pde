// Matrix Stack Library

// You should modify the routines below to complete the assignment.
// Feel free to define any classes, global variables, and helper routines that you need.

//Tahirah Ahmad
import java.lang.Math;
import java.util.LinkedList;

LinkedList<Float[][]> mystack;

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
    mystack.add(translated);
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
    mystack.add(scaled);
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
    mystack.add(rotated);

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
    mystack.add(rotated);
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
    mystack.add(rotated);
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

    } else {
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
