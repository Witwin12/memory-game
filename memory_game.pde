// witthawin thitichettrakul 
//ID: 6601012610148
//make multiplayer 
//make hint
//timer
int cols = 2;
int rows = 5;
int[][] myArray;
ArrayList<Integer> numbers = new ArrayList<Integer>();
boolean[] revealed;
boolean[] matched;
ArrayList<int[]> selected = new ArrayList<int[]>();
int delay = 1000;
boolean waiting = false;
int lastClickTime = 0;
int player1 = 0;//set score player 1 = 0
int player2 = 0;//set score plyer 2 = 0
boolean current_player = true; // true = player1 flase = player 2
int seconds = 0;
int mins = 0;
int hours = 0;

void setup() {
  size(600, 600);
  generateGrid();
}
void show_current_player(){
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(0);
  text("Player1:  " + player1, 100, 415);
  text("player2:  " + player2, 500, 415);
  if(current_player){
    text("player1's turn", 300, 415);
  }else{
    text("player2's turn", 300, 415);
  }
}
void ui_timer(){
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(0);
  text("Time:  " + hours+':' + mins+':' + seconds, 300, 465);
}
void timer(){
  delay(1000);
  seconds +=1;
  if (seconds == 60){
  seconds = 0;
  mins +=1;
}else if(mins == 60){
  mins = 0;
  hours +=1;}
}
void createModeButtons() {
  // Create buttons for easy, normal, hard modes
  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255, 100, 100);
  rect(20, 520, 160, 50); // Easy button
  fill(255);
  text("Easy", 100, 545);
  
  fill(100, 255, 100);
  rect(220, 520, 160, 50); // Normal button
  fill(255);
  text("Normal", 300, 545);
  
  fill(100, 100, 255);
  rect(420, 520, 160, 50); // Hard button
  fill(255);
  text("Hard", 500, 545);
}

void generateGrid() {
  numbers.clear(); // Clear the previous numbers
  myArray = new int[cols][rows];
  revealed = new boolean[cols * rows];
  matched = new boolean[cols * rows];
  
  int n = 1;
  if (cols == 4 && rows == 5) {
    n = 10;
  } else if (cols == 2 && rows == 5) {
    n = 5;
  } else if (cols == 8 && rows == 5) {
    n = 20;
  }

  for (int i = 1; i <= n; i++) {
    numbers.add(i);
    numbers.add(i);
  }

  java.util.Collections.shuffle(numbers);

  int index = 0;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      myArray[i][j] = numbers.get(index);
      revealed[index] = false;
      matched[index] = false;
      index++;
    }
  }
}

void draw() {
  background(220);
  createModeButtons();
  show_current_player();
  ui_timer();
  timer();
  float cellWidth = (width) / (float)cols;
  float cellHeight = (height - 200) / (float)rows;  // Reduce grid height to leave space for buttons
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * cellWidth;
      float y = j * cellHeight;
      int index = i * rows + j;
      //check if matched change color
      if (matched[index]) {
        fill(0, 255, 0);
      } else {
        fill(255);
      }
      
      stroke(0);
      rect(x, y, cellWidth, cellHeight);
      
      if (revealed[index] || matched[index]) {
        fill(0);
        textAlign(CENTER, CENTER);
        text(myArray[i][j], x + cellWidth / 2, y + cellHeight / 2);
      }
    }
  }
  
  if (waiting && millis() - lastClickTime > delay) {
    hideUnmatched();
    waiting = false;
  }
}

void mousePressed() {
  if (waiting) return;

  // Detect mode button clicks
  if (mouseY > 520 && mouseY < 570) {
    if (mouseX > 20 && mouseX < 180) {
      // Easy mode selected
      cols = 2;
      rows = 5;
      generateGrid();
      player1 = 0;
      player2 = 0;
      current_player = true;
      seconds = 0;
    } else if (mouseX > 220 && mouseX < 380) {
      // Normal mode selected
      cols = 4;
      rows = 5;
      generateGrid();
      player1 = 0;
      player2 = 0;
      current_player = true;
      seconds = 0;
    } else if (mouseX > 420 && mouseX < 580) {
      // Hard mode selected
      cols = 8;
      rows = 5;
      generateGrid();
      player1 = 0;
      player2 = 0;
      current_player = true;
      seconds = 0;
    }
    return; // Avoid selecting cells when clicking a mode button
  }
  
  float cellWidth = width / (float)cols;
  float cellHeight = (height - 200) / (float)rows;

  int i = int(mouseX / cellWidth);
  int j = int(mouseY / cellHeight);
  
  if (i < cols && j < rows) {
    int index = i * rows + j;

    if (!revealed[index] && !matched[index]) {
      revealed[index] = true;
      selected.add(new int[] { i, j, index });
      
      if (selected.size() == 2) {
        int[] first = selected.get(0);
        int[] second = selected.get(1);
        
        if (myArray[first[0]][first[1]] == myArray[second[0]][second[1]]) {
          matched[first[2]] = true;
          matched[second[2]] = true;
          selected.clear();
          if (current_player){
            player1 +=1;
            current_player = false;
          } else {
            player2 +=1;
            current_player = true;
          }
        } else {
          waiting = true;
          lastClickTime = millis();
        }
      if(current_player){
        current_player = false;
        } else{
        current_player = true;
        }
      }
    }
  }
}

void hideUnmatched() {
  int[] first = selected.get(0);
  int[] second = selected.get(1);
  
  revealed[first[2]] = false;
  revealed[second[2]] = false;
  
  selected.clear();
}
