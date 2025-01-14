class Sphere{
  
  //position of the sphere center in the 3d space
  PVector center;
  float radius;
  float[][] sphereColour; //colour of the sphere
  String sphereName;
  
  boolean reflective; //make this object a mirror
  
  Sphere(PVector center, float radius, String sphereName){
    this.center = center;
    this.radius = radius;
    this.sphereName = sphereName;
    this.reflective = false;
    
    this.sphereColour = new float[3][3];
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        this.sphereColour[i][j] = 0.7f; //default colour
      }
    }
  }
  
  void isReflective(boolean value){
    reflective = value;
  }
  
  //get the scalar value (t) of the direction vector at which the vector intersects the sphere
  //deriving (R(t) - C)^2 = r^2  to find t
  //derives to t = (-b +- sqrt(b^2 - 4ac))/2a;
  float getIntersectionScalar(Ray ray){
    
    //println(direction);
    PVector F = ray.origin.copy().sub(center);
    
    // Coefficients of the quadratic equation
    float a = 1;  // direction is normalized, so direction.dot(direction) = 1
    float b = 2.0 * ray.direction.dot(F);  // 2 * (direction dot F)
    float c = F.dot(F) - (radius * radius);
    
    // Discriminant
    float discriminant = (b * b) - (4 * a * c);
    
    // Check if there are real solutions
    if (discriminant < 0) {
      return -1;  // No intersection
    }
    
    // Compute the two solutions for t
    float t1 = (-b - sqrt(discriminant)) / (2 * a);
    float t2 = (-b + sqrt(discriminant)) / (2 * a);
    
    // Determine the closest valid intersection
    if (t1 > 0 && t2 > 0) {
      return min(t1, t2);  // Both are positive, return the closest one
    }
    
    return -1;  // Both t1 and t2 are negative, the sphere is behind the camera
  }
  
  //get the surface normal vector from a specific point on the sphere
  PVector getNormalAtPoint(PVector pointOnSurface){
    
    //n = (x − Cx , y − Cy , z − Cz )
    return pointOnSurface.copy().sub(center).normalize();
  }
  
  void setColour(float[][] colour){
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        this.sphereColour[i][j] = colour[i][j];
      }
    } 
  }
  
  //setters
  void setCenterX(float x){
    center.x = x;
  }
  void setCenterY(float y){
    center.y = y;
  }
  void setCenterZ(float z){
    center.z = z;
  }
  
  //getters
  float[][] getColour(){
    float[][] colour = new float[3][3];
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        colour[i][j] = this.sphereColour[i][j];
      }
    }
    return colour; 
  }
  float getCenterX(){
    return center.x;
  }
  float getCenterY(){
    return center.y;
  }
  float getCenterZ(){
    return center.z;
  }
  String getObjectName(){
    return sphereName;
  }
}
