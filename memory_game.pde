// Create by:Witthawin Thitichettrakul
// ID 6601012610148
// make animation
// change number to select mode easy cols = 2 rows = 5 normal cols = 4 rows = 5 hard cols = 8 rows = 5
int cols = 4;
int rows = 5;
int[][] myArray;
ArrayList<Integer> numbers = new ArrayList<Integer>();
boolean[] revealed;
boolean[] matched;
ArrayList<int[]> selected = new ArrayList<int[]>();
int delay = 1000;
boolean waiting = false;

void setup() {
  size(600, 600);
  myArray = new int[cols][rows];
  revealed = new boolean[cols * rows];
  matched = new boolean[cols * rows];

  int n = 1;// set default of n is 1
  if (cols == 4 & rows == 5){
  n = 10;
  };
  if(cols == 2 & rows == 5){
  n = 5;  
  };
  if(cols == 8 & rows == 5){
  n = 20;
  };
  // Generate two of each number from 1 to 10
  for (int i = 1; i <= n; i++) {
    numbers.add(i); // First instance of the number
    numbers.add(i); // Second instance of the number
  }
  
  // Shuffle the numbers array to randomize the order
  java.util.Collections.shuffle(numbers);
  
  // Initialize the 2D array with the shuffled numbers
  int index = 0;
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      myArray[i][j] = numbers.get(index);
      revealed[index] = false; // Initially, no cell is revealed
      matched[index] = false;  // Initially, no cell is matched
      index++;
    }
  }
}

void draw() {
  background(220);
  float cellWidth = width / (float)cols;
  float cellHeight = height / (float)rows;
  
  // Draw the 2D array as a table
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float x = i * cellWidth;
      float y = j * cellHeight;
      int index = i * rows + j;

      // If the number is matched, color it green
      if (matched[index]) {
        fill(0, 255, 0); // Green for matched
      } else {
        fill(255); // White for unmatched
      }
      
      stroke(0); // Black border
      rect(x, y, cellWidth, cellHeight);
      
      // If the cell is revealed or matched, show the number
      if (revealed[index] || matched[index]) {
        fill(0);
        textAlign(CENTER, CENTER);
        text(myArray[i][j], x + cellWidth / 2, y + cellHeight / 2);
      }
    }
  }
  
  // Handle delay after an unmatched pair
  if (waiting && millis() - lastClickTime > delay) {
    hideUnmatched();
    waiting = false;
  }
}

void mousePressed() {
  if (waiting) return; // Don't allow interaction during delay
  
  float cellWidth = width / (float)cols;
  float cellHeight = height / (float)rows;
  
  // Determine which cell was clicked
  int i = int(mouseX / cellWidth);
  int j = int(mouseY / cellHeight);
  
  if (i < cols && j < rows) {
    int index = i * rows + j;

    // If the cell is not yet matched or revealed, reveal it
    if (!revealed[index] && !matched[index]) {
      revealed[index] = true;
      selected.add(new int[] { i, j, index });
      
      // If two cells are selected, check if they match
      if (selected.size() == 2) {
        int[] first = selected.get(0);
        int[] second = selected.get(1);
        
        if (myArray[first[0]][first[1]] == myArray[second[0]][second[1]]) {
          // They match, mark them as matched
          matched[first[2]] = true;
          matched[second[2]] = true;
          selected.clear();
        } else {
          // They don't match, start delay to hide them
          waiting = true;
          lastClickTime = millis();
        }
      }
    }
  }
}

int lastClickTime = 0;

void hideUnmatched() {
  // Hide the two selected cells
  int[] first = selected.get(0);
  int[] second = selected.get(1);
  
  revealed[first[2]] = false;
  revealed[second[2]] = false;
  
  selected.clear();
}

  
