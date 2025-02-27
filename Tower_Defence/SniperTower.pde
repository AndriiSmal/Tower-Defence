public class SniperTower extends Tower {
  private int triangleArea = 15;
  SniperTower(float x, float y) {
    super(x, y, 100, 1);
    range = 150;
    damage = 2;
    
  }
  
  public void update() {
    if (cooldown > 0) cooldown--;
    
    Enemy target = findTarget();
    if (target != null) {
      attack(target);
    }
  }
  
  public void display() {
    fill(255, 200, 0);
    triangle(pos.x-triangleArea, pos.y+triangleArea, pos.x+triangleArea, pos.y+triangleArea, pos.x, pos.y-triangleArea);
    if(mouseX >= pos.x - triangleArea && mouseX <= pos.x + triangleArea && mouseY >= pos.y - triangleArea && mouseY <= pos.y + triangleArea){
    fill(0, 0);
    ellipse(pos.x, pos.y, range*2, range*2);
    }
  }
  
  public void upgrade() {
    if(level < 3 && money >= SNIPER_TOWER_UPGRADE_COSTS[level]) {
      money -= SNIPER_TOWER_UPGRADE_COSTS[level];
      level++;
      range *= 1.1;
      damage += 2;
    }
  }
  
  public void sell(){
    money += SNIPER_TOWER_SELL_COSTS[level];
  }
  
  Bullet createBullet(Enemy target) {
    return new SniperBullet(pos.x, pos.y, target, damage);
  }
  
  int getCooldown() { return 60; }
}
