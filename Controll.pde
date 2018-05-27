class Controll {
  private int w;  // width
  private int h;  // height
  private int x;  // x position
  private int y;  // y position
  private int ow;  // outline width
  private int type;  // 0 - label, 1 - button, 2 - big label

  private color oC = 0;  // outline color
  private color bC = 255;  // body color
  private color tC = 0;  // text color
  private color hOC = 0;  // hovered outline color
  private color hBC = 220;  // hovered body color
  private color hTC = 0;  // hovered text color
  private color aOC = 0;  // active outline color
  private color aBC = 0;  // active body color
  private color aTC = 255;  // active text color

  private color dOC;  // draw outline color for current state
  private color dBC;  // draw body color for current state
  private color dTC;  // draw text color for current state

  private String t; // controll text
  private float tS = 50; // text size

  public Controll setWidth(int width) {
    this.w = width;
    return this;
  }

  public Controll setHeigth(int heigth) {
    this.h = heigth;
    return this;
  }

  public Controll setX(int posX) {
    this.x = posX;
    return this;
  }

  public Controll setY(int posY) {
    this.y = posY;
    return this;
  }

  public Controll setOutlineWidth(int outlineWidth) {
    this.ow = outlineWidth;
    return this;
  }

  // not in use hovered block
  public Controll setHoveredOutlineColor(color hoveredOutlineColor) {
    this.hOC = hoveredOutlineColor;
    return this;
  }

  public Controll setHoveredBodyColor(color hoveredBodyColor) {
    this.hBC = hoveredBodyColor;
    return this;
  }

  public Controll setHoveredTextColor(color hoveredTextColor) {
    this.hTC = hoveredTextColor;
    return this;
  }
  //  ---------------------

  // not in use normal state block
  public Controll setOutlineColor(color outlineColor) {
    this.oC = outlineColor;
    return this;
  }

  public Controll setBodyColor(color bodyColor) {
    this.bC = bodyColor;
    return this;
  }
  //  ---------------------

  public Controll setTextColor(color textColor) {
    this.tC = textColor;
    return this;
  }

  // not in use active block
  public Controll setActiveOutlineColor(color activeOutlineColor) {
    this.aOC = activeOutlineColor;
    return this;
  }

  public Controll setActiveBodyColor(color activeBodyColor) {
    this.aBC = activeBodyColor;
    return this;
  }

  public Controll setActiveTextColor(color activeTextColor) {
    this.aTC = activeTextColor;
    return this;
  }
  //  ---------------------

  public Controll setText(String text) {
    this.t = text;
    return this;
  }

  public Controll setTextSize(float textSize) {
    this.tS = textSize;
    return this;
  }

  Controll(int type) {
    this.type = type;
  }

  public void show(boolean click) {
    if (this.type == 0) {  // label
      pushStyle();
      noStroke();
      fill(oC);  // outline color
      rect(x, y+h-ow, w, ow);
      fill(bC);  // body color
      rect(x, y, w, h-ow);  // x + outline width...

      textAlign(CENTER, CENTER);
      textSize(tS);
      fill(tC);  // text color
      text(t, x+w/2, y+(h+ow)/2);
      popStyle();
    } else if (this.type == 1) {  // button
      // not hovered
      dOC = oC;
      dBC = bC;
      dTC = tC;
      if (isHovered()) {  // hovered
        dOC = hOC;
        dBC = hBC;
        dTC = hTC;
      }
      if (isClicked(click)) {  // clicked
        dOC = aOC;
        dBC = aBC;
        dTC = aTC;
      }
      pushStyle();
      noStroke();
      fill(dOC);  // outline color
      rect(x, y, w, h);
      fill(dBC);  // body color
      rect(x+ow, y+ow, w-ow*2, h-ow*2);  // x + outline width...

      textAlign(CENTER, CENTER);
      textSize(tS);
      fill(dTC);  // text color
      text(t, x+w/2, y+h/2);
      popStyle();
    } else {  // big label
      pushStyle();
      noStroke();
      fill(bC);  // body color
      rect(x, y, w, h);  // x + outline width...

      textAlign(CENTER, CENTER);
      textSize(tS);
      fill(tC);  // text color
      text(t, x+w/2, y+h/2);
      popStyle();
    }
  }

  public boolean isHovered() {
    if ((mouseX >= x && mouseX <= x+w)  &&  (mouseY >= y && mouseY <= y+h)) {
      return true;
    } else {
      return false;
    }
  }

  public boolean isClicked(boolean click) {
    if (isHovered() && click) {
      return true;
    } else {
      return false;
    }
  }
}
