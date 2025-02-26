public class BasicTower extends Tower {
  private int squareArea = 15;
  BasicTower(float x, float y) {
    super(x, y, 50, 0);
    range = 100;
    damage = 1;
  }
  
  public void update() {
    if (cooldown > 0) cooldown--;
    
    Enemy target = findTarget();
    if (target != null) {
      attack(target);
    }
  }
  
  public void display() {
    fill(0, 150, 255);
    rect(pos.x-squareArea, pos.y-squareArea, 30, 30);
     if(mouseX >= pos.x - squareArea && mouseX <= pos.x + squareArea && mouseY >= pos.y - squareArea && mouseY <= pos.y + squareArea){
    fill(0, 0);
    ellipse(pos.x, pos.y, range*2, range*2);
    }
  }
  
  public void upgrade() {
    if(level < 4 && money >= BASIC_TOWER_UPGRADE_COSTS[level]) {
      money -= BASIC_TOWER_UPGRADE_COSTS[level];
      level++;
      range *= 1.2;
      damage++;
    }
  }
  
  public void sell(){
    money += BASIC_TOWER_SELL_COSTS[level];
  }
  
  public Bullet createBullet(Enemy target) {
    return new BasicBullet(pos.x, pos.y, target, damage);
  }
  
  public int getCooldown() { return 30; }
}
