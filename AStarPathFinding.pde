Graph graph;
int cols = 20; // Edit this to change the number of columns

void setup() {
  size(500, 500);
  background(255);
  //frameRate(4);
  
  graph = new Graph(cols);
}

void draw() {
  graph.displayGrid();
  //graph.displayLinks(); // uncomment this to see a visualisation of the graph
}

void mousePressed() {
  graph.selectSquare(mouseX, mouseY);
}
