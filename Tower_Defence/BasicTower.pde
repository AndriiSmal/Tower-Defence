class BasicTower extends Tower {
  BasicTower(float x, float y) {
    super(x, y, 50, 0);
    range = 100;
    damage = 1;
  }
  
  void update() {
    if (cooldown > 0) cooldown--;
    
    Enemy target = findTarget();
    if (target != null) {
      attack(target);
    }
  }
  
  void display() {
    fill(0, 150, 255);
    rect(pos.x-15, pos.y-15, 30, 30);
  }
  
  void upgrade() {
    if(level < 3) {
      level++;
      range *= 1.2;
      damage++;
    }
  }
  
  void sell(){
    money += BASIC_TOWER_SELL_COSTS[level];
  }
  
  Bullet createBullet(Enemy target) {
    return new BasicBullet(pos.x, pos.y, target, damage);
  }
  
  int getCooldown() { return 30; }
}
