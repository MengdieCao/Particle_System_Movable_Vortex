
class Plane {
  int qty;//number of vertices
  PVector[]vertices;
  PVector normal;

  PVector[]projectionVertices;
  int axisMostAkinToNormal;

  Plane(float centerX, float centerY, float centerZ, int qty, float radius, float rotz) {
    this.qty=qty;
    vertices=new PVector[qty];
    for (int i=0; i<qty; i++) {
      vertices[i]=new PVector(cos(i*TWO_PI/qty)*radius*cos(rotz)+centerX, 
        cos(i*TWO_PI/qty)*radius*sin(rotz)+centerY, sin(i*TWO_PI/qty)*radius+centerZ);
    }

    normal=PVector.sub(vertices[1], vertices[0]).cross(PVector.sub(vertices[2], vertices[1])).normalize();

    projectionVertices=new PVector[qty];

    float nx=abs(normal.x);    //three elements of the normal
    float ny=abs(normal.y);
    float nz=abs(normal.z);

    if (nx>=ny && nx>=nz) {
      axisMostAkinToNormal=1;    //x axis
    } else if (ny>=nx && ny>=nz) {
      axisMostAkinToNormal=2;    //y axis
    } else {
      axisMostAkinToNormal=3;    //z axis
    }

    for (int i=0; i<qty; i++) {
      projectionVertices[i]=getProjectionCoord(vertices[i]);
    }
  }

  PVector getProjectionCoord(PVector loc) {
    switch(axisMostAkinToNormal) {
    case 1:
      return new PVector(loc.y, loc.z);

    case 2:
      return new PVector(loc.z, loc.x);

    case 3:
      return new PVector(loc.x, loc.y);
    }

    return new PVector(0, 0, 0);
  }

  PVector hittingPoint(Particle one) {
    float tHit=(PVector.sub(vertices[0], PVector.sub(one.loc, one.velocity)).dot(normal))/
      (one.velocity.dot(normal));

    PVector hitPoint=PVector.mult(one.velocity, tHit);
    hitPoint.add(PVector.sub(one.loc, one.velocity));
    return hitPoint;
  }

  boolean insidePolygon(PVector one) {      //note "one" shall be the projection of X
    float lastEdge=determinant(PVector.sub(projectionVertices[0], projectionVertices[qty-1]), 
      PVector.sub(one, projectionVertices[qty-1]));
    //println("start");
    //println("lastEdge "+lastEdge);

    for (int i=0; i<qty-1; i++) {
      float value_i=determinant(PVector.sub(projectionVertices[i+1], projectionVertices[i]), PVector.sub(one, projectionVertices[i]));
      //println(i+" :"+value_i);
      if (lastEdge*value_i<0) {
        return false;
      }
    }
    return true;
  }

  float determinant(PVector edge, PVector towardsX) {
    return edge.x*towardsX.y-edge.y*towardsX.x;
  }


  //boolean hitPlane(Particle one){
  //  if(sameDirectionWithNormal(one.velocity)){
  //    if(PVector.sub(one.loc,vertices[0]).dot(normal)<0){
  //      return false;
  //    }else{
  //      return true;
  //    }
  //  }else{
  //    if(PVector.sub(one.loc,vertices[0]).dot(normal)>0){
  //      return false;
  //    }else{
  //      return true;
  //    }
  //  }
  //}

  boolean hitPlane(Particle one) {
    if (distanceToParticle(one.loc)*distanceToParticle(PVector.sub(one.loc, one.velocity))<0) {
      return true;
    } else {
      return false;
    }
  }

  float distanceToParticle(PVector loc) {
    return PVector.sub(loc, vertices[0]).dot(normal);
  }



  boolean sameDirectionWithNormal(PVector velocity) {
    if (velocity.dot(normal)>0) {
      return true;
    }
    return false;
  }

  void display() {
    pushStyle();
    fill(#8EC9F7);
    noStroke();
    beginShape();
    for (int i=0; i<qty; i++) {
      vertex(vertices[i].x, vertices[i].y, vertices[i].z);
    }
    endShape(CLOSE);
    popStyle();
  }
}