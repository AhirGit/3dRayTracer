//Spheres constants
final float SPHERE1_RADIUS = 7.0f;
final float SPHERE2_RADIUS = 1.5f;
final float SPHERE3_RADIUS = 6.0f;
PVector SPHERE1_CENTER = new PVector(0,3, 30);
PVector SPHERE2_CENTER = new PVector(2,5, 20);
PVector SPHERE3_CENTER = new PVector(-12,5, 40);

//Cylinders constants
final float CYLINDER1_RADIUS = 1.5f;
final float CYLINDER2_RADIUS = 0.75f;
PVector CYLINDER1_CENTER = new PVector(-22,0, 42);
PVector CYLINDER2_CENTER = new PVector(10,5, 20);

//PlanE Circle constants
final float CIRCLE1_RADIUS = 5.0f;
PVector CIRCLE1_CENTER = new PVector(10, 10, 40);

//Plane constants
PVector PLANE1_CENTER = new PVector(0,-5,0);
PVector PLANE2_CENTER = new PVector(0,0,60);

//Initialization of shapes
Sphere[] sp = new Sphere[3];
Cylinder[] cy = new Cylinder[2];
PlaneCircle[] pc = new PlaneCircle[1];
Plane[] newP = new Plane[2];
RayTracer rt;

void setup(){
  size(600, 600);
  loadPixels();
  
  rt = new RayTracer(); //initialize the ray tracer
  
  //add spheres to the scene
  sp[0] = new Sphere(SPHERE1_CENTER,  SPHERE1_RADIUS, "BLUE SPHERE");
  sp[1] = new Sphere(SPHERE2_CENTER,  SPHERE2_RADIUS, "RED SPHERE");
  sp[2] = new Sphere(SPHERE3_CENTER,  SPHERE3_RADIUS, "PINK SPHERE");
  sp[0].setColour(BLUE);
  sp[1].setColour(RED);
  sp[2].setColour(PINK);
  rt.addObject(sp[0]);
  rt.addObject(sp[1]);
  rt.addObject(sp[2]);
  
  //add cylinders to the scene
  cy[0] = new Cylinder(CYLINDER1_CENTER, CYLINDER1_RADIUS, "BLUE CYLINDER");
  cy[1] = new Cylinder(CYLINDER2_CENTER, CYLINDER2_RADIUS, "VIOLET CYLINDER");
  cy[0].setColour(BLUE);
  cy[1].setColour(VIOLET);
  rt.addObject(cy[0]);
  rt.addObject(cy[1]);
  
  //add circles to the scene
  pc[0] = new PlaneCircle(CIRCLE1_CENTER, new PVector(0,0,1), CIRCLE1_RADIUS, "ORANGE CIRCLE");
  pc[0].setColour(ORANGE);
  rt.addObject(pc[0]);
  
  //add planes to the  scene
  newP[0] = new Plane(PLANE1_CENTER, new PVector(0,1,0), "Floor");
  newP[1] = new Plane(PLANE2_CENTER, new PVector(0,0,-1), "Back Wall");
  newP[0].setColour(GREEN);
  newP[1].setColour(YELLOW);
  rt.addObject(newP[0]);
  rt.addObject(newP[1]);
  
  //***************toggle effects************************************
  rt.enableShadow(true); //show shadows
  rt.setShadowIntensity(0.01); //set intensity of the shadow, 0.0 is lighest and 1.0 is darkest
  sp[0].isReflective(true); //make this specific object reflective
  
  //uncomment these to make all spheres reflective
  //sp[1].isReflective(true);
  //sp[2].isReflective(true);
  
  //update or render the effects and colours
  rt.renderScene();
  updatePixels();
  displayControlInstructions(); // Display the control instructions on screen
}

void draw(){
  displayControlInstructions();
}

//control shapes with when key is pressed
int i=0;
void keyReleased(){
  
  //switch control to next sphere
  if(key == 'n'){
    i++;
  }
  
  controlSphere(sp[i%3], 0.0f, 0.5f);
  rt.renderScene();
  updatePixels();
}

//select and control sphere with keys
void controlSphere(Sphere sphereInControl, float step, float speed){
  if(key == 'd'){
    step = sphereInControl.getCenterX();
    step+=speed;
    sphereInControl.setCenterX( step );
  }
  else if(key == 'a'){
    step = sphereInControl.getCenterX();
    step-=speed;
    sphereInControl.setCenterX( step );
  }
  else if(key == 'w'){
    step = sphereInControl.getCenterZ();
    step+=speed;
    sphereInControl.setCenterZ( step );
  }
  else if(key == 's'){
    step = sphereInControl.getCenterZ();
    step-=speed;
    sphereInControl.setCenterZ( step );
  }
  else if(key == 'i'){
    step = sphereInControl.getCenterY();
    step+=speed;
    sphereInControl.setCenterY( step );
  }
  else if(key == 'k'){
    step = sphereInControl.getCenterY();
    step-=speed;
    sphereInControl.setCenterY( step );
  }
}

//display control instructions
void displayControlInstructions() {
  fill(255); // White color for text
  textSize(14);

  String instructions = 
    "Sphere Control Instructions:\n" +
    "---------------------------\n" +
    "'n' : Switch between spheres\n" +
    "'w' : Move sphere forward (Z axis)\n" +
    "'s' : Move sphere backward (Z axis)\n" +
    "'a' : Move sphere left (X axis)\n" +
    "'d' : Move sphere right (X axis)\n" +
    "'i' : Move sphere up (Y axis)\n" +
    "'k' : Move sphere down (Y axis)\n";
  
  text(instructions, width*0.1, height*0.7);
}
