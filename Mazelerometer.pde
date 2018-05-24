//import ketai.sensors.*; //<>// //<>//

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

UI ui;
Box2DProcessing box2d;
Player player;

JSONObject maze;
JSONArray levels;

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
  ui = new UI();
  ui.border = Math.round(height * .00625);
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
  
  ui.initControlls();
  
  ui.initLeftBlock();
  ui.initMainBlock();
  ui.initMapBlock();
  ui.initRightBlock();

  player = new Player(width/2, height/2, ui.mainInnerWidth/7);
  
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
    currentScreen = "start";
    ui.drawStartScreen();
  } 
  updateStartScreen();
}

void updateStartScreen() {
  ui.playButton.show(click);
  ui.helpButton.show(click);
  ui.exitButton.show(click);
  if (ui.playButton.isClicked(click)) {
    playButtonEvent(); 
  }
  if (ui.helpButton.isClicked(click)) {
    helpButtonEvent();
  }
  if (ui.exitButton.isClicked(click)) {
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
    currentScreen = "info";
    ui.drawInfoScreen(type);
  }
  updateInfoScreen();
} //<>// //<>//

void updateInfoScreen() {
  ui.infoExitButton.show(click);
  if (ui.infoExitButton.isClicked(click)) {
    infoExitButtonEvent(); //<>// //<>//
  } //<>// //<>//
}
void infoExitButtonEvent() {
  if (isError) {
    System.exit(0); //<>// //<>//
  } else { //<>// //<>//
    isStart = true;
    isInfo = false;
  }
}

void pauseScreen(int type) {
  if (currentScreen != "pause") {
    ui.drawPauseScreen(type);
    currentScreen = "pause";
  }
  updatePauseScreen(type);
}

void updatePauseScreen(int type) {
  ui.pauseSoundButton.show(click);
  ui.pauseNextButton.show(click);
  ui.pauseExitButton.show(click);


  if (ui.pauseSoundButton.isClicked(click)) {  // need to check back or exit
    pauseSoundButtonEvent();
  }
  if (ui.pauseNextButton.isClicked(click)) {  // need to check back or exit
    pauseNextButtonEvent();
  }
  if (ui.pauseExitButton.isClicked(click)) {  // need to check back or exit
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
void pauseExitButtonEvent() { //<>// //<>//
  System.exit(0); //<>// //<>//
}

void gameScreen() {
  if (currentScreen != "game") {
    currentScreen = "game";
    timeNow = millis();
    ui.drawGameScreen();
  }
  updateGameScreen();
}
 //<>// //<>//
 //<>// //<>//
/*
{
  JSONObject level = levels.getJSONObject(currentLevel-1);
  JSONArray rawPattern = level.getJSONArray("pattern");  // jsonArray of jsonArrays
 //<>// //<>//
  cellsCount = level.getInt("size"); //<>// //<>//
  availableMaps = level.getInt("availableMaps");
  cellSize = mapInnerWidth / cellsCount;
  mapShift = (mapInnerWidth - (cellSize * cellsCount))/2; //<>// //<>//
  timeBest = level.getInt("bestTime"); //<>// //<>//
 //<>// //<>//
  for (int i = 0; i < cellsCount; i++) {
    levelPattern.add(rawPattern.getJSONArray(i).getIntArray());  // arrayList of int arrays
    for (int j = 0; j<cellsCount; j++) {
      levelPatternWalls.add(new Wall(j*cellSize, i*cellSize,cellSize,cellSize));
    }
  }
}

void updateMap() {
  pushMatrix(); //<>// //<>//
  translate(ui.mapInnerX+mapShift+cellSize/2, ui.mapInnerY+mapShift+cellSize/2); //<>// //<>//
  Wall pl;
  for (int i = 0; i < cellsCount; i++) {
    for (int j = 0; j < cellsCount; j++) {
      Wall w = levelPatternWalls.get(i*cellsCount+j);
      if (levelPattern.get(i)[j] == 1) { //<>// //<>//
        w.setColor(150).display(); //<>// //<>//
      } else if (levelPattern.get(i)[j] == 2) {
        pl = w;
        w.setColor(color(255, 255, 0)).display();
      } else if (levelPattern.get(i)[j] == 3) { //<>// //<>//
        w.setColor(color(0, 255, 0)).display(); //<>// //<>//
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
}*/



void updateGameScreen() {
  if (millis()-timeNow>=1000) {
    timeNow = millis();
    timeSpent++;
  }

  ui.pauseButton.show(click);
  ui.showMapButton.show(click);
  ui.soundButton.show(click);

  ui.mapCountLabel.setText("Maps:"+availableMaps)
    .show(false);
  ui.timeLabel.setText("Time:"+timeSpent+"s.")
    .show(false);

  updateMain();
  // updateMap();
  if (ui.pauseButton.isClicked(click)) {
    pauseButtonEvent();
  }
  if (ui.showMapButton.isClicked(click)) {
    showMapButtonEvent();
  }
  if (ui.soundButton.isClicked(click)) {
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
  ui.drawBlock(ui.mainOuterX, ui.mainOuterY, ui.mainFullWidth, ui.mainFullHeight, ui.mainInnerX, ui.mainInnerY, ui.mainInnerWidth, ui.mainInnerHeight, 0);
  box2d.step();
  player.display();
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
