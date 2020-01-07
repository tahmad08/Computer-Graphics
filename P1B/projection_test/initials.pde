/******************************************************************************
Draw your initials here in perspective.
******************************************************************************/
//Tahirah Ahmad T.A.

void persp_initials()
{
    gtInitialize();
    gtPerspective (35.0, 0.0, 0.0);
  
    gtPushMatrix();
    gtTranslate (0.0, 0.0, -12.0);
    gtRotateZ(35);
    gtInit();
    gtPopMatrix();
}
void gtInit(){
    gtBeginShape();
    
    //  -- Upper part of "T"
    gtVertex(-2.0, 2.0, 2.0);
    gtVertex(0.0, 2.0, 0.0);
    
    // | part of the "T"
    gtVertex(-1.0, 2.0, 1.0);
    gtVertex(-1.0, 0.0, 0.0);
    
    // The / part of A
    gtVertex(-1.0, 1.0, -8.0);
    gtVertex(-1.0, -1.5, 0.0);   

    //The \ part of A
    gtVertex(-1.0, 1.0, -8.0); 
    gtVertex(0.0, -2.5, -5.0);
    
    //The - part of A
    gtVertex(-1.5, -1.3, -8.0);
    gtVertex(-0.2, -1.3, -5.0); 
    
    gtEndShape();



}
