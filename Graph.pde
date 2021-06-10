public class Graph {
  private float[][] adM;
  private int numOfNodes;
  
  private int startingNode;
  private int destination;
  
  private boolean[] visited;
  private float[] tentative;
  private int[] fromList;
  private int[] pathList;
  
  private int cellW = 500 / cols;
  private int pathNodeCount = 0;

  Graph(int cols) {
    this.numOfNodes = cols*cols;
    
    adM = new float[this.numOfNodes][this.numOfNodes];
    visited = new boolean[this.numOfNodes];
    
    startingNode = -1;
    destination = -1;

    initialisePathList();
    initialiseMatrix(); // Fill adjacency matrix with node link data
  }
  
  
  

  private void initialiseMatrix() {
    int currentNode = 0; // indicator for keeping track of which node we're on

    // for each node in graph
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < cols; j++) {
        // link nodes with their neighbours:
        if (currentNode < this.numOfNodes - 1) {     // if not in bottom right
          if ((currentNode + 1) % cols == 0) {       // if currentNode is on right side of the grid
            // link with node under it
            this.addEdge(currentNode, currentNode + cols, false);     // +cols for cell on next row in same column
          } else if (currentNode >= cols * (cols - 1)) {       // on bottom edge of grid
            this.addEdge(currentNode, currentNode + 1, false);
          } else {                                         
            // every other node (link to right/bottom/bottom-right)
            this.addEdge(currentNode, currentNode + 1, false);           // right
            this.addEdge(currentNode, currentNode + cols, false);        // bottom
            this.addEdge(currentNode, currentNode + (cols + 1), true);  // bottom-right
            this.addEdge(currentNode + 1, currentNode + cols, true);    // right to bottom
          }
        }
        currentNode++; // go to next node
      }
    }
  }

  private void addEdge(int currentNode, int neighbour, boolean diagonal) {
    if (!diagonal) {
      if (currentNode != neighbour) {
        adM[currentNode][neighbour] = 1;
        adM[neighbour][currentNode] = 1;
      }
    } else {
      if (currentNode != neighbour) {
        adM[currentNode][neighbour] = 1.4142;
        adM[neighbour][currentNode] = 1.4142;
      }
    }
  }
  
  private boolean isVisited(int node) {
    return visited[node];
  }
  
  private boolean isInPath(int node) {
    if (pathList != null) {
      for (int i = 0; i < pathList.length; i++) {
        if (pathList[i] == node) {
          return true;
        }
      }
    }
    return false;
  }

  public void displayGrid() {
    // draw grid
    stroke(49,80,90);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < cols; j++) {
        int node = (i * cols) + j;
        if (node == startingNode) {
          fill(216,140,108);
        } else if (node == destination) {
          fill(186,110,78);
        } else if (isInPath(node)) {
          fill(89,150,143);
        } else if (isVisited(node)) {
          fill(154,201,175);
        } else
          fill(245,243,204);
          
        rect(cellW * j, cellW * i, cellW, cellW);
      }
    }
  }
  
  private void initialisePathList() {
    pathList = new int[this.numOfNodes];
    for (int i = 0; i < pathList.length; i++) {
      pathList[i] = -1;
    }
  }
  
  // removes empty elements from pathlist as pathlist is initialised with a high length to make sure it will fit the path generated
  private void shrinkPathList() {
    // remove unused length from pathlist
    int[] tempPathList = new int[pathNodeCount];
    for (int i = 0; i < pathNodeCount; i++) {
      tempPathList[i] = pathList[i];
    }
    pathList = tempPathList;
  }

  private void resetVisitedList() {
    for (int i = 0; i < visited.length; i++)
      visited[i] = false;
  }
  
  private void initialiseTentativeList() {
    tentative = new float[visited.length];
    for (int i = 0; i < tentative.length; i++)
      tentative[i] = Integer.MAX_VALUE;
    tentative[startingNode] = 0;
  }
  
  private void initialiseFromList() {
    fromList = new int[visited.length];
    for (int i = 0; i < fromList.length; i++)
      fromList[i] = -1;
    fromList[startingNode] = startingNode;
  }
  
  private boolean isAdjacent(int node1, int node2) {
    return (adM[node1][node2] != 0 && adM[node2][node1] != 0);
  }
  
  private float getWeight(int node1, int node2) {
    return adM[node1][node2];
  }
  
  private int findNewCurrent(int destination) {
    float minTentative = Integer.MAX_VALUE;
    int newCurrent = destination;
    
    for (int i = 0; i < tentative.length; i++) {
      if (!visited[i] && minTentative > tentative[i]) {
        minTentative = tentative[i];
        newCurrent = i;
      }
    }
    return newCurrent;
  }
  
  // get distance from node to destination
  private float getPotentialCost(int node, int dest) {
    // calculate node's grid coordinates from node number and same with destination
    int x1 = node / cols;
    int y1 = node % cols;
    int x2 = dest / cols;
    int y2 = dest % cols;
    
    return sqrt((x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1));
  }
  
  

  private void findPathDijkstra() {
    resetVisitedList();
    initialiseTentativeList();
    initialiseFromList();
    
    int currentNode = startingNode;
    
    while (currentNode != destination && tentative[currentNode] != Integer.MAX_VALUE) {
      visited[currentNode] = true;
      for (int i = 0; i < adM[0].length; i++) {
        if (!visited[i]
            && isAdjacent(currentNode, i)
            && tentative[i] > (tentative[currentNode] + getWeight(currentNode, i)) + getPotentialCost(currentNode, destination))
            {
              tentative[i] = tentative[currentNode] + getWeight(currentNode, i) + getPotentialCost(currentNode, destination);
              fromList[i] = currentNode;
            }
      }
      currentNode = findNewCurrent(destination);
    }
    
    // OUTPUTS:
    System.out.println("Start: " + startingNode + "      Dest: " + destination);
    
    // output path
    System.out.print(destination + " <- ");
    int prev = fromList[destination];
    while (prev != startingNode) {
      // add node to path list for displaying path
      pathList[pathNodeCount] = prev;
      pathNodeCount++;
      
      System.out.print(prev + " <- ");
      prev = fromList[prev];
    }
    System.out.print(prev);
    
    // remove unused pathlist elements
    shrinkPathList();
    
    // output total distance
    System.out.println("\nTotal Distance: " + tentative[destination]); //<>//
  }
  
  
  

  public void selectSquare(int x, int y) {
    if (startingNode == -1) {               // select starting point using first selected square
      // get node from mouseX and mouseY
      int coordX = x / cellW;
      int coordY = y / cellW;
      startingNode = (coordY * cols) + coordX; // get node number from x, y indexes (e.g: get node 5 from [2,1])
    }
    else if (startingNode != -1 && destination == -1) {      // select destination using second selected square
      // get node from mouseX and mouseY
      int coordX = x / cellW;
      int coordY = y / cellW;
      destination = (coordY * cols) + coordX; // get node number from x, y indexes (e.g: get node 5 from [2,1])
      
      findPathDijkstra();
    }
  }




  public void displayLinks() {
    // draw links
    stroke(255, 0, 0);
    for (int i = 0; i < adM[0].length; i++) {
      for (int j = 0; j < adM[0].length; j++) {
        if (adM[j][i] != 0) {
          int x1 = i / cols;
          int y1 = i % cols;
          int x2 = j / cols;
          int y2 = j % cols;
          line((x1 * cellW) + (cellW / 2),
               (y1 * cellW) + (cellW / 2),
               (x2 * cellW) + (cellW / 2),
               (y2 * cellW) + (cellW / 2));
        }
      }
    }
  }
}
