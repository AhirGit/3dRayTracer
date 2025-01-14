class RayTracer{ //<>//
  
  ArrayList<Object> sceneObjects; // List to store all objects (Sphere, Cylinder, Plane, Planar Circle)
  
  boolean shadowEnabled; //are shadiws enabled for the scene??
  float shadowIntensity;
  
  RayTracer(){
    sceneObjects = new ArrayList<Object>();  // Initialize the list of objects
    
    shadowEnabled = false; // shadow needs to be enabled
    shadowIntensity = 0.0;
  }
  
  // Method to add any object to the scene
  void addObject(Object obj) {
    sceneObjects.add(obj);
  }
  
  // Method to enable shadows;
  void enableShadow(boolean value){
    shadowEnabled = value;
  }
  
  // Loops through each pixel to cast rays to the scene
  void renderScene(){
    for(int y = 0; y < height; y++){
      for(int x = 0; x < width; x++){
        
        PVector p = pixelCenter3D(x, y); // Position of pixel center in 3D coordinate
        PVector d = directionVector(EYE, p); //ray direction from eye to the scene
        Ray ray = new Ray(EYE, d); //initialize a new ray
        float[] pixelColour = castRay(ray, 2); //cast this ray through the pixel center
        setPixelColour(x, y, pixelColour);
      }
    }
  }
  
  //cast ray to find and return the colour of intersecting object at that point
  //maxReflection is the total number of times this ray will keep on bouncing from...
  //...one reflective object to the next (useful for detecting multiple reflexive objects);
  float[] castRay(Ray ray, int maxReflection){
    if (maxReflection <= 0) {
      return BACKGROUND_COLOUR; // No reflection after max recursive ray casting for reflection
    }
    
    // Variables for finding the closest intersection
    float closestT = Float.MAX_VALUE;
    Object closestObject = null;
    
    // Check all objects to find the closest intersection
    for(int i = 0; i < sceneObjects.size(); i++){
      Object obj = sceneObjects.get(i);
      float t = getIntersectionScalar(obj, ray);
      
      if (t > 0 && t < closestT) {
        closestT = t;
        closestObject = obj;  // Assign the closest object
      }
    }
    
    // Determine the color based on the closest object
    if (closestObject != null) {
      PVector intersectionPoint = ray.intersectionPoint(closestT);
      float[][] closestObjectColour = getColour(closestObject);
      
      //check shadow
      if(shadowEnabled && shadowIntensity <=1 && checkShadow(intersectionPoint)){
        applyShadow(closestObjectColour);
      }
      
      PVector normal = getNormalAtPoint(closestObject, intersectionPoint);
      float[] actualCol = phong(intersectionPoint, normal, EYE, LIGHT, MATERIAL, closestObjectColour, PHONG_SHININESS);

      // Handle reflection if the object is reflective
      if (isReflective(closestObject)) {
        PVector reflectionDir = reflectionVector(ray.direction, normal);
        Ray reflectionRay = new Ray(intersectionPoint, reflectionDir.mult(-1)); //ray is at the opposite direction
        float[] reflectionCol = castRay(reflectionRay, maxReflection);
        return reflectionCol; //if reflective, return the reflection colour
      } 
      else {
        return actualCol; //if not reflective, return the actual object colour
      }
    }
    
    return BACKGROUND_COLOUR; //no intersection at all
  }
  
  // Check if there is another object intersecting at the direction of light
  boolean checkShadow(PVector pointOnSurface) {
    PVector lightDir = directionVector(pointOnSurface, LIGHT);
    Ray shadowRay = new Ray(pointOnSurface, lightDir); // From point on a surface to light
    
    float tThreshold = 0.001; // Prevents artifacts by avoiding self-intersection
    
    // Check all objects to find the closest object before light creating a shadow
    for(int i = 0; i < sceneObjects.size(); i++){
      Object obj = sceneObjects.get(i);
      float t = getIntersectionScalar(obj, shadowRay);
      
      //if the distance of the object infront is less than the distance of the light, draw shadow
      if (t > tThreshold && t < PVector.dist(pointOnSurface, LIGHT)) {
        return true; // Point is in shadow
      }
    }

    return false; // No object between point and light, not in shadow
  }
  
  void setShadowIntensity(float value){
    shadowIntensity = value;
  }
  
  //Apply shadow by darkening the actual object color
  void applyShadow(float[][] actualObjColour){
    for(int i = 0; i < 3; i++){
      actualObjColour[A][i] *= 1 - shadowIntensity; // Ambient
      actualObjColour[D][i] = 0.0; // Diffuse (diffuse turned off in shadows)
      actualObjColour[S][i] = 0.0; // Specular (specular turned off in shadows)
    }
  }
  
  //Methods to handle different object types
  //getters
  float getIntersectionScalar(Object obj, Ray ray) {
    if (obj instanceof Sphere){
      return ((Sphere) obj).getIntersectionScalar(ray);
    } 
    else if (obj instanceof Cylinder) {
      return ((Cylinder) obj).getIntersectionScalar(ray);
    } 
    else if (obj instanceof PlaneCircle) {
      return ((PlaneCircle) obj).getIntersectionScalar(ray);
    } 
    else if (obj instanceof Plane) {
      return ((Plane) obj).getIntersectionScalar(ray);
    }
    return Float.MAX_VALUE;
  }
  
  PVector getNormalAtPoint(Object obj, PVector point) {
    if (obj instanceof Sphere) {
      return ((Sphere) obj).getNormalAtPoint(point);
    } 
    else if (obj instanceof Cylinder) {
      return ((Cylinder) obj).getNormalAtPoint(point);
    } 
    else if (obj instanceof PlaneCircle) {
      return ((PlaneCircle) obj).getNormalAtPoint(point);
    }
    else if (obj instanceof Plane) {
      return ((Plane) obj).getNormalAtPoint(point);
    }
    return new PVector(0, 0, 0); // Default normal
  }
  
  float[][] getColour(Object obj) {
    if (obj instanceof Sphere) {
      return ((Sphere) obj).getColour();
    } 
    else if (obj instanceof Cylinder) {
      return ((Cylinder) obj).getColour();
    } 
    else if (obj instanceof PlaneCircle) {
      return ((PlaneCircle) obj).getColour();
    } 
    else if (obj instanceof Plane) {
      return ((Plane) obj).getColour();
    }
    return new float[][]{{0, 0, 0},{0, 0, 0},{0, 0, 0}}; // Default color
  }
  
  boolean isReflective(Object obj) {
    if (obj instanceof Sphere) {
      return ((Sphere) obj).reflective;
    } 
    else if (obj instanceof Cylinder) {
      return ((Cylinder) obj).reflective;
    } 
    else if (obj instanceof PlaneCircle) {
      return ((PlaneCircle) obj).reflective;
    }
    else if (obj instanceof Plane) {
      return ((Plane) obj).reflective;
    }
    return false;
  }
}
