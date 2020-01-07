class Mesh{
    //corner table
    ArrayList<Integer> ct;
    ArrayList<Integer> edget;
    //opposites arraylist:
    ArrayList<Integer> oList;
    //geometry table:
    ArrayList<PVector> gt;
    //face normals:
    ArrayList<PVector> facet;
    //vertex normals:
    ArrayList<PVector> vertt;
    //actual opposite table tho:
    int[] ot;
    Mesh(){
      ct = new ArrayList();
      gt = new ArrayList();
    }
    //gets the cornertable and geometry table from the file
    public void set(ArrayList<Integer> cornertable, ArrayList<PVector> geometrytable){
        ct = cornertable;
        gt = geometrytable;
        ot = new int[ct.size()];
        buildOpp();
        buildFace();
        //buildVert();
    }
    public void assemble(){
        ot = new int[ct.size()];
        buildOpp();
        buildFace();
    }
   
    //ArrayList<PVector> buildVert(){
    //  vertt = new ArrayList();
    //  int curr;
    //  PVector total;
    //  for(int i = 0; i < ct.size(); i++){
    //        curr = ct.get(i);
    //        total = getfnorm(curr);
    //        curr = swing(i);
    //        while(curr != ct.get(i)){
    //            PVector next = getfnorm(curr);
    //            total.add(next);
    //            curr = swing(curr);
    //        }
    //        total.normalize();
    //  }
    //        return total;
        //vertt = new ArrayList();
        //for(int j = 0; j < gt.size(); j++){
        //    PVector curr = gt.get(j);
        //    ArrayList<PVector> facenormals = new ArrayList();
        //    for(int i = 0; i < ct.size(); i++){
        //        PVector corner = gt.get((int)ct.get(i));
        //        if(curr.equals(corner)){
        //            facenormals.add(facet.get(i/3));
        //        }
        //    }
        //    PVector total = new PVector();
        //    for(int k = 1; k < facenormals.size(); k++){
        //        total.add(facenormals.get(k));
        //    }
        //    vertt.add(total.normalize());
            
        //}
    //    print("vertex table: " + vertt);
    //    return vertt;
    //}
  
    //vertex normal calculator
    PVector getvertnorm(int corner){
        int curr;
        PVector total;
        int i = corner;
        curr = i;
        total = getfnorm(curr);
        curr = swing(i);
        int numFaces = 1;
        while(curr != i){
            PVector next = getfnorm(curr);
            total = PVector.add(total, next);
            //println("next: " + next + ", total: " + total);
            curr = swing(curr);
            numFaces++;
        }
        
        total = PVector.div(total, numFaces);
        //println("v norm " + total);
        return total;
    }
    //face normal table builder
    ArrayList<PVector> buildFace(){
        facet = new ArrayList();
        for(int i = 0; i < ct.size(); i+=3){
            PVector fnorm = getfnorm(ct.get(i));
            facet.add(fnorm);
        }
        //print("face normals: " + facet + "\n");
        return facet;    
    }
    
    //get face normal
    PVector getfnorm(int corner){
        PVector curr = gt.get(ct.get(corner));
        PVector next = gt.get(ct.get(next(corner)));
        PVector prev = gt.get(ct.get(prev(corner)));
        PVector norm = new PVector();
        PVector.cross(PVector.sub(next, curr), PVector.sub(prev, curr), norm);
        norm.normalize();
       // print("curr normal: " + norm + "\t");
        return norm;
    }
    
    //build opposite table
    public int[] buildOpp(){
        for(int a = 0; a < ct.size(); a++){
            for(int b = 0; b < ct.size(); b++){
                int an = ct.get(next(a));
                int ap = ct.get(prev(a));
                int bp = ct.get(prev(b));
                int bn = ct.get(next(b));
                if(an == bp && bn == ap){
                    ot[a] = b;
                    ot[b] = a;
                }
            }
        }
        oList = new ArrayList<Integer>();
        for(int i:ot){
            oList.add(i);
        }
        return ot;
    }
    //get the triangle
    int tri(int corner){
        return corner/3;
    }
    int next(int corner){
        return (3*tri(corner) + (corner + 1)%3);
    }
    int prev(int corner){
        return next(next(corner));
    }
    int swing(int corner){
        return (next(ot[next(corner)]));
    }
    PVector getV(int corner){
        return gt.get(ct.get(corner));
    }
    int getAdj(int corner){
        return prev(getO(prev(corner)));
    }
    //get opposite
    int getO(int corner){
        return ot[corner];
    }
    int[] getOppTable(){
        return ot;
    }
    void addG(PVector newv){
        gt.add(newv);
    }
    void addcorners(int v1, int v2, int v3){
        ct.add(v1);
        ct.add(v2);
        ct.add(v3);
        
    
    }

}
