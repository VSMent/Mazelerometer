class Player {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  PVector pos;

  Player(float x_, float y_, float r_) {
    pos = new PVector(x_,y_);
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x_, y_, r);
  }
  
  void display() {
    float a = body.getAngle();
    pos = new PVector (box2d.getBodyPixelCoord(body).x,box2d.getBodyPixelCoord(body).y);
    pushMatrix();
    translate(pos.x, pos.y);
    //rotate(a);
    fill(240);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    line(0, 0, r, 0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    body.createFixture(cs,1);
    body.setUserData(this);
    body.setAngularVelocity(random(-10, 10));
    body.setLinearVelocity(new Vec2(5, 5));
  }
  
}
