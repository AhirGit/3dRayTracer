class Ray{
  PVector origin, direction;
  
  Ray(PVector origin, PVector direction){
    this.origin = origin.copy();
    this.direction = direction.copy().normalize();
  }
  
  PVector intersectionPoint(float t){
    return origin.copy().add(direction.mult(t));
  }
}
