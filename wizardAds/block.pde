class Block {
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  int blockColor;
  
  float distanceToPlayer;
  
  Block(float x, float y, float speed){
    position = new PVector(x, y);
    velocity = new PVector(-speed, 0);
    acceleration = new PVector(-0.001, 0);
    
    blockColor = int(random(0,2));
    
    
  }
  
  void update(){
    velocity.add(acceleration);
    position.add(velocity);
    
    distanceToPlayer = position.x;
  }
  
  void display(){
    //outline
    if (blockColor == 1){
      fill (232,106,228);
    }
    if (blockColor == 0){
      fill (106,202,232);
    }
    rect(position.x, position.y, 45, 25);
    //inside block
    if (blockColor == 1){
      fill (252,126,248);
    }
    if (blockColor == 0){
      fill (126,222,252);
    }
    rect(position.x, position.y, 40, 20);
    //text
    if (blockColor == 1){
      fill (255,166,255);
      textSize(32);
      text("A", position.x-10, position.y+10);
    }
    if (blockColor == 0){
      fill (146,242,255);
      textSize(32);
      text("D", position.x-10, position.y+10);
    }
  }
}
