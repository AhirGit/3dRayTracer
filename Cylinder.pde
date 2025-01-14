class Cylinder{
  
  //position of the sphere center in the 3d space
  PVector center;
  float radius;
  float[][] cylinderColour; //colour of the cylinder
  String cylinderName;
  
  boolean reflective; //make this object a mirror
  
  Cylinder(PVector center, float radius, String cylinderName){
    this.center = center;
    this.radius = radius;
    this.cylinderName = cylinderName;
    this.reflective = false;
    
    this.cylinderColour = new float[3][3];
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        this.cylinderColour[i][j] = 0.7f; //default colour
      }
    }
  }
  
  void isReflective(boolean value){
    reflective = value;
  }
  
  //get the scalar value (t) of the direction vector at which the vector intersects the cylinder
  //deriving (x−cx)^2+(z−cz)^2 =r^2  to find t
  float getIntersectionScalar(Ray ray){
    PVector F = ray.origin.copy().sub(center);
    float a = ray.direction.x * ray.direction.x + ray.direction.z * ray.direction.z;
    float b = 2 * (F.x * ray.direction.x + F.z * ray.direction.z);
    float c = F.x * F.x + F.z * F.z - radius * radius;
    
    // Discriminant
    float discriminant = (b * b) - (4 * a * c);
    
    // Check if there are real solutions
    if (discriminant < 0) {
      
      //println("No intersection");
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
  PVector getNormalAtPoint(PVector pointOnSurface) {
    // Subtract the cylinder center's x and z components, and ignore the y-component
    PVector normal = new PVector(pointOnSurface.x - center.x, 0, pointOnSurface.z - center.z);
    
    // Normalize the normal vector to get the unit vector
    return normal.normalize();
  }
  
  void setColour(float[][] colour){
    for(int i=0; i<3; i++){
      for(int j=0; j<3; j++){
        this.cylinderColour[i][j] = colour[i][j];
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
        colour[i][j] = this.cylinderColour[i][j];
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
    return cylinderName;
  }
  
}
