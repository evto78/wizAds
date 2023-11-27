class Target{
  
  PImage target;
  
  PVector position;
  
  Target(float x, float y){
    
    position = new PVector(x, y);
    
    target = loadImage("Target.png");
    
  }
  
  void update(){
    
  }
  
  void display(){
    imageMode(CENTER);
    image(target, position.x, position.y, width/12, height/6);
    imageMode(CORNER);
  }
}
