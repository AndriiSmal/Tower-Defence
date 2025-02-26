abstract class Tower {
  PVector pos;
  float range;
  int damage;
  int cooldown;
  int level;
  int cost;
  int type;
  
  public Tower(float x, float y, int cost, int type) {
    pos = new PVector(x, y);
    level = 0;
    this.cost = cost;
    this.type = type;
  }
  
  abstract void upgrade();
  abstract void sell();
  abstract void update();
  abstract void display();
  
  void attack(Enemy target) {
    if (cooldown <= 0) {
      bullets.add(createBullet(target));
      cooldown = getCooldown();
    }
  }
  

  
  Enemy findTarget() {
    Enemy target = null;
    float closest = Float.MAX_VALUE;
    for (Enemy e : enemies) {
      float d = PVector.dist(pos, e.pos);
      if (d < range && d < closest) {
        closest = d;
        target = e;
      }
    }
    return target;
  }
  
  abstract Bullet createBullet(Enemy target);
  abstract int getCooldown();
}
