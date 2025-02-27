class BossEnemy extends Enemy {
  BossEnemy() {
    super(0.2, 100+statsEnhancer, 200, #000000); // (speed, HP, reward, color)
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, 20, 20);
  }
}
