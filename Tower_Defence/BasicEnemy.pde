class BasicEnemy extends Enemy {
  BasicEnemy() {
    super(0.5, 10+statsEnhancer, 10, #F44336); // (speed, HP, reward, color)
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, 20, 20);
  }
}
