class MapEntity {
  float w;
  float h;
  color col;
  Vec2 pos;
  Body body;
  int type;

  MapEntity(float x, float y, float w_, float h_, int type_) {
    w = w_;
    h = h_;
    type = type_;

    makeBody(x, y, w, h, type);
    body.setUserData(this);
    col = color(175);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  MapEntity change() {
    col = color(255, 0, 0);
    return this;
  }
  MapEntity changeBack() {
    col = color(150);
    return this;
  }


  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    pos = box2d.getBodyPixelCoord(body);
    //float a = body.getAngle();
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y);
    //rotate(a);
    fill(col);
    strokeWeight(1);
    if (type == 2) {
      stroke(0);
      ellipse(0, 0, w, h);     
    } else {
      //stroke(0);
      noStroke();
      rectMode(CENTER);
      rect(0, 0, w, h);
    }
    popStyle();
    popMatrix();
  }

  void makeBody(float x, float y, float w, float h, int type) {
    // Create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x, y));

    if (type == 2) {
      bd.type = BodyType.DYNAMIC;
      w -=4;
      h -=4;
    } else {
      bd.type = BodyType.STATIC;
    }

    body = box2d.createBody(bd);

    Shape sd;

    if (type == 2) {
      sd = new CircleShape();
      ((CircleShape)sd).m_radius = box2d.scalarPixelsToWorld(w/2);
    } else {
      sd = new PolygonShape();
      float box2dW = box2d.scalarPixelsToWorld(w/2);
      float box2dH = box2d.scalarPixelsToWorld(h/2);
      ((PolygonShape)sd).setAsBox(box2dW, box2dH);
    }


    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 100;
    fd.friction = 0.1;
    fd.restitution = 0.1;

    // Attach fixture to body
    body.createFixture(fd);

    //body.setAngularVelocity(random(-10, 10));
  }

  MapEntity setColor(color c) {
    col = c;
    return this;
  }
}
