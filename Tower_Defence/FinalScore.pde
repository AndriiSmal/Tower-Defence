class FinalScore {
  ArrayList<Integer> scores;
  ArrayList<String> names;
  String filePath = "scores.txt";
  
  FinalScore() {
    scores = new ArrayList<Integer>();
    names = new ArrayList<String>();
    loadScores();
  }
  
  void loadScores() {
    String[] lines = loadStrings(filePath);
    if(lines != null) {
      for(String line : lines) {
        String[] parts = split(line, ':');
        if(parts.length == 2) {
          names.add(parts[0]);
          scores.add(int(parts[1]));
        }
      }
    }
  }
  
  void saveScores() {
    String[] lines = new String[scores.size()];
    for(int i = 0; i < scores.size(); i++) {
      lines[i] = names.get(i) + ":" + scores.get(i);
    }
    saveStrings(filePath, lines);
  }
  
  void addScore(String name, int score) {
    int position = 0;
    while(position < scores.size() && scores.get(position) > score) {
      position++;
    }
    
    if(position < 5) {
      scores.add(position, score);
      names.add(position, name);
      
      if(scores.size() > 5) {
        scores.remove(5);
        names.remove(5);
      }
      saveScores();
    }
  }
  
  void display() {
    fill(255);
    textSize(24);
    textAlign(RIGHT);
    text("TOP 5 SCORES:", width-20, 200);
    
    textSize(20);
    for(int i = 0; i < min(scores.size(), 5); i++) {
      text(names.get(i) + " - " + scores.get(i), width-15, 250 + i*40);
    }
  }
}
