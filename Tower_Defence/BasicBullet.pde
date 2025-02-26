class BasicBullet extends Bullet {
  BasicBullet(float x, float y, Enemy t, int dmg) {
    super(x, y, t, dmg);
  }
  
  void update() {
    if (target != null) {
      PVector dir = PVector.sub(target.pos, pos);
      dir.setMag(speed);
      pos.add(dir);
      
      if (PVector.dist(pos, target.pos) < 10) {
        target.health -= damage;
        bullets.remove(this);
      }
    }
  }
  
  void display() {
    fill(255);
    ellipse(pos.x, pos.y, 5, 5);
  }
}
