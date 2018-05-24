//import ketai.sensors.*; //<>// //<>// //<>// //<>// //<>//

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


Box2DProcessing box2d;
Player player;

JSONObject maze;
JSONArray levels;
int border;

   int leftFullWidth, leftFullHeight, leftInnerWidth, leftInnerHeight, leftOuterX, leftInnerX, leftOuterY, leftInnerY, leftOutline;
   int mainFullWidth, mainFullHeight, mainInnerWidth, mainInnerHeight, mainOuterX, mainInnerX, mainOuterY, mainInnerY, mainOutline;
   int mapFullWidth, mapFullHeight, mapInnerWidth, mapInnerHeight, mapOuterX, mapInnerX, mapOuterY, mapInnerY, mapOutline;
   int rightFullWidth, rightFullHeight, rightInnerWidth, rightInnerHeight, rightOuterX, rightInnerX, rightOuterY, rightInnerY, rightOutline;

   Controll playButton, helpButton, exitButton, pauseButton, showMapButton, soundButton, infoExitButton, pauseSoundButton, pauseNextButton, pauseExitButton;
   Controll headerLabel, mapCountLabel, timeLabel, bestLabel, pauseMapsLabel, pauseTimeLabel, pauseBestLabel;
   Controll infoBigLabel;

int currentLevel = 1, availableMaps = 0, timeSpent = 0, timeBest = 0, timeNow;
int cellsCount;  // level size, available maps
int cellSize;  // size of one wall / empty / player / exit cell
float mapShift;  // if map / cellsCount is not integer
ArrayList<int[]> levelPattern = new ArrayList();
ArrayList<Wall> levelPatternWalls = new ArrayList();
String currentScreen;
boolean isStart = true, isInfo = false, isPause = false, isWin = false, isError = false;
boolean sound = true, click = false;

void setup() {
  orientation(LANDSCAPE);
  //fullScreen();
  size(960, 540);
  //size(480,270);
  background(255);
  init();
}

void init() {
  noStroke();
border = Math.round(height * .00625);
  try {
    maze = loadJSONObject("maze.json");
    if (maze != null) {  // loaded successfully
      levels = maze.getJSONArray("levels");
      if (levels == null) {  // levels does not exist
        isError = true;
        println("Can not load levels");
      }
    } else {  // not successfull load
      isError = true;
      println("File is broken");
    }
  }
  catch (Exception e) {
    println("There is no such file");
    isError = true;
  }

  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0, 0);
  
  initControlls();
  
  initLeftBlock();
  initMainBlock();
  initMapBlock(border);
  initRightBlock(border);

  player = new Player(width/2, height/2, mainInnerWidth/7);
  
}

void draw() {
  // box2d.step();
  if (isStart) {  // start screen
    startScreen();
  } else if (isInfo) {  // info screen
    if (isError) {  // show error
      infoScreen(1);
    } else {  // show help
      infoScreen(0);
    }
  } else if (isPause) {  // pause screen
    if (isWin) {  // show win
      pauseScreen(1);
    } else {  // show pause
      pauseScreen(0);
    }
  } else {  // game screen
    gameScreen();
  }
  click = false;
}

void startScreen() {
  if (currentScreen != "start") {
    initStartScreen();
  } 
  updateStartScreen();
}
void initStartScreen() {
  drawSimpleBorder();
  currentScreen = "start";

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
    .setX(hMargin) //<>// //<>//
    .setY(vMargin*3+eHeight*2)
    .show(click);

  exitButton.setWidth(eWidth)
    .setHeigth(eHeight) //<>// //<>//
    .setX(hMargin) //<>// //<>//
    .setY(vMargin*4+eHeight*3)
    .show(click);
}
 //<>// //<>// //<>//
void  updateStartScreen() { //<>// //<>//
  playButton.show(click);
  helpButton.show(click);
  exitButton.show(click);
  if (playButton.isClicked(click)) { //<>//
    playButtonEvent(); //<>//
  }
  if (helpButton.isClicked(click)) {
    helpButtonEvent();
  } //<>//
  if (exitButton.isClicked(click)) { //<>//
    exitButtonEvent();
  }
}
void playButtonEvent() {
  isStart = false;
}
void helpButtonEvent() {
  isStart = false;
  isInfo = true;
}
void exitButtonEvent() {
  System.exit(0);
  //exit();
}

void  infoScreen(int type) {
  if (currentScreen != "info") {
    initInfoScreen(type);
  }
  updateInfoScreen();
}
void  initInfoScreen(int type) {
  drawSimpleBorder();
  currentScreen = "info";
  // controll elements values
  int vMargin = Math.round((height-border*2)/13);  // 4 elements with 5 margins (element weight = 2, margin -- 1) 4*2 + 5*1 = 8 + 5 = 13
  int eHeight = vMargin*2;
  int hMargin = Math.round(((width-border*2)/4)*1.5);  // 1 element with 2 margins (element weight = 1, margin -- 1.5) 1*1 + 2*1.5 = 1 + 3 = 4
  int eWidth = Math.round(hMargin/1.5);

  if (type == 1) {  // error
    headerLabel.setText("Error");
    infoBigLabel.setTextSize(80)
      .setTextColor(#cf0808) //<>// //<>//
      .setText("Error"); //<>// //<>//
    infoExitButton.setText("Exit");
  } else {  // help
    headerLabel.setText("How to play?");
    infoBigLabel.setTextSize(25)
      .setTextColor(0)
      .setText("You need to find exit of the maze and lead ball there.\n"+
      "At at game start you can see maze map, but it will dissapear soon.\n"+
      "You can show map again, but only several times (and for short time)\n"+
      "Your goal and ball are always highlighted on the map.\n"+ //<>//
      "The sooner you finish the better."); //<>//
    infoExitButton.setText("Back"); //<>// //<>//
  } //<>// //<>//

  headerLabel.setWidth(eWidth*2)
    .setHeigth(eHeight)
    .setX(hMargin-(eWidth/2))
    .setY(vMargin*1+eHeight*0) //<>// //<>//
    .show(false); //<>// //<>//

  infoBigLabel.setWidth(eWidth*2)
    .setHeigth(eHeight*2+vMargin) //<>// //<>// //<>//
    .setX(hMargin-(eWidth/2)) //<>// //<>// //<>//
    .setY(vMargin*2+eHeight*1) //<>// //<>//
    .show(false);

  infoExitButton.setWidth(eWidth)
    .setHeigth(eHeight) //<>//
    .setX(hMargin) //<>//
    .setY(vMargin*4+eHeight*3)
    .show(click);
} //<>// //<>//
void updateInfoScreen() { //<>// //<>// //<>//
  infoExitButton.show(click); //<>// //<>// //<>//
  if (infoExitButton.isClicked(click)) { //<>// //<>//
    infoExitButtonEvent();
  }
}
void infoExitButtonEvent() {
  if (isError) { //<>// //<>//
    System.exit(0); //<>// //<>//
  } else {
    isStart = true;
    isInfo = false; //<>// //<>//
  } //<>// //<>// //<>// //<>//
} //<>// //<>//

void pauseScreen(int type) {
  if (currentScreen != "pause") {
    initPauseScreen(type); //<>// //<>//
  } //<>// //<>//
  updatePauseScreen(type);
}
void initPauseScreen(int type) {
  drawSimpleBorder(); //<>// //<>//
  currentScreen = "pause"; //<>// //<>//
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
void updatePauseScreen(int type) {
  pauseSoundButton.show(click);
  pauseNextButton.show(click);
  pauseExitButton.show(click);


  if (pauseSoundButton.isClicked(click)) {  // need to check back or exit
    pauseSoundButtonEvent();
  }
  if (pauseNextButton.isClicked(click)) {  // need to check back or exit
    pauseNextButtonEvent();
  }
  if (pauseExitButton.isClicked(click)) {  // need to check back or exit
    pauseExitButtonEvent();
  }
}
void pauseSoundButtonEvent() {
  sound = !sound;
}
void pauseNextButtonEvent() {
  if (isWin) {
    if (currentLevel>=levels.size()) {
      currentLevel=1;
    } else {
      currentLevel++;
    }
  }
  isPause = false;
}
void pauseExitButtonEvent() {
  System.exit(0);
}

void gameScreen() {
  if (currentScreen != "game") {
    initGameScreen();
    initGameScreen2();
    currentScreen = "game";
  }
  updateGameScreen();
}
void initGameScreen() {
  timeNow = millis();

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

void initMapBlock(int borderWidth) {
  mapOutline = borderWidth;  // if want to change :-)
  mapFullWidth = (width - height)/2;
  mapInnerWidth = mapFullWidth - mapOutline;  // left border from mainBlock, right border = outline
  mapFullHeight = mapFullWidth + mapOutline;  // top otline, innerHeight, bottom outline
  mapInnerHeight = mapFullHeight - mapOutline*2;  // top and bottom borders are outline 
  mapOuterX = leftFullWidth + mainFullWidth;  // after main border
  mapInnerX = mapOuterX;  // outer without outline (outline is right)
  mapOuterY = 0;  // start of screen
  mapInnerY = mapOuterY + mapOutline;  // outer + outline

  JSONObject level = levels.getJSONObject(currentLevel-1);
  JSONArray rawPattern = level.getJSONArray("pattern");  // jsonArray of jsonArrays

  cellsCount = level.getInt("size");
  availableMaps = level.getInt("availableMaps");
  cellSize = mapInnerWidth / cellsCount;
  mapShift = (mapInnerWidth - (cellSize * cellsCount))/2;
  timeBest = level.getInt("bestTime");

  for (int i = 0; i < cellsCount; i++) {
    levelPattern.add(rawPattern.getJSONArray(i).getIntArray());  // arrayList of int arrays
    for (int j = 0; j<cellsCount; j++) {
      levelPatternWalls.add(new Wall(j*cellSize, i*cellSize,cellSize,cellSize));
    }
  }
}
void initRightBlock(int borderWidth) {
  rightOutline = borderWidth;  // if want to change :-)
  rightFullWidth = (width - height)/2;
  rightInnerWidth = rightFullWidth - rightOutline;  // left border = outline, right border from mainBlock
  rightFullHeight = height - mapFullHeight;  // share height with map
  rightInnerHeight = rightFullHeight - rightOutline;  // top border from map, bottom border = outline
  rightOuterX = leftFullWidth + mainFullWidth;  // after main border
  rightInnerX = rightOuterX;  // outer without outline (outline is right)
  rightOuterY = mapFullHeight;  // after map
  rightInnerY = rightOuterY;  // outer (top outline from map)
}
void drawBlock(int outerX, int outerY, int fullWidth, int fullHeight, int innerX, int innerY, int innerWidth, int innerHeight, int isMap) {
  fill(0);
  rect(outerX, outerY, fullWidth, fullHeight);
  if (isMap==1)
    fill(150);
  else
    fill(255);
  rect(innerX, innerY, innerWidth, innerHeight);
}

void updateGameScreen() {
  if (millis()-timeNow>=1000) {
    timeNow = millis();
    timeSpent++;
  }

  pauseButton.show(click);
  showMapButton.show(click);
  soundButton.show(click);

  mapCountLabel.setText("Maps:"+availableMaps)
    .show(false);
  timeLabel.setText("Time:"+timeSpent+"s.")
    .show(false);

  updateMain();
  updateMap();
  if (pauseButton.isClicked(click)) {
    pauseButtonEvent();
  }
  if (showMapButton.isClicked(click)) {
    showMapButtonEvent();
  }
  if (soundButton.isClicked(click)) {
    soundButtonEvent();
  }
}
void pauseButtonEvent() {
  isStart = false;
  isInfo = false;
  isPause = true;
}
void showMapButtonEvent() {
  if (availableMaps>0) {
    // show map
    availableMaps--;
  }
}
void soundButtonEvent() {
  sound = !sound;
}
void updateMain() {
  drawBlock(mainOuterX, mainOuterY, mainFullWidth, mainFullHeight, mainInnerX, mainInnerY, mainInnerWidth, mainInnerHeight, 0);
  box2d.step();
  player.display();
}
void updateMap() {
  pushMatrix();
  translate(mapInnerX+mapShift+cellSize/2, mapInnerY+mapShift+cellSize/2);
  Wall pl;
  for (int i = 0; i < cellsCount; i++) {
    for (int j = 0; j < cellsCount; j++) {
      Wall w = levelPatternWalls.get(i*cellsCount+j);
      if (levelPattern.get(i)[j] == 1) {
        w.setColor(150).display();
      } else if (levelPattern.get(i)[j] == 2) {
        pl = w;
        w.setColor(color(255, 255, 0)).display();
      } else if (levelPattern.get(i)[j] == 3) {
        w.setColor(color(0, 255, 0)).display();
      } else {
        w.setColor(255).display();
      }
        
      //stroke(0);
    }
  }
  popMatrix();
  
  
  //pushMatrix();
  //translate(mapInnerX+mapShift, mapInnerY+mapShift);
  //for (int i = 0; i < cellsCount; i++) {
  //  for (int j = 0; j < cellsCount; j++) {
  //    if (levelPattern.get(i)[j] == 1) {
  //      fill(150);
  //    } else if (levelPattern.get(i)[j] == 2) {
  //      fill(255, 255, 0);
  //    } else if (levelPattern.get(i)[j] == 3) {
  //      fill(0, 255, 0);
  //    } else {
  //      fill(255);
  //    }
  //    stroke(0);
  //    rect(j*cellSize, i*cellSize, cellSize, cellSize);
  //  }
  //}
  //popMatrix();
}

void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

//  if (o1.getClass() == Particle.class && o2.getClass() == Particle.class) {
//    Particle p1 = (Particle) o1;
//    p1.delete();
//    Particle p2 = (Particle) o2;
//    p2.delete();
//  }

  if (o1.getClass() == Player.class) {
    Wall w = (Wall) o2;
    w.change();
  }
  if (o2.getClass() == Player.class) {
    Wall w = (Wall) o1;
    w.change();
  }
}

void endContact(Contact cp) {
}

void mousePressed() {
  click = true;
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
  
   void initLeftBlock() {
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
 void initMainBlock() {
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

 void initGameScreen2(){
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
