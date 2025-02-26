class SniperBullet extends Bullet {
  SniperBullet(float x, float y, Enemy t, int dmg) {
    super(x, y, t, dmg);
    speed = 8;
  }
void update() {
    if (target != null) {
      PVector dir = PVector.sub(target.pos, pos);
      dir.setMag(speed);
      pos.add(dir);
      
      if (PVector.dist(pos, target.pos) < 10) {
        target.health -= damage;
        // Colpisce fino a 3 nemici
        for(int i = 0; i < 3 && i < enemies.size(); i++) {
          enemies.get(i).health -= damage;
        }
        bullets.remove(this);
      }
    }
  }
  
  void display() {
    fill(255, 255, 0);
    ellipse(pos.x, pos.y, 8, 8);
  }
}
