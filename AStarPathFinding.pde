Graph graph;
int cols = 25;

void setup() {
  size(500, 500);
  background(255);
  //frameRate(4);
  
  graph = new Graph(cols);
}

void draw() {
  graph.displayGrid();
  //graph.displayLinks();
}

void mousePressed() {
  graph.selectSquare(mouseX, mouseY);
}
