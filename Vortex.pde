
class Vortex {

  PVector bottomCenter;
  PVector topCenter;
  float radius;
  float axisLength;
  PVector axis;
  float freqR=0.1f;
  float freqMax=0.5;
  float tightness=2;
  PVector center;

  Vortex(PVector bc, PVector tc, float r) {
    this.bottomCenter=bc.copy();
    this.topCenter=tc.copy();
    this.radius=r;

    this.axis=PVector.sub(topCenter, bottomCenter);
    axisLength=axis.mag();
    axis.normalize();

    center=PVector.add(bottomCenter, topCenter).div(2);
  }

  PVector distanceToAxis(PVector p) {
    PVector Xvi=PVector.sub(p, bottomCenter);    
    float li=Xvi.dot(axis);
    PVector ri=PVector.sub(Xvi, PVector.mult(axis, li));
    if (li>axisLength || li<0 || ri.mag()>radius) {
      return new PVector(-1000000, 0);
    } else {
      return ri;
    }
  }

  float angularSpeedAtDistance(float ri) {
    float freqRi=pow(radius/ri, tightness)*freqR;
    freqRi=min(freqMax, freqRi);
    return TWO_PI*freqRi;
  }

  PVector centripetalForce(PVector particleLoc) {
    // F=m*r*sq(w), formula for centripetal force,where m is mass, w is angular velocity
    PVector ri=distanceToAxis(particleLoc);
    if (ri.x==-1000000) {        //out of the cylinder
      return new PVector(0, 0, 0);
    } else {
      float angularVelocity=angularSpeedAtDistance(ri.mag());
      //PVector force=axis.cross(ri).normalize().mult(ri.mag()*sq(angularVelocity)).mult(1);
      PVector force=ri.mult(-ri.mag()*sq(angularVelocity));
      force.mult(0.001);
      //println(force.mag());
      return force;
    }
  }

  void display() {
    pushStyle();
    stroke(255);
    strokeWeight(3);
    line(bottomCenter.x, bottomCenter.y, bottomCenter.z, 
      topCenter.x, topCenter.y, topCenter.z);
    //noStroke();
    //fill(#8EC9F7,50);
    //pushMatrix();
    //translate(center.x,center.y,center.z);
    //sphere(radius);
    //popMatrix();
    popStyle();
  }
}