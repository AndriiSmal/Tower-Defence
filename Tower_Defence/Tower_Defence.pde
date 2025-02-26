ArrayList<Enemy> enemies;
ArrayList<Tower> towers;
ArrayList<Bullet> bullets;
int[][] grid;
int wave;
boolean placingTower;
int lives;
int money;
int score;
final color BASIC_TOWER_COLOR = #2196F3;
final color SNIPER_TOWER_COLOR = #FFC107;
final int BASIC_TOWER_COST = 50;
final int SNIPER_TOWER_COST = 100;
final int[] BASIC_TOWER_UPGRADE_COSTS = {100, 200, 400, 0};
final int[] SNIPER_TOWER_UPGRADE_COSTS = {150, 250, 450, 0};
final int[] BASIC_TOWER_SELL_COSTS = {35, 105, 245, 525};
final int[] SNIPER_TOWER_SELL_COSTS = {70, 175, 350, 665};
int currentTowerType; // 0 = Basic, 1 = Sniper
Tower selectedTower = null;
boolean keyRState = false;
PVector[] pathPoints = {
    new PVector(3*40, 15*40),
    new PVector(3*40, 3*40),
    new PVector(12*40, 3*40),
    new PVector(12*40, 12*40)
  };
boolean gameOver = false;
boolean showRetryButton = false;
final int BUTTON_WIDTH = 120;
final int BUTTON_HEIGHT = 40;
  
void setup() {
  size(800, 600);
  enemies = new ArrayList<Enemy>();
  towers = new ArrayList<Tower>();
  bullets = new ArrayList<Bullet>();
  grid = new int[width/40][height/40]; // Griglia 20x15
  wave = 0;
  lives = 10;
  money = 100;
  placingTower = false;
  
  grid[3][7] = 1;
  grid[3][3] = 1;
  grid[12][3] = 1;
  grid[12][12] = 1;
}

void draw() {
  if(!gameOver){
  background(#018525);
  
  drawGrid();
  
  drawPath();
  
  handleEnemies();
  
  handleBullets();
  
  handleTowers();
 
  drawHUD();
  
  if(keyRState){
    frameRate(240);
  }else{
    frameRate(60);
  }
  
  if (frameCount % 120 == 0) {
    spawnWave(wave);
    wave++;
  }
  if (lives <= 0) {
      gameOver = true;
      showRetryButton = true;
    }
  } else {
    drawGameOverScreen();
  }
}

void drawGameOverScreen() {
  background(0);
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(40);
  text("GAME OVER", width/2, height/2 - 60);
  textSize(24);
  text("Punteggio finale: " + (score), width/2, height/2 - 20);
  
  // Retry button
  if (showRetryButton) {
    fill(100);
    rect(width/2 - BUTTON_WIDTH/2, height/2 + 20, BUTTON_WIDTH, BUTTON_HEIGHT, 10);
    fill(255);
    textSize(20);
    text("Rigioca", width/2, height/2 + 40);
    
    // Exit button
    fill(100);
    rect(width/2 - BUTTON_WIDTH/2, height/2 + 80, BUTTON_WIDTH, BUTTON_HEIGHT, 10);
    fill(255);
    text("Esci", width/2, height/2 + 100);
  }
}

void mousePressed() {
  if (gameOver) {
    // controls pressing 
    if (mouseX > width/2 - BUTTON_WIDTH/2 && mouseX < width/2 + BUTTON_WIDTH/2) {
      if (mouseY > height/2 + 20 && mouseY < height/2 + 20 + BUTTON_HEIGHT) {
        resetGame();
      }
      else if (mouseY > height/2 + 80 && mouseY < height/2 + 80 + BUTTON_HEIGHT) {
        exit();
      }
    }
  } 
  else if (mouseButton == LEFT && placingTower) {
      Tower t = currentTowerType == 0 ? 
      new BasicTower(mouseX, mouseY) : 
      new SniperTower(mouseX, mouseY);
      if(isValidPosition(t) && money >= t.cost) {
        
          towers.add(t);
          money -= t.cost;
          placingTower = false;
      }
    else if(selectedTower != null) {
      selectedTower = null;
    }
  }
  else if(mouseButton == RIGHT) {
    // Selezione torre per upgrade
    selectedTower = null;
    for(Tower t : towers) {
      if(PVector.dist(t.pos, new PVector(mouseX, mouseY)) < 15) {
        selectedTower = t;
        break;
      }
    }
  }
}

void keyPressed() {
  if(key == '1') {
    currentTowerType = 0;
    placingTower = !placingTower;
  }
  else if(key == '2') {
    currentTowerType = 1;
    placingTower = !placingTower;
  }
  else if(key == 'u' && selectedTower != null) {
    selectedTower.upgrade();
  }
  else if(key == 'r') {
    keyRState = !keyRState;
  }
  else if (key == 's' && selectedTower != null) {
    selectedTower.sell();
    towers.remove(selectedTower);
  }
}


// FUNZIONI DI SUPPORTO

void drawGrid() {
  stroke(200);
  for (int i = 0; i < width; i += 40) {
    line(i, 0, i, height);
  }
  for (int j = 0; j < height; j += 40) {
    line(0, j, width, j);
  }
}

void drawPath() {
  int roadWidth = 80;

  // Start and end of the road
  noStroke();
  fill(50);
  for(int i = 0; i < pathPoints.length-1; i++) {
    PVector start = pathPoints[i];
    PVector end = pathPoints[i+1];
    
    // Main road segment 
    if(start.x == end.x) { // Verticale
      rect(start.x-roadWidth/2, min(start.y, end.y), roadWidth, abs(end.y-start.y));
    } else { // Orizzontale
      rect(min(start.x, end.x), start.y-roadWidth/2, abs(end.x-start.x), roadWidth);
    }
    
    // 90° angle
    if(i < pathPoints.length-2) {
      PVector next = pathPoints[i+2];
      if((start.x == end.x && end.y == next.y) || (start.y == end.y && end.x == next.x)) {
        rect(end.x-roadWidth/2, end.y-roadWidth/2, roadWidth, roadWidth);
      }
    }
  }

  // draw center line
  stroke(255); 
  strokeWeight(2);
  float dashLength = 15, gapLength = 15;
  for(int i = 0; i < pathPoints.length-1; i++) {
    PVector start = pathPoints[i], end = pathPoints[i+1];
    PVector dir = PVector.sub(end, start).normalize();
    float distance = PVector.dist(start, end);
    
    for(float d = 0; d < distance; d += dashLength + gapLength) {
      PVector dashStart = PVector.add(start, PVector.mult(dir, d));
      PVector dashEnd = PVector.add(start, PVector.mult(dir, d + dashLength));
      line(dashStart.x, dashStart.y, dashEnd.x, dashEnd.y);
    }
  }
}

void spawnWave(int w) {
  float enemySpawnCoefficient = 5;
  int enemiesToSpawn = 0;
  int spawnTimer = 0;
  int spawnDelay = (int)random(0, 5); // 15 frame (0.25 sec a 60 FPS)
  int waveSize = 1;
  waveSize = w * (int)enemySpawnCoefficient; // Numero totale di nemici per onda
  enemiesToSpawn = waveSize;
  
  if (enemiesToSpawn > 0) {
    if (spawnTimer <= 0) {
      // Scegli tipo di nemico casuale
      float r = random(1);
      if (r < 0.1) { // 10% nemici resistenti
        enemies.add(new Enemy(0.3, 20, 30, color(255, 100, 0)));
      } else if (r < 0.3) { // 20% nemici veloci
        enemies.add(new Enemy(1.0, 5, 20, color(0, 255, 0)));
      } else { // 70% nemici normali
        enemies.add(new Enemy(0.5, 10, 10, color(255, 0, 0)));
      }
      enemiesToSpawn--;
      spawnTimer = spawnDelay;
    } else {
      spawnTimer--;
    }
    enemySpawnCoefficient *= 2;
  }
}

void resetGame() {
  gameOver = false;
  showRetryButton = false;
  lives = 10;
  money = 100;
  wave = 1;
  score = 0;
  enemies.clear();
  towers.clear();
  bullets.clear();
  frameCount = 60;
}

void handleEnemies() {
  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();

    if (e.health <= 0 || e.pathIndex >= 4) {
      if (e.health <= 0) {
        money += 10;
        score += 1;
      } else {
        lives = max(0, lives - 1); // Impedisce vite negative
      }
      enemies.remove(i);
    }
  }
}

void handleTowers() {
  for (Tower t : towers) {
    t.update();
    t.display();
  }
}

void handleBullets() {
  for (int i = bullets.size()-1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.target == null) bullets.remove(i);
  }
}

void drawHUD() {
  fill(0);
  textSize(18);
  textAlign(BASELINE);
  text("Life: " + lives, 20, 30);
  text("Money: $" + money, 20, 60);
  text("Wave: " + wave, 20, 90);
  text("Score: " + score, 20, 120);
  if (placingTower) {
    if(currentTowerType == 0){
      fill(200, 225);
      rect(width-290, height-596, 280, 40);
      fill(0);
      text("Place basic tower (left mouse click)", width-280, 30);
    } else if(currentTowerType == 1){
      fill(200, 225);
      rect(width-290, height-596, 285, 40);
      fill(0);
      text("Place sniper tower (left mouse click)", width-280, 30);
    }
  }
  fill(200, 225);
  rect(width-160, height-80, 140, 60);
  fill(0);
  text("Towers:", width-150, height-65);
  text("1 - Basic ("+BASIC_TOWER_COST+"$)", width-150, height-45);
  text("2 - Sniper ("+SNIPER_TOWER_COST+"$)", width-150, height-25);
  
  // Draws info textbox of selected tower 
  if(selectedTower != null) {
    if(selectedTower.type == 0){
      fill(200, 200);
      rect(20, height-100, 250, 90);
      fill(0);
      text("Selected tower:", 30, height-80);
      text("Level: "+selectedTower.level, 30, height-60);
      if (selectedTower.level == 3) text("(max)", 90, height-60);
      text("Press U key to upgrade ("+BASIC_TOWER_UPGRADE_COSTS[selectedTower.level]+"$)", 30, height-40);
      text("Press S key to sell ("+BASIC_TOWER_SELL_COSTS[selectedTower.level]+"$)", 30, height-20);
    } else if(selectedTower.type == 1){
      fill(200, 200);
      rect(20, height-100, 250, 90);
      fill(0);
      text("Selected tower:", 30, height-80);
      text("Level: "+selectedTower.level, 30, height-60);
      if (selectedTower.level == 3) text("(max)", 90, height-60);
      text("Press U key to upgrade ("+SNIPER_TOWER_UPGRADE_COSTS[selectedTower.level]+"$)", 30, height-40);
      text("Press S key to sell ("+SNIPER_TOWER_SELL_COSTS[selectedTower.level]+"$)", 30, height-20);
    }  
  }
}

boolean isValidPosition(Tower t) {
  // Controllo bordi mappa
  if(t.pos.x < 40 || t.pos.x > width-40 || t.pos.y < 40 || t.pos.y > height-40) 
    return false;
  
  // Controllo collisione con la strada
  int roadWidth = 80;
  for(int i = 0; i < pathPoints.length-1; i++) {
    PVector start = pathPoints[i];
    PVector end = pathPoints[i+1];
    
    if(start.x == end.x) { // Segmento verticale
      if(abs(t.pos.x - start.x) < roadWidth/2 + 15 && 
         t.pos.y > min(start.y, end.y) - 15 && 
         t.pos.y < max(start.y, end.y) + 15) {
        return false;
      }
    } else { // Segmento orizzontale
      if(abs(t.pos.y - start.y) < roadWidth/2 + 15 && 
         t.pos.x > min(start.x, end.x) - 15 && 
         t.pos.x < max(start.x, end.x) + 15) {
        return false;
      }
    }
  }
  return true;
}
