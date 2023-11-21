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

//block speed
float speed = 1.0;
//score
float score = 0.0;
float highscore = 0.0;

//timer for animation
int animTimer = 0;

//active screen, can be ("start", "play", "end")
String screen;

void setup(){
  size(800, 400);
  noStroke(); //turn off stroke
  rectMode(CENTER); //use centre mode for drawing rectangles
  
  blocks = new ArrayList<Block>();
  
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
    background(255);
    image(startBg, 0, 0);
    image(title, 0, 0);
    
    fill(1, 150, 255);
    rect(95, 110, 95, 30);
    
    textSize(32);
    fill(1, 97, 255);
    text(str(highscore), 50, 120); 
  }

//---------------------------------------------------------------------------|

  //PLAY STATE
  if (screen == "play"){
    background(255);
    
    image(playBg, 0, 0);
    
    printScore(score, highscore);
    
    if (score > highscore){
      highscore = score;
    }
    
    image(activeFrame, 0, height/3, width/8, height/4);
  }

//---------------------------------------------------------------------------|

  //END STATE
  if (screen == "end"){
    background(255);
    image(endBg, 0, 0);
    
    printScore(score, highscore);
    
    if (score > highscore){
      highscore = score;
    }
    
    image(activeFrame, 0, height/3, width/8, height/4);
  }
  
  for (int i = blocks.size() - 1; i >= 0; i -= 1){
      blocks.get(i).update();
      blocks.get(i).display();
      if(blocks.get(i).position.x <= 0){
        blocks.remove(i);
      }
      if (blocks.size() > 0){
        append(blockDist, dist(0, 200, blocks.get(i).position.x, blocks.get(i).position.y));
      }
      
    }
  blockDist = sort(blockDist);
  
}

void printScore(float s, float hs){
  textSize(64);
  fill(100);
  text(str(s), 40, 120); 
  
  textSize(64);
  fill(100, 50, 20);
  text(str(hs), 400, 120); 
}

boolean cast(String action){
  boolean blockHit = false; 
  if (action == "a"){
    activeFrame = wA;
  }
  if (action == "d"){
    activeFrame = wD;
  }
  return(blockHit);
}

void keyPressed() {
  
  if (key == 'a'||key == 'A'){
    if (!cast("a")){
      //stun player
    }
    animTimer = 5;
  }
  
  if (key == 'd'||key == 'D'){
    if (!cast("d")){
      //stun player
    }
    animTimer = 5;
  }
  
  if (key == 'p'||key == 'P'){
    highscoreFile.println(highscore);
    highscoreFile.flush();
    highscoreFile.close();
    exit();
  }
  
  if (key == 'o'||key == 'O'){
    score = 0;
    highscore = 0;
  }
  
  if (key == 'q'||key == 'Q'){
    blocks.add(new Block(800, random(0,400), speed));
  }
  
  if (key == 'i'||key == 'I'){
    if (screen == "start"){
      screen = "play";
    }
    else if (screen == "play"){
      screen = "end";
    }
    else if (screen == "end"){
      screen = "start";
    }
  }
}
