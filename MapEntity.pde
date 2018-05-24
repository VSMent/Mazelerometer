class MapEntity {

  // A boundary is a simple rectangle with x,y,width,and height
  float w;
  float h;

  color col;

  boolean delete = false;
  
  // But we also have to make a body for box2d to know about it
  Body body;

  MapEntity(float x,float y, float w_, float h_) {
    w = w_;
    h = h_;

    makeBody(x,y,w,h);
    body.setUserData(this);
    col = color(175);
  }
  
  void killBody() {
    box2d.destroyBody(body);
  }

  void delete() {
    delete = true;
  }

  // Change color when hit
  void change() {
    col = color(255, 0, 0);
  }
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height || delete) {
      killBody();
      return true;
    }
    return false;
  }

  
  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    rect(0, 0, w, h);
    popStyle();
    popMatrix();
  }
  
  void makeBody(float x, float y, float w, float h){
    // Create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    bd.type = BodyType.STATIC;
    body = box2d.createBody(bd);
    
    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    sd.setAsBox(box2dW, box2dH);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

    //body.setAngularVelocity(random(-10, 10));
    
  }

  MapEntity setColor(color c){
    col = c;
    return this;
  }
}
