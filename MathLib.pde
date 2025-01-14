//all mathematical calculations

//calculate the direction vector from a starting point to an ending point
PVector directionVector(PVector from, PVector to){
  
  return to.copy().sub(from);
}

//from Aassignment 1
//calculates the reflection vector of a light source L through a normal
PVector reflectionVector(PVector L, PVector N) {
  // Calculate the dot product L · N
  float projectionComponent = 2*(L.dot(N));
  
  //multiply the projection component with the normal that the light passe through
  PVector projLonN = N.copy().mult(projectionComponent);
  
  // Calculate the reflection vector R
  PVector R = projLonN.sub(L);
  
  return R.normalize();
}
