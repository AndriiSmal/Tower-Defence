class Enemy {
  PVector pos;
  float speed;
  int health;
  int pathIndex;
  int reward;
  color col;
  
  Enemy(float spd, int hp, int rwd, color c) {
    pos = new PVector(120, height);
    speed = spd;
    health = hp;
    reward = rwd;
    col = c;
    pathIndex = 0;
  }
  
  void update() {
    // Segui il percorso
    PVector target = getNextPathPoint();
    PVector dir = PVector.sub(target, pos);
    dir.setMag(speed);
    pos.add(dir);
    
    if (PVector.dist(pos, target) < 2) {
      pathIndex++;
    }
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, 20, 20);
  }
  
 PVector getNextPathPoint() {
    // Mappa semplificata del percorso
    switch(pathIndex) {
      case 0: return new PVector(3*40, 7*40);
      case 1: return new PVector(3*40, 3*40);
      case 2: return new PVector(12*40, 3*40);
      case 3: return new PVector(12*40, 12*40);
      default: return pos.copy();
    }
  }
}
