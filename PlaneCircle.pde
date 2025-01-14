class PlaneCircle {
  
  // center of the circle in 3D space
  PVector center;
  PVector normal; // normal vector defining the plane of the circle
  float radius;
  float[][] circleColour; // colour of the circle
  String circleName;
  
  boolean reflective; // make this object a mirror
  
  PlaneCircle(PVector center, PVector normal, float radius, String circleName) {
    this.center = center;
    this.normal = normal.normalize(); // Ensure the normal is a unit vector
    this.radius = radius;
    this.circleName = circleName;
    this.reflective = false;
    
    this.circleColour = new float[3][3];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        this.circleColour[i][j] = 0.7f; // default colour
      }
    }
  }
  
  void isReflective(boolean value) {
    reflective = value;
  }
  
  // Get the scalar value (t) of the direction vector at which the ray intersects the plane of the circle
  //derivation is same as a regular plane except we check for circle bounds
  float getIntersectionScalar(Ray ray) {
    float denominator = normal.dot(ray.direction);
    if (abs(denominator) < 0.0001) {
      // Ray is parallel to the plane (no intersection)
      return -1;
    }
    
    PVector diff = PVector.sub(center, ray.origin);
    float t = diff.copy().dot(normal) / denominator;
    
    if (t >= 0) { // Only consider intersections in front of the ray origin
      // Check if the intersection point is within the circle's radius
      PVector intersectionPoint = ray.origin.copy().add(ray.direction.copy().mult(t));
      float distanceToCenter = intersectionPoint.dist(center);
      if (distanceToCenter <= radius) {
        return t; // Valid intersection within the circle
      }
    }
    
    // No valid intersection
    return -1;
  }
  
  // Get the surface normal of the circle (it's the same everywhere on a plane)
  PVector getNormalAtPoint(PVector pointOnSurface) {
    return normal.copy().normalize(); // Normal is constant for a plane
  }
  
  void setColour(float[][] colour) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        this.circleColour[i][j] = colour[i][j];
      }
    }
  }
  
  // Setters
  void setCenterX(float x) {
    center.x = x;
  }
  void setCenterY(float y) {
    center.y = y;
  }
  void setCenterZ(float z) {
    center.z = z;
  }
  
  void setNormal(PVector normal) {
    this.normal = normal.normalize();
  }
  
  // Getters
  float[][] getColour() {
    float[][] colour = new float[3][3];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        colour[i][j] = this.circleColour[i][j];
      }
    }
    return colour;
  }
  
  float getCenterX() {
    return center.x;
  }
  
  float getCenterY() {
    return center.y;
  }
  
  float getCenterZ() {
    return center.z;
  }
  
  PVector getNormal() {
    return normal;
  }
  
  String getObjectName() {
    return circleName;
  }
}
