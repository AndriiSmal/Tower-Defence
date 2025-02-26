abstract class Bullet {
  PVector pos;
  Enemy target;
  float speed;
  int damage;
  
  public Bullet(float x, float y, Enemy t, int dmg) {
    pos = new PVector(x, y);
    target = t;
    speed = 5;
    damage = dmg;
  }
  
  abstract void update();
  abstract void display();
  
}
