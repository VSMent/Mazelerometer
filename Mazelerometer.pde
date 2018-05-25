//import ketai.sensors.*;  //<>// //<>// //<>// //<>//

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

MapEntity ex;
MapEntity pl;
Player player;

JSONObject maze;
JSONArray levels;

int currentLevel = 1, availableMaps = -1, timeSpent = 0, timeBest = 0, timeNow;
int cellsCount;  // level size, available maps
int cellSize;  // size of one wall / empty / player / exit cell
int hitHistory = 5;  // how much hit walls will be displayed
int mapTimeEnd = 3, mapDuration = 3;  // when to stop showing map, for how long show map 
float mapShift;  // if map / cellsCount is not integer
float ballMaxSpeed, ballAcceleration;
Vec2 velocity, position;
ArrayList<int[]> levelPattern;
ArrayList<MapEntity> levelPatternWalls;
ArrayList<MapEntity> hitWalls;
String currentScreen;
boolean isStart = true, isInfo = false, isPause = false, isWin = false, isError = false;
boolean sound = true, click = false, useMap = true;

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
  ballMaxSpeed = 5;
  ballAcceleration = 0.3;
  velocity = new Vec2(0, 0);
  hitWalls = new ArrayList();
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

  player = new Player(width/2, height/2, 100);

  ui.initControlls();

  ui.initLeftBlock();
  ui.initMainBlock();
  ui.initMapBlock();
  ui.initRightBlock();
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
  System.exit(0); //<>// //<>// //<>//
  //exit(); //<>//
}

void  infoScreen(int type) {
  if (currentScreen != "info") { //<>// //<>// //<>//
    currentScreen = "info"; //<>// //<>// //<>// //<>//
    ui.drawInfoScreen(type); //<>//
  }
  updateInfoScreen();
} //<>// //<>// //<>//
 //<>// //<>// //<>// //<>//
void updateInfoScreen() { //<>//
  ui.infoExitButton.show(click);
  if (ui.infoExitButton.isClicked(click)) {
    infoExitButtonEvent();
  }
}
void infoExitButtonEvent() {
  if (isError) {
    System.exit(0);
  } else {
    isStart = true;
    isInfo = false;
  }
}

void pauseScreen(int type) {
  if (currentScreen != "pause") {
    if (type == 1) {
      if (timeSpent<timeBest || timeBest == 0) {
        timeBest = timeSpent;
        updateJson();
      }
    } else {
      position = pl.pos;
    }
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
  if (ui.pauseExitButton.isClicked(click)) {  // need to check back or exit //<>// //<>// //<>//
    pauseExitButtonEvent(); //<>// //<>// //<>// //<>//
  } //<>//
}

void pauseSoundButtonEvent() {
  sound = !sound;
}
void pauseNextButtonEvent() {
  if (isWin) {
    if (currentLevel>=levels.size()) {
      currentLevel=1;
    } else { //<>// //<>// //<>//
      currentLevel++; //<>// //<>// //<>// //<>//
    } //<>//
    timeSpent = 0;
    timeBest = 0;
    hitWalls = new ArrayList();
    isWin = false; //<>// //<>// //<>//
  } //<>// //<>// //<>// //<>//
  isPause = false; //<>//
}
void pauseExitButtonEvent() { //<>// //<>// //<>//
  System.exit(0); //<>// //<>// //<>// //<>//
} //<>// //<>// //<>// //<>//
 //<>//
void gameScreen() {
  if (currentScreen != "game") {
    currentScreen = "game";

    timeNow = millis();

    loadLevel();

    ui.drawGameScreen(); //<>// //<>// //<>//
  } //<>// //<>// //<>// //<>//
  updateGameScreen(); //<>//
}

void loadLevel() {
  if (pl != null) {     //<>// //<>// //<>// //<>//
    pl.killBody(); //<>// //<>// //<>// //<>//
    ex.killBody();
    for (MapEntity e : levelPatternWalls) {
      e.killBody();
    } //<>// //<>// //<>// //<>//
  } //<>// //<>// //<>// //<>//
  levelPattern = new ArrayList();
  levelPatternWalls = new ArrayList();
  pl = null;
  ex = null;  

  JSONObject level = levels.getJSONObject(currentLevel-1);
  JSONArray rawPattern = level.getJSONArray("pattern");  // jsonArray of jsonArrays

  cellsCount = level.getInt("size");
  availableMaps = availableMaps == -1 ? level.getInt("availableMaps") : availableMaps;
  timeBest = level.getInt("bestTime");
  cellSize = ui.mapInnerWidth / cellsCount;
  mapShift = (ui.mapInnerWidth - (cellSize * cellsCount))/2;

  for (int i = 0; i < cellsCount; i++) {
    levelPattern.add(rawPattern.getJSONArray(i).getIntArray());  // arrayList of int arrays
    for (int j = 0; j<cellsCount; j++) {
      if (levelPattern.get(i)[j] == 1) {
        if (!checkWall(j*cellSize, i*cellSize)) {
          levelPatternWalls.add(new MapEntity(j*cellSize, i*cellSize, cellSize, cellSize, 1).changeBack());
        } else {
          levelPatternWalls.add(new MapEntity(j*cellSize, i*cellSize, cellSize, cellSize, 1).change());
        }
      } else if (levelPattern.get(i)[j] == 2) { 
        if (position == null) {
          pl = new MapEntity(j*cellSize, i*cellSize, cellSize, cellSize, 2).setColor(color(255, 255, 0));
        } else {
          pl = new MapEntity(position.x, position.y, cellSize, cellSize, 2).setColor(color(255, 255, 0));
        }
      } else if (levelPattern.get(i)[j] == 3) { 
        ex = new MapEntity(j*cellSize, i*cellSize, cellSize, cellSize, 3).setColor(color(0, 255, 0));
      }
    }
  }
}

boolean checkWall(float x, float y) {
  for (MapEntity e : hitWalls) {
    if (e.pos.x == x && e.pos.y == y) {
      return true;
    }
  }
  return false;
}
void updateGameScreen() {
  if (millis()-timeNow>=1000) {
    timeNow = millis();
    timeSpent++;
    if(timeSpent >= mapTimeEnd){
      useMap = false;
    }
  }

  ui.pauseButton.show(click);
  ui.showMapButton.show(click);
  ui.soundButton.show(click);

  ui.mapCountLabel.setText("Maps:"+availableMaps)
    .show(false);
  ui.timeLabel.setText("Time:"+timeSpent+"s.")
    .show(false);

  updateMain();
  updateMap();

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

void updateMain() {
  ui.drawBlock(1,false);
  player.display();
}

void updateMap() {
  ui.drawBlock(2,useMap);
  moveBall();
  pushMatrix();
  translate(ui.mapInnerX+mapShift+cellSize/2, ui.mapInnerY+mapShift+cellSize/2);
  box2d.step();

  position = null;

  for (MapEntity w : levelPatternWalls) {
    w.display();
  }
  pl.display();
  ex.display();
  popMatrix();
}

void pauseButtonEvent() {
  isStart = false;
  isInfo = false;
  isPause = true;
}
void showMapButtonEvent() {
  if (availableMaps>0) {
    mapTimeEnd = timeSpent+mapDuration;
    useMap = true;
    availableMaps--;
  }
}
void soundButtonEvent() {
  sound = !sound;
}




void moveBall() {  
  if (keyPressed) {
    if (keyCode == UP) {
      velocity = new Vec2(0, constrain(velocity.y+ballAcceleration, -ballMaxSpeed, ballMaxSpeed));
    }
    if (keyCode == RIGHT) {
      velocity = new Vec2(constrain(velocity.x+ballAcceleration, -ballMaxSpeed, ballMaxSpeed), 0);
    }
    if (keyCode == DOWN) {
      velocity = new Vec2(0, constrain(velocity.y-ballAcceleration, -ballMaxSpeed, ballMaxSpeed));
    }
    if (keyCode == LEFT) {
      velocity = new Vec2(constrain(velocity.x-ballAcceleration, -ballMaxSpeed, ballMaxSpeed), 0);
    }
    pl.body.setLinearVelocity(velocity);
  }
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

  if ((o1 == pl.body.getUserData()  &&  o2 == ex.body.getUserData())  ||  (o1 == ex.body.getUserData()  &&  o2 == pl.body.getUserData())) {
    isWin = true;
    isPause = true;
  }

  if (o1 == pl.body.getUserData()) {
    MapEntity w = (MapEntity) o2;
    w.change();
    hit(w);
    velocity = new Vec2(0, 0);
  }  
  if (o2 == pl.body.getUserData()) {
    MapEntity w = (MapEntity) o1;
    w.change();
    hit(w);
    velocity = new Vec2(0, 0);
  }
}

void hit(MapEntity wall){
  if(!checkWall(wall.pos.x,wall.pos.y)){ // no hit
    if(hitWalls.size() >= hitHistory){
      hitWalls.get(0).changeBack();
      hitWalls.remove(0);
    }
    hitWalls.add(wall);
  }
}
void endContact(Contact cp) {
}

void mousePressed() {
  click = true;
}

void updateJson() {

  println("\"updateJson\"");
  println("  |--currentLevel: "+currentLevel);
  println("  |--timeBest: "+timeBest);
}
