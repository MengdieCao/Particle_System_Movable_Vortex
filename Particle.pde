
class Particle {

  PVector loc;
  PVector velocity;
  PVector prevVelocity;
  int lifeSpan=400;

  Particle(PVector location, PVector velocity) {
    this.loc=new PVector(location.x, location.y, location.z);
    this.velocity=new PVector(velocity.x, velocity.y, velocity.z);
  }

  void update() {
    lifeSpan--;
    if (prevVelocity != null) {
      velocity = prevVelocity.copy();
    }
    velocity.add(gravity);
    if (vortex != null) {
      velocity.add(vortex.centripetalForce(loc));
    }
    loc.add(velocity);
    checkPlanes(planes);
  }

  void rewind() {
    lifeSpan--;
    prevVelocity = velocity.copy();
    velocity = new PVector(0, 0, 0);
    velocity.add(acceleration);
    loc.add(velocity);
    //checkPlanes(planes);
  }
  /*
  void vortex() {
   lifeSpan--;
   PVector xVI = xV.copy().sub(loc);
   float lI = vNorm.copy().dot(xVI);
   if (lI<=l && lI >= 0) {
   PVector rI = xVI.copy().sub(vNorm.copy().mult(lI));
   float rIMag = rI.mag();
   if (rIMag <= radius) {
   float fI = pow(radius/rIMag, 2)*2;
   float omega = 2*PI*fI;
   velocity.add(new PVector(omega*rIMag, gravity.y, gravity.z));
   //System.out.println(velocity);
   loc.add(velocity);
   }
   }
   }*/

  boolean isDead() {
    if (lifeSpan<0) {
      return true;
    }
    return false;
  }

  void checkPlanes(Plane[]planes) {
    for (int i=0; i<planes.length; i++) {
      if (detectCollision(planes[i])) {
        bounce(planes[i].normal);
      }
    }
  }

  boolean detectCollision(Plane plane) {
    if (plane.hitPlane(this)) {
      //println(velocity);
      PVector hittingPoint=plane.hittingPoint(this);
      PVector projCoord=plane.getProjectionCoord(hittingPoint);
      if (plane.insidePolygon(projCoord)) {

        return true;
      }
    }
    return false;
  }

  //float distanceToPlane(Plane plane){
  //   PVector.sub(loc,plane.vertices[0]).dot(plane.normal);
  //}

  void bounce(PVector normal) {
    loc.sub(velocity);
    PVector vn=PVector.mult(normal, velocity.dot(normal));
    PVector vt=PVector.sub(velocity, vn);

    vn.mult(-cr);
    vt.mult(1-cf);    
    velocity=PVector.add(vn, vt);   
    loc.add(velocity);
  }


  void display() {
    stroke(max(400-lifeSpan, 0), 90, 90);
    strokeWeight(3);
    point(loc.x, loc.y, loc.z);
  }

  //void display() {
  //  pushMatrix();
  //  translate(loc.x, loc.y, loc.z);
  //  image(sprite, 0, 0);
  //  popMatrix();
  //}
}