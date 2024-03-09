

class object {
  // The PShape object
  PShape s;
  // The location where we will draw the shape
  float x, y;  //2D for now.
  // Variable for simple motion
  float v_x, v_y;
  float acc_x, acc_y;

  object(PShape s_) {
    x = 0.0;
    y = 0.0; 
    s = s_;
    v_x = random(2, 6);
    v_y = random(0, 10);
    acc_x=0.0;
    acc_y=0.0;
  }
  
  // Simple motion
  void move() {
    x+=v_x+acc_x; //time step is just 1.
    if (x > width) {
      x = 0.0;
      acc_x=0.0;
    }
    
    y+=v_y+acc_y; 
    if (y > height) {
      y = 0.0;
      acc_y=0.0;
    }
    
  }
  
  // Draw the object
  void display() {
    pushMatrix();
    translate(x, y);
    shape(s);
    popMatrix();
  }
}
