class SniperTower extends Tower {
  SniperTower(float x, float y) {
    super(x, y, 100);
    range = 200;
    damage = 3;
  }
  
  void update() {
    if (cooldown > 0) cooldown--;
    
    Enemy target = findTarget();
    if (target != null) {
      attack(target);
    }
  }
  
  void display() {
    fill(255, 200, 0);
    triangle(pos.x-15, pos.y+15, pos.x+15, pos.y+15, pos.x, pos.y-15);
  }
  
  void upgrade() {
    if(level < 3) {
      level++;
      range *= 1.3;
      damage += 2;
    }
  }
  
  void sell(){
    money += SNIPER_TOWER_SELL_COSTS[level];
  }
  
  Bullet createBullet(Enemy target) {
    return new SniperBullet(pos.x, pos.y, target, damage);
  }
  
  int getCooldown() { return 60; }
}
