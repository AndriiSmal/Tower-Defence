class TankEnemy extends Enemy {
  TankEnemy() {
    super(0.4, 30+statsEnhancer, 50, #9C27B0); // (speed, HP, reward, color)
  }
  
  void display() {
    fill(col);
    ellipse(pos.x, pos.y, 30, 30);
  }
}
