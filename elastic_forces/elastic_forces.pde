import peasy.*;

PeasyCam cam;

boolean dragging = false; 


  int N=10;
  
  int _N=5;
  int n=100;
  int N_total=0, M_total=0;
  float dt=0.0;
  
  //constants
  float G=0.05;
  float k=0.1;
 
  
  
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
 
  vec [][] pos_vec = new vec[N][N];
  vec [][] vel_vec = new vec[N][N];
  vec [][] acc_vec = new vec[N][N];
  
  float [][] acc_mag = new float[N][N];
  float [] m = new float[N];
  
  
  
  
  float distSq=0.0, dist=0.0, accMag=0.0, temp_vx=0.0, temp_vy=0.0, temp_vz=0.0;



void setup() {
  size(800 ,800, P2D);
  //cam = new PeasyCam(this, 800);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(800);
  //cam.lookAt(0, 0, 0);
  
  stroke(255);
  for(int i = 0; i<N ; i++){
    for(int j = 0; j<N ; j++){
        pos_vec[i][j]= new vec(n*i,n*j, 0.0);
        //vel_vec[i]= new vec(0.0,0.0, 0.0);
        vel_vec[i][j]= new vec(0.0, 0.0,0.0);
        acc_vec[i][j]= new vec(0.0,0.0,0.0);
        
       
       
  
    }
  }


  
   
}
void draw() {
  //rotateX(0.5);
  //rotateY(-.5);
  background(0);
 
  dt=0.1;
solver();
   stroke(255);
   //_2DGrid(N,_N,n);
   
   //pushMatrix();
   //translate(width/3,height/3);
   renderer("_2D");
   //popMatrix();
   elasticForce();
   
   if(dragging==true){
     pos_vec[N/2-1][N/2-1].x= mouseX;
     pos_vec[N/2-1][N/2-1].y=  mouseY;
     
   
   }

}




void _2DGrid(int N, int _N, int n) {
  int m=0,i_cnt=0,j_cnt=0;
for(int k=0; k<1; k=k+_N){  //no effect for 2D
  for(int j=0; j<N; j=j+n){
     for(int i=0; i<N; i=i+n){    
          if(i<=N-n){        
           line(i,j,k,i+n, j, k);}
                 
          if(j<=N-n){     
            line(i,j,k,i, j+n, k);} 
     
   }   
 }
}
}

void mousePressed() {
  // Check if the mouse is pressed within the boundaries of the poin
    dragging = true; // Start dragging the point
}

void mouseReleased() {
  dragging = false; // Stop dragging the point when the mouse is released
}




void elasticForce(){
  float m=0.0, ax_1=0, distL=0.0, distR=0.0, distU=0.0, distD=0.0;
   for(int i=1;i<N-1;i=i+1){
    for(int j=1;j<N-1;j=j+1){
      //println(m);
      //circle(pos_vec[i][j].x,pos_vec[i][j].y,10);
      distL= sqrt(pow((pos_vec[i][j].x-pos_vec[i+1][j].x),2)+pow((pos_vec[i][j].y-pos_vec[i+1][j].y),2));
      distR= sqrt(pow((pos_vec[i][j].x-pos_vec[i-1][j].x),2)+pow((pos_vec[i][j].y-pos_vec[i-1][j].y),2));
      distU= sqrt(pow((pos_vec[i][j].x-pos_vec[i][j-1].x),2)+pow((pos_vec[i][j].y-pos_vec[i][j-1].y),2));
      distD= sqrt(pow((pos_vec[i][j].x-pos_vec[i][j+1].x),2)+pow((pos_vec[i][j].y-pos_vec[i][j+1].y),2));
      
      
      
      acc_vec[i][j].x= -k*abs(n-distL)*(pos_vec[i][j].x-pos_vec[i+1][j].x)/distL -k*abs(n-distR)*(pos_vec[i][j].x-pos_vec[i-1][j].x)/distR -0.7*vel_vec[i][j].x ; 
      acc_vec[i][j].y=-k*abs(n-distU)*(pos_vec[i][j].y-pos_vec[i][j-1].y)/distU -k*abs(n-distD)*(pos_vec[i][j].x-pos_vec[i][j+1].x)/distD- 0.7*vel_vec[i][j].y; 

      
   }
  }
}

void solver(){
  
  for(int i=0;i<N;i=i+1){
    for(int j=0;j<N;j=j+1){
      //println(m);
     
      pos_vec[i][j].x=pos_vec[i][j].x+vel_vec[i][j].x*dt;
      pos_vec[i][j].y=pos_vec[i][j].y+vel_vec[i][j].y*dt;
      vel_vec[i][j].x=vel_vec[i][j].x+acc_vec[i][j].x*dt;
      vel_vec[i][j].y=vel_vec[i][j].y+acc_vec[i][j].y*dt;  
   }
  } 
}

void renderer(String render_dim)

{

     for(int i=0;i<N;i=i+1){
    for(int j=0;j<N;j=j+1){
      //println(m);
      circle(pos_vec[i][j].x,pos_vec[i][j].y,10);
    
      if(i<=N-2){        
           line(pos_vec[i][j].x,pos_vec[i][j].y,0,pos_vec[i+1][j].x,pos_vec[i+1][j].y, 0);}
                
  
}}
  
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
