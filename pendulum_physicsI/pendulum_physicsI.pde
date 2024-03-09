import peasy.*;

PeasyCam cam;

 boolean dragging;

 int N=100;
 float x[] = new float[N];
 float y[] =new float[N];
 float z[] = new float[N];
 float G=0.05;

  class vec {
    float x = 0.0; 
    float y = 0.0;  
    float z = 0.0; 
    
    
    vec(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    }
  }
 
  vec [] pos_vec = new vec[N];
  vec [] vel_vec = new vec[N];
  vec [] acc_vec = new vec[N];
  
  float [] acc_mag = new float[N];
  float [] m = new float[N];
  
  
  
  
  float distSq=0.0, dist=0.0, accMag=0.0, temp_vx=0.0, temp_vy=0.0, temp_vz=0.0;
  
  float dt=0.0;

void setup() {
   size(800 ,800, P2D);
  //cam = new PeasyCam(this, 800);
  //cam.lookAt(0, 0, 0);
  
  for(int i = 0; i<N ; i++){
    pos_vec[i]= new vec(8.0*i+5.0, 80*sin(2*PI*(4*i)/N)*exp(-pow(i-N/2,2)) + width/2, 0.0);
    //vel_vec[i]= new vec(0.0,0.0, 0.0);
    vel_vec[i]= new vec(0.0,0.0,0.0);
    acc_vec[i]= new vec(0.0,0.0,0.0);
    //m[i]= random(100000, 2000000);
    m[i]=100000.0;
  }
  pos_vec[0].y= width/2;
  pos_vec[N-1].y= width/2;
  
  //m[0]=10000000;
}
void draw() {
  //rotateX(0.5);
  //rotateY(-.5);
  background(0);
     
  dt=0.1;

  
 
  if(dragging){
    
        pos_vec[N/2].x=mouseX;
        pos_vec[N/2].y=mouseY;
    
    
  
  }
  
    solver();
    renderer(false);
   
}



void mousePressed() {
  // Check if the mouse is pressed within the boundaries of the poin
    dragging = true; // Start dragging the point
}

void mouseReleased() {
  dragging = false; // Stop dragging the point when the mouse is released
}

void elasticForce(float k, float R){
  float distL,distR;
  for(int i=1;i<N-1; i++){
    
        //distL=sqrt(pow(pos_vec[i].x-pos_vec[i+1].x,2)+pow(pos_vec[i].y-pos_vec[i+1].y,2));
        //distR=sqrt(pow(pos_vec[i].x-pos_vec[i-1].x,2)+pow(pos_vec[i].y-pos_vec[i-1].y,2));
        
    acc_vec[i].x=0.0;
        //acc_vec[i].x= -k*(pos_vec[i].x-pos_vec[i+1].x + pos_vec[i].x-pos_vec[i-1].x) - R*vel_vec[i].x;
        acc_vec[i].y= -k*(pos_vec[i].y-pos_vec[i+1].y + pos_vec[i].y-pos_vec[i-1].y) - R*vel_vec[i].y;



  }
  
  
  
}

void solver(){
  //println("calculating.....");
  
  float R=0.7, rx, lx, ry, ly,  rz, lz, r;
  elasticForce(20, 0.01);
 
   
  for (int i=0;i<N;i++){
  
   
    //println(vel_vec[i].x, vel_vec[i].y, vel_vec[i].z );
    
   // if(!dragging){
     vel_vec[i].x=vel_vec[i].x+acc_vec[i].x*dt;
    
    vel_vec[i].y=vel_vec[i].y+acc_vec[i].y*dt;
    
    vel_vec[i].z=vel_vec[i].z+acc_vec[i].z*dt;  
      
      
    pos_vec[i].x=pos_vec[i].x+vel_vec[i].x*dt;
    
    pos_vec[i].y=pos_vec[i].y+vel_vec[i].y*dt;
    
    pos_vec[i].z=pos_vec[i].z+vel_vec[i].z*dt;
  }
    
  
 // }
    
    //println(pos_vec[i].x, pos_vec[i].y, pos_vec[i].z );

}

void renderer(boolean drawArrow)
{
 
  for (int i=0;i<N;i++){ 
    stroke(255);
    fill(255);
    circle(pos_vec[i].x, pos_vec[i].y,5);
    drawCurve();
    
    
    if(drawArrow){
    fill(0,255,0);
    strokeWeight(2);
    stroke(255,0,0);
    drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 1/5.0*acc_vec[i].x,pos_vec[i].y+1/5.0*acc_vec[i].y);
    
    if(!dragging){
    stroke(0,0,255);
    drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 1/5.0*vel_vec[i].x,pos_vec[i].y+1/5.0*vel_vec[i].y);
    }
    noStroke();
    noFill();
    
  
  }
  }
}
  
void drawCurve(){
  for (int i=0;i<N-1;i++){ 
    
    line(pos_vec[i].x, pos_vec[i].y,pos_vec[i+1].x, pos_vec[i+1].y);
  
  }
  noStroke();
   


}


void drawArrow(float x1, float y1, float x2, float y2) {
  float a = dist(x1, y1, x2, y2) / 50;
  pushMatrix();
  translate(x2, y2);
  rotate(atan2(y2 - y1, x2 - x1));
  triangle(- a * 2 , - a, 0, 0, - a * 2, a);
  popMatrix();
  line(x1, y1, x2, y2);  
}
