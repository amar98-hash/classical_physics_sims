// A list of objects
ArrayList<object> objs;

// Three possible shapes
PShape[] shapes = new PShape[3];

void setup() {
  size(640, 360, P2D);
  
  shapes[0] = createShape(ELLIPSE,0,0,30, 30);
  shapes[0].setFill(color(255, 127));
  shapes[0].setStroke(false);
  
  //shapes[1] = createShape(ELLIPSE,0,0,30,30);
  //shapes[1].setFill(color(255, 127));
  //shapes[1].setStroke(false);
  
  //shapes[2] = createShape(ELLIPSE,0,0,30,30);
  //shapes[2].setFill(color(255, 127));
  //shapes[2].setStroke(false);
  
  
  
  // Make an ArrayList
  objs = new ArrayList<object>();
  
  for (int i = 0; i < 3; i++) {
  
    object p = new object(shapes[i]);        // Use corresponding PShape to create Polygon
    objs.add(p);
  }
  
  }
  
  
  
void draw() {
  background(102);

  // Display and move them all
  for (object obs : objs) {
    obs.display();
    obs.move();
  }
}
