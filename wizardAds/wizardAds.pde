Target target;

ArrayList<Block> blocks;

float[] blockDist = new float[0];

//stats file
PrintWriter highscoreFile;

//Wizard frames
PImage wIdle;
PImage wD;
PImage wA;
//Current wizard frame
PImage activeFrame;

//backgrounds
PImage startBg;
PImage playBg;
PImage endBg;

//trasition frames
PImage tFrame1;
PImage tFrame2;
PImage tFrame3;
PImage tFrame4;
PImage tFrame5;

//Misc Images
PImage title;
PImage endText;

//block speed
float speed = 1.0;
//score
float score = 0.0;
float highscore = 0.0;

//timer for animation
int animTimer = 0;

//active screen, can be ("start", "play", "end")
String screen;

//closest block stats
int closestBlockType;
PVector closestBlock;
int closestBlockIndex;

//speed up times and frame count until next one
int framesUntilSpeedUp = 0;
int speedUpCount = 0;

//current spawn rate and maximum frames until next one
int spawnRateMax = 20;
int spawnRateCur = 20;

//frames until you can act again
int stunFrames = 0;

// the position of the last block hit
PVector lastHitBlockPos;

//the amount of blocks hit in a row without pressing the wrong button
int combo = 0;

void setup(){
  prepareExitHandler();
  
  size(800, 400);
  noStroke(); //turn off outline
  rectMode(CENTER); //use centre mode for drawing rectangles
  
  lastHitBlockPos = new PVector(0,0);
  
  blocks = new ArrayList<Block>();
  
  target = new Target(400,200);
  
  String[] storedScore = loadStrings("stats.txt");
  if (storedScore.length > 0){
    highscore = float(storedScore[0]);
  }
  
  highscoreFile = createWriter("stats.txt"); 
  
  //Load wizard frames
  wIdle = loadImage("wizIdle.png");
  wD = loadImage("wizD.png");
  wA = loadImage("wizA.png");
  
  //set initial active frame
  activeFrame = wIdle;
  
  //load Background images
  startBg = loadImage("startBackground.png");
  playBg = loadImage("playBackground.png");
  endBg = loadImage("endBackground.png");
  
  title = loadImage("titleText.png");
  endText = loadImage("endText.png");
  
  tFrame1 = loadImage("transitionFrame1.png");
  tFrame2 = loadImage("transitionFrame2.png");
  tFrame3 = loadImage("transitionFrame3.png");
  tFrame4 = loadImage("transitionFrame4.png");
  tFrame5 = loadImage("transitionFrame5.png");
  
  screen = "start";
}

void draw() {
  if (animTimer > 0){
    animTimer -= 1;
  }
  if (animTimer <= 0){
    activeFrame = wIdle;
  }
  //START STATE
  if (screen == "start"){
    speed = 1.0;
    score = 0.0;
    background(255);
    image(startBg, 0, 0);
    image(title, 0, 0);
    
    fill(1, 150, 255);
    rect(95, 110, 95, 30);
    
    textSize(32);
    fill(1, 97, 255);
    text(str(int(highscore)), 50, 120); 
  }

//---------------------------------------------------------------------------|

  //PLAY STATE
  if (screen == "play"){
    background(255);
    
    if (stunFrames > 0){
      image(endBg, 0, 0);
    }
    else{
      image(playBg, 0, 0);
    }
    
    target.display();
    
    printScore(score, highscore, combo);
    
    if (score > highscore){
      highscore = score;
    }
    
    image(activeFrame, 0, height/3, width/8, height/4);
    
    framesUntilSpeedUp -= 1;
    
    if (framesUntilSpeedUp <= 0){
      framesUntilSpeedUp = 1000;
      speed *= 1.5;
      speedUpCount += 1;
      println("---- SPEED UP ----");
      println("New Speed: " + speed);
    }
    
    spawnRateCur -= 1;
    
    if (spawnRateCur <= 0){
      spawnRateCur = spawnRateMax;
      spawnBlock();
    }
    
    if (animTimer > 0){
      stroke(int(random(100,200)),0,int(random(100,200)));
      strokeWeight(random(0,10));
      line(40, 200, lastHitBlockPos.x, lastHitBlockPos.y);
      noStroke();
      fill(int(random(100,200)),0,int(random(100,200)));
      ellipse(lastHitBlockPos.x, lastHitBlockPos.y, 25*animTimer, 25*animTimer);
    }
    
  }

//---------------------------------------------------------------------------|

  //END STATE
  if (screen == "end"){
    background(255);
    image(endBg, 0, 0);
    image(endText, 0, 0);
    
    fill(1, 150, 255);
    rect(95, 110, 95, 30);
    
    textSize(32);
    fill(1, 97, 255);
    text(str(int(highscore)), 50, 120); 
    
    textSize(64);
    fill(20);
    text(str(score), 360, 120); 
    
    if (score > highscore){
      highscore = score;
    }
  }
  
  try {
    for (int i = blocks.size() - 1; i >= 0; i -= 1){
        blocks.get(i).update();
        blocks.get(i).display();
        if(blocks.get(i).position.x <= 0){
          for (int j = blocks.size() - 1; j >= 0; j -= 1){
            if (blocks.size() > 0){
              blocks.remove(j);
            }
          }
          screen = "end";
        }
        if (blocks.size() > 0){
          append(blockDist, dist(0, 200, blocks.get(i).position.x, blocks.get(i).position.y));
        }
    }
  } catch (IndexOutOfBoundsException e){
    print("that was a close one");
  }
  
  
  score = round(score);
  highscore = round(highscore);
  
  stunFrames -= 1;
  
  if (stunFrames < 0){
    stunFrames = 0;
  }
  
  blockDist = sort(blockDist);
  
  closestBlockType = 2;
  closestBlock = new PVector(800,0);
  
  
  for (int i = blocks.size() - 1; i >= 0; i -= 1){
    if (blocks.get(i).distanceToPlayer < closestBlock.x){
      closestBlock = blocks.get(i).position;
      closestBlockType = blocks.get(i).blockColor;
      closestBlockIndex = i;
    }
  }
  
  if (closestBlockType != 2){
    target.position = closestBlock;
  }
  else{
  
  }
  
}

void printScore(float s, float hs, int c){
  s = round(s);
  hs = round(hs);
  textSize(64);
  fill(100);
  text(str(int(s)), 40, 120); 
  
  textSize(64);
  fill(100, 50, 20);
  text(str(int(hs)), 400, 120); 
  
  textSize(64);
  fill(100, 100, 20);
  text("X"+str(int(c)), 200, 120); 
}

boolean cast(String action){
  boolean blockHit = false; 
  
  
  if (action == "a"){
    activeFrame = wA;
    if (closestBlockType == 1){
      lastHitBlockPos = blocks.get(closestBlockIndex).position;
      blocks.remove(closestBlockIndex);
      combo += 1;
      score += speed + combo/2;
      blockHit = true;
    }
  }
  if (action == "d"){
    activeFrame = wD;
    if (closestBlockType == 0){
      lastHitBlockPos = blocks.get(closestBlockIndex).position;
      blocks.remove(closestBlockIndex);
      combo += 1;
      score += speed + combo/2;
      blockHit = true;
    }
  }
  if (blocks.size() < 1){
    blockHit = true;
  }
  return(blockHit);
}

void spawnBlock(){
  blocks.add(new Block(800, random(0,400), speed));
}

void keyPressed() {
  //Cast A and D for destroying blocks
  if (key == 'a'||key == 'A'){
    if (stunFrames < 1){
      if (!cast("a")){
        stunFrames = 40;
        combo = 0;
      }
      animTimer = 5;
    }
    
  }
  
  if (key == 'd'||key == 'D'){
    if (stunFrames < 1){
      if (!cast("d")){
        stunFrames = 40;
        combo = 0;
      }
      animTimer = 5;
    }
  }
  //close game on P press
  if (key == 'p'||key == 'P'){
    highscoreFile.println(highscore);
    highscoreFile.flush();
    highscoreFile.close();
    exit();
  }
  
  //reset score and highscore on O press
  if (key == 'o'||key == 'O'){
    score = 0;
    highscore = 0;
  }
  
  //spawn a block on Q press
  if (key == 'q'||key == 'Q'){
    spawnBlock();
  }
  
  // on I press switch to the next screen
  if (key == 'i'||key == 'I'){
    if (screen == "start"){
      screen = "play";
    }
    else if (screen == "play"){
      screen = "end";
      try {
        for (int i = blocks.size() - 1; i >= 0; i -= 1){
          blocks.remove(i);
        }
      } catch (IndexOutOfBoundsException e){
        print("that was a close one");
      }
    }
    else if (screen == "end"){
      screen = "start";
    }
  }
}

//saves highscore to text file before game closes by any means
private void prepareExitHandler () {

Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {

public void run () {

System.out.println("SHUTDOWN HOOK");
  
  print("saving highscore...");
  highscoreFile.println(highscore);
  highscoreFile.flush();
  highscoreFile.close();
  println("complete");
  exit();

}

}));

}
