class FastEnemy extends Enemy {
  FastEnemy() {
    super(1.5, 5+statsEnhancer, 20, #4CAF50); // (speed, HP, reward, color)
  }
  
  void display() {
    fill(col);
    rect(pos.x-10, pos.y-10, 20, 20);
  }
}
