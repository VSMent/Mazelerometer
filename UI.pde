class UI {
  int border = 1; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//

  int leftFullWidth, leftFullHeight, leftInnerWidth, leftInnerHeight, leftOuterX, leftInnerX, leftOuterY, leftInnerY, leftOutline;
  int mapFullWidth, mapFullHeight, mapInnerWidth, mapInnerHeight, mapOuterX, mapInnerX, mapOuterY, mapInnerY, mapOutline;
  int rightFullWidth, rightFullHeight, rightInnerWidth, rightInnerHeight, rightOuterX, rightInnerX, rightOuterY, rightInnerY, rightOutline;

  Controll playButton, helpButton, exitButton, pauseButton, showMapButton, soundButton, infoExitButton, pauseSoundButton, pauseNextButton, pauseExitButton;
  Controll headerLabel, mapCountLabel, timeLabel, bestLabel, pauseMapsLabel, pauseTimeLabel, pauseBestLabel;
  Controll infoBigLabel;


  void drawStartScreen() {
    drawSimpleBorder();

    // controll elements values
    int vMargin = Math.round((height-border*2)/13);  // 4 elements with 5 margins (element weight = 2, margin -- 1) 4*2 + 5*1 = 8 + 5 = 13
    int eHeight = vMargin*2;
    int hMargin = Math.round((width-border*2)/4*1.5);  // 1 element with 2 margins (element weight = 1, margin -- 1.5) 1*1 + 2*1.5 = 1 + 3 = 4
    int eWidth = Math.round(hMargin/1.5);

    headerLabel.setWidth(eWidth*2)
      .setHeigth(eHeight)
      .setX(hMargin-(eWidth/2))
      .setY(vMargin*1+eHeight*0)
      .setText("Mazelerometer")
      .show(click);

    playButton.setWidth(eWidth)
      .setHeigth(eHeight)
      .setX(hMargin)
      .setY(vMargin*2+eHeight*1)
      .show(click);

    helpButton.setWidth(eWidth)
      .setHeigth(eHeight)
      .setX(hMargin)
      .setY(vMargin*3+eHeight*2)
      .show(click);

    exitButton.setWidth(eWidth)
      .setHeigth(eHeight)
      .setX(hMargin)
      .setY(vMargin*4+eHeight*3)
      .show(click);
  }

  void drawInfoScreen(int type) {
    drawSimpleBorder();
    // controll elements values
    int vMargin = Math.round((height-border*2)/13);  // 4 elements with 5 margins (element weight = 2, margin -- 1) 4*2 + 5*1 = 8 + 5 = 13
    int eHeight = vMargin*2;
    int hMargin = Math.round(((width-border*2)/4)*1.5);  // 1 element with 2 margins (element weight = 1, margin -- 1.5) 1*1 + 2*1.5 = 1 + 3 = 4
    int eWidth = Math.round(hMargin/1.5);

    if (type == 1) {  // error
      headerLabel.setText("Error");
      infoBigLabel.setTextSize(80)
        .setTextColor(#cf0808)
        .setText("Error");
      infoExitButton.setText("Exit");
    } else {  // help
      headerLabel.setText("How to play?");
      infoBigLabel.setTextSize(25)
        .setTextColor(0)
        .setText("You need to find exit of the maze and lead ball there.\n"+
        "At at game start you can see maze map, but it will dissapear soon.\n"+
        "You can show map again, but only several times (and for short time)\n"+
        "Your goal and ball are always highlighted on the map.\n"+
        "The sooner you finish the better.");
      infoExitButton.setText("Back");
    }

    headerLabel.setWidth(eWidth*2)
      .setHeigth(eHeight)
      .setX(hMargin-(eWidth/2))
      .setY(vMargin*1+eHeight*0)
      .show(false);

    infoBigLabel.setWidth(eWidth*2)
      .setHeigth(eHeight*2+vMargin)
      .setX(hMargin-(eWidth/2))
      .setY(vMargin*2+eHeight*1)
      .show(false);

    infoExitButton.setWidth(eWidth)
      .setHeigth(eHeight)
      .setX(hMargin)
      .setY(vMargin*4+eHeight*3)
      .show(click);
  }

  void drawPauseScreen(int type) {
    drawSimpleBorder();
    // controll elements values
    int vMargin = Math.round((height-border*2)/13);  // 4 elements with 5 margins (element weight = 2, margin -- 1) 4*2 + 5*1 = 8 + 5 = 13
    int eHeight = vMargin*2;
    int hMargin = Math.round((width-border*2)/13);  // 3 element with 4 margins (element weight = 3 / 5, margin -- 1 / 4) 3*3 + 4*1 = 9 + 4 = 13
    int eWidthPart = hMargin;

    if (type == 1) {  // win
      headerLabel.setText("You win");
      pauseNextButton.setText("Next");
    } else {  // pause
      headerLabel.setText("Pause");
      pauseNextButton.setText("Back");
    }
    pauseSoundButton.setText("Sound");
    pauseExitButton.setText("Exit");

    headerLabel.setWidth(eWidthPart*5)
      .setHeigth(eHeight)
      .setX(hMargin*4)
      .setY(vMargin*1+eHeight*0)
      .show(false);

    pauseSoundButton.setWidth(eWidthPart*3)
      .setHeigth(eHeight)
      .setX(hMargin)
      .setY(vMargin*4+eHeight*3)
      .show(click);

    pauseNextButton.setWidth(eWidthPart*3)
      .setHeigth(eHeight)
      .setX(hMargin*2+(eWidthPart*3)*1)
      .setY(vMargin*4+eHeight*3)
      .show(click);

    pauseExitButton.setWidth(eWidthPart*3)
      .setHeigth(eHeight)
      .setX(hMargin*3+(eWidthPart*3)*2)
      .setY(vMargin*4+eHeight*3)
      .show(click);

    pauseMapsLabel.setWidth(eWidthPart*4)
      .setHeigth(eHeight)
      .setX(Math.round(hMargin*4.5))
      .setY(vMargin*2+eHeight*1)
      .setText("Maps left: "+availableMaps)
      .show(false);

    pauseTimeLabel.setWidth(eWidthPart*4)
      .setHeigth(eHeight)
      .setX(hMargin)
      .setY(vMargin*3+eHeight*2)
      .setText("Time spent: "+timeSpent+"s.")
      .show(false);

    pauseBestLabel.setWidth(eWidthPart*4)
      .setHeigth(eHeight)
      .setX(hMargin*4+eWidthPart*4)
      .setY(vMargin*3+eHeight*2)
      .setText("Best time: "+timeBest+"s.")
      .show(false);
  }

  void drawGameScreen() {
    drawBlock(0, false); // left
    drawBlock(1, false); // map
    drawBlock(2, false); // right

    // controll elements
    int lVSize = Math.round(leftInnerHeight/7.0);  // (left vertical size) = 3 elements with 4 margins (element weight = 1, margin -- 1) 3*1 + 4*1 = 3 + 4 = 7
    int lVMargin = lVSize;  // left vertical margin
    int lEHeight = lVSize;  // left element height
    int lHMargin = Math.round(leftInnerWidth/15);  // left horizontal margin
    int lEWidth = lHMargin*14;  // left element width

    int rVSize = Math.round(rightInnerHeight/7.0);  // (right vertical size) = 3 elements with 4 margins (element weight = 1, margin -- 1) 3*1 + 4*1 = 3 + 4 = 7
    int rVMargin = rVSize;
    int rEHeight = rVSize;
    int rHMargin = Math.round(rightInnerWidth/15);  // right horizontal margin
    int rEWidth = rHMargin*14;

    pauseButton.setWidth(lEWidth)
      .setHeigth(lEHeight)
      .setX(leftInnerX+lHMargin)
      .setY(leftInnerY+lVMargin*1+lEHeight*0)
      .show(click);

    soundButton.setWidth(lEWidth)
      .setHeigth(lEHeight)
      .setX(leftInnerX+lHMargin)
      .setY(leftInnerY+lVMargin*2+lEHeight*1)
      .show(click);

    showMapButton.setWidth(lEWidth)
      .setHeigth(lEHeight)
      .setX(leftInnerX+lHMargin)
      .setY(leftInnerY+lVMargin*3+lEHeight*2)
      .show(click);

    timeLabel.setWidth(rEWidth)
      .setHeigth(rEHeight)
      .setX(rightInnerX+rHMargin)
      .setY(rVMargin*1+rEHeight*0)
      .setText("Time:"+timeSpent+"s.")
      .show(click);

    bestLabel.setWidth(lEWidth)
      .setHeigth(lEHeight)
      .setX(rightInnerX+lHMargin)
      .setY(rightInnerY+lVMargin*2+lEHeight*1)
      .setText("Best:"+timeBest+"s.")
      .show(click);

    mapCountLabel.setWidth(rEWidth)
      .setHeigth(rEHeight)
      .setX(rightInnerX+rHMargin)
      .setY(rVMargin*3+rEHeight*2)
      .setText("Maps:"+availableMaps)
      .show(click);

  }

  void initLeftBlock() {
    leftOutline = border;  // if want to change :-)
    leftFullWidth = (width - height)/2;
    leftInnerWidth = leftFullWidth - leftOutline;  // left border = outline, right border from mapBlock
    leftFullHeight = height;
    leftInnerHeight = leftFullHeight - leftOutline*2;  // top and bottom borders are outline
    leftOuterX = 0;  // start of screen
    leftInnerX = leftOuterX + leftOutline;  // outer + outline
    leftOuterY = 0;  // start of screen
    leftInnerY = leftOuterY + leftOutline;  // outer + outline
  }

  void initMapBlock() {
    mapOutline = border;  // if want to change :-)
    mapFullWidth = height;
    mapInnerWidth = mapFullWidth - mapOutline*2;  // left border from rightBlock, right border = outline
    mapFullHeight = height;  // top otline, innerHeight, bottom outline
    mapInnerHeight = mapFullHeight - mapOutline*2;  // top and bottom borders are outline 
    mapOuterX = leftFullWidth;  // after leftBlock
    mapInnerX = mapOuterX + mapOutline;  // outer + outline
    mapOuterY = 0;  // start of screen
    mapInnerY = mapOuterY + mapOutline;  // outer + outline
  }

  void initRightBlock() {
    rightOutline = border;  // if want to change :-)
    rightFullWidth = (width - height)/2;
    rightInnerWidth = rightFullWidth - rightOutline;  // right border = outline, left border from mapBlock
    rightFullHeight = height;  // height
    rightInnerHeight = rightFullHeight - rightOutline*2;  // top border innerH. bottom border
    rightOuterX = leftFullWidth + mapFullWidth;  // after map border
    rightInnerX = rightOuterX;  // outer without outline (outline is right)
    rightOuterY = 0;  // start of the screen
    rightInnerY = rightOuterY + rightOutline;  // outer + outline
  }

  void initControlls() {
    // buttons
    playButton = new Controll(1)
      .setOutlineWidth(border)
      .setText("Play");

    helpButton = new Controll(1)
      .setOutlineWidth(border)
      .setText("Help");

    exitButton = new Controll(1)
      .setOutlineWidth(border)
      .setText("Exit");

    pauseButton = new Controll(1)
      .setOutlineWidth(border)
      .setText("Pause");

    showMapButton = new Controll(1)
      .setOutlineWidth(border)
      .setText("Map");

    soundButton = new Controll(1)
      .setOutlineWidth(border)
      .setText("Sound");

    infoExitButton = new Controll(1)
      .setOutlineWidth(border);

    pauseSoundButton = new Controll(1)
      .setOutlineWidth(border);

    pauseNextButton = new Controll(1)
      .setOutlineWidth(border);

    pauseExitButton = new Controll(1)
      .setOutlineWidth(border);

    // labels
    headerLabel = new Controll(0)
      .setOutlineWidth(border);

    mapCountLabel = new Controll(0)
      .setOutlineWidth(border)
      .setTextSize(35);

    timeLabel = new Controll(0)
      .setOutlineWidth(border)
      .setTextSize(35);

    bestLabel = new Controll(0)
      .setOutlineWidth(border)
      .setTextSize(35);

    pauseMapsLabel = new Controll(0)
      .setOutlineWidth(border)
      .setTextSize(35);

    pauseTimeLabel = new Controll(0)
      .setOutlineWidth(border)
      .setTextSize(35);

    pauseBestLabel = new Controll(0)
      .setOutlineWidth(border)
      .setTextSize(35);

    // bid label
    infoBigLabel = new Controll(2)
      .setOutlineWidth(border);
  }


  void drawSimpleBorder() {
    // screen values
    int fullWidth, fullHeight, innerWidth, innerHeight, outerX, innerX, outerY, innerY, outline;
    outline = border;
    fullWidth = width;
    innerWidth = fullWidth - outline*2;
    fullHeight = height;
    innerHeight = fullHeight - outline*2;
    outerX = 0;
    innerX = outerX + outline;
    outerY = 0;
    innerY = outerY + outline;
    // draw screen
    fill(0);
    rect(outerX, outerY, fullWidth, fullHeight);
    fill(255);
    rect(innerX, innerY, innerWidth, innerHeight);
  }

  void drawBlock(int block, boolean useMap) {
    if (block == 0) {
      fill(0);
      rect(leftOuterX, leftOuterY, leftFullWidth, leftFullHeight);
      fill(255);
      rect(leftInnerX, leftInnerY, leftInnerWidth, leftInnerHeight);
    } else if (block == 1) {
      fill(0);
      rect(mapOuterX, mapOuterY, mapFullWidth, mapFullHeight);
      if (useMap) {
        fill(170);
      } else {
        fill(150);
      }
      rect(mapInnerX, mapInnerY, mapInnerWidth, mapInnerHeight);
    } else if (block == 2) {
      fill(0);
      rect(rightOuterX, rightOuterY, rightFullWidth, rightFullHeight);
      fill(255);
      rect(rightInnerX, rightInnerY, rightInnerWidth, rightInnerHeight);
    }
  }

  UI() {
  }
}
