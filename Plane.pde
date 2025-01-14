class Plane {
  PVector center;      // A point on the plane (its center)
  PVector normal;      // The normal vector of the plane
  float[][] planeColour; // The color of the plane
  String planeName;
  
  boolean reflective; //make this object a mirror

  Plane(PVector planeCenter, PVector normal, String planeName) {
    this.center = planeCenter;
    this.normal = normal.normalize(); // Ensure the normal is normalized
    this.planeName = planeName;
    this.reflective = false;
    
    this.planeColour = new float[3][3];
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        this.planeColour[i][j] = 0.7f; //default colour
      }
    }
    
  }
  
  void isReflective(boolean value){
    reflective = value;
  }
  
  //get the scalar value (t) of the direction vector at which the vector intersects the sphere
  //deriving N.(P = Po) = 0  to find t where P is any point on plane and Po is the center
  //derives to t = ( (Po - E).N )/(D.N)
  
  float getIntersectionScalar(Ray ray) {
    
    float denominator = PVector.dot(ray.direction, normal); //D.N
    if (abs(denominator) < 0.0001) {
      // Ray is parallel to the plane (no intersection)
      return -1;
    }
    
    PVector diff = PVector.sub(center, ray.origin);
    float t = diff.copy().dot(normal) / denominator;
    
    if (t >= 0) {
      // Only return positive t values (in front of the ray origin)
      return t;
    }

    // No valid intersection
    return -1;
  }
  PVector getNormalAtPoint(PVector pointOnSurface) {
    return normal.copy().normalize();
  }

  float[][] getColour(){
    float[][] colour = new float[3][3];
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        colour[i][j] = this.planeColour[i][j];
      }
    }
    return colour; 
  }
  
  String getObjectName(){
    return planeName;
  }
  
  void setColour(float[][] colour){
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        this.planeColour[i][j] = colour[i][j]; //default colour
      }
    } 
  }
}
