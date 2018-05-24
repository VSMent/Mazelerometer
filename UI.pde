static class UI {

  static int border = Math.round(height * .00625);

  static int leftFullWidth, leftFullHeight, leftInnerWidth, leftInnerHeight, leftOuterX, leftInnerX, leftOuterY, leftInnerY, leftOutline;
  static int mainFullWidth, mainFullHeight, mainInnerWidth, mainInnerHeight, mainOuterX, mainInnerX, mainOuterY, mainInnerY, mainOutline;
  static int mapFullWidth, mapFullHeight, mapInnerWidth, mapInnerHeight, mapOuterX, mapInnerX, mapOuterY, mapInnerY, mapOutline;
  static int rightFullWidth, rightFullHeight, rightInnerWidth, rightInnerHeight, rightOuterX, rightInnerX, rightOuterY, rightInnerY, rightOutline;

  static Controll playButton, helpButton, exitButton, pauseButton, showMapButton, soundButton, infoExitButton, pauseSoundButton, pauseNextButton, pauseExitButton;
  static Controll headerLabel, mapCountLabel, timeLabel, bestLabel, pauseMapsLabel, pauseTimeLabel, pauseBestLabel;
  static Controll infoBigLabel;

  static void initControlls() {
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

  static void drawSimpleBorder() {
    // screen values
    int fullWidth, fullHeight, innerWidth, innerHeight, outerX, innerX, outerY, innerY, outline;
    outline = border;
    fullWidth = width; //<>//
    innerWidth = fullWidth - outline*2; //<>//
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
    rect(innerX, innerY, innerWidth, innerHeight); //<>//
  }
  
  static void initLeftBlock() {
  leftOutline = border;  // if want to change :-)
  leftFullWidth = (width - height)/2;
  leftInnerWidth = leftFullWidth - leftOutline;  // left border = outline, right border from mainBlock
  leftFullHeight = height;
  leftInnerHeight = leftFullHeight - leftOutline*2;  // top and bottom borders are outline
  leftOuterX = 0;  // start of screen
  leftInnerX = leftOuterX + leftOutline;  // outer + outline
  leftOuterY = 0;  // start of screen
  leftInnerY = leftOuterY + leftOutline;  // outer + outline
}
static void initMainBlock() {
  mainOutline = border;  // if want to change :-)
  mainFullWidth = height;
  mainInnerWidth = mainFullWidth - mainOutline*2;  // left and right borders = outline
  mainFullHeight = height;
  mainInnerHeight = mainFullHeight - mainOutline*2;  // top and bottom borders are outline
  mainOuterX = leftFullWidth;  // after leftBlock
  mainInnerX = mainOuterX + mainOutline;  // outer + outline
  mainOuterY = 0;  // start of screen
  mainInnerY = mainOuterY + mainOutline;  // outer + outline
}

static void initGameScreen(){
  drawBlock(leftOuterX, leftOuterY, leftFullWidth, leftFullHeight, leftInnerX, leftInnerY, leftInnerWidth, leftInnerHeight, 0);
  drawBlock(mainOuterX, mainOuterY, mainFullWidth, mainFullHeight, mainInnerX, mainInnerY, mainInnerWidth, mainInnerHeight, 0);
  drawBlock(mapOuterX, mapOuterY, mapFullWidth, mapFullHeight, mapInnerX, mapInnerY, mapInnerWidth, mapInnerHeight, 1);
  drawBlock(rightOuterX, rightOuterY, rightFullWidth, rightFullHeight, rightInnerX, rightInnerY, rightInnerWidth, rightInnerHeight, 0);

  // controll elements
  int lVMargin = Math.round(leftInnerHeight/13);  // (left vertical margin) left 4 elements with 5 margins (element weight = 2, margin -- 1) 4*2 + 5*1 = 8 + 5 = 13
  int lEHeight = lVMargin*2;  // left element height
  int lHMargin = Math.round(leftInnerWidth/15);  // (left horizontal margin) 1 element with 2 margins (element weight = 1, margin -- 1.5) 1*1 + 2*1.5 = 1 + 3 = 4
  int lEWidth = lHMargin*14;  // left element width

  int rEHeight = lEHeight;
  int rVMargin = Math.round((rightFullHeight-2*rEHeight)/3);  // right 2 elements with 3 margins (element weight = 2, margin -- 1) 2*2 + 3*1 = 4 + 3 = 7
  int rHMargin = Math.round(rightInnerWidth/15);  // 1 element with 2 margins (element weight = 1, margin -- 1.5) 1*1 + 2*1.5 = 1 + 3 = 4
  int rEWidth = rHMargin*14;

  pauseButton.setWidth(lEWidth)
    .setHeigth(lEHeight)
    .setX(leftInnerX+lHMargin)
    .setY(leftInnerY+lVMargin*1+lEHeight*0)
    .show(click);

  showMapButton.setWidth(lEWidth)
    .setHeigth(lEHeight)
    .setX(leftInnerX+lHMargin)
    .setY(leftInnerY+lVMargin*2+lEHeight*1)
    .show(click);

  mapCountLabel.setWidth(lEWidth)
    .setHeigth(lEHeight)
    .setX(leftInnerX+lHMargin)
    .setY(lVMargin*3+lEHeight*2)
    .setText("Maps:"+availableMaps)
    .show(click);

  timeLabel.setWidth(lEWidth)
    .setHeigth(lEHeight)
    .setX(leftInnerX+lHMargin)
    .setY(lVMargin*4+lEHeight*3)
    .setText("Time:"+timeSpent+"s.")
    .show(click);

  bestLabel.setWidth(rEWidth)
    .setHeigth(rEHeight)
    .setX(rightInnerX+rHMargin)
    .setY(rightInnerY+rVMargin*1+rEHeight*0)
    .setText("Best:"+timeBest+"s.")
    .show(click);

  soundButton.setWidth(rEWidth)
    .setHeigth(rEHeight)
    .setX(rightInnerX+rHMargin)
    .setY(rightInnerY+rVMargin*2+rEHeight*1)
    .show(click);
}
  

  UI() {
  }
}
