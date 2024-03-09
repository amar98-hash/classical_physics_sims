
import peasy.*;

PeasyCam cam;

boolean dragging = false; 
int N=1000;
  int _N=1;
  int scale=200;
  float r=5.0;
  float R=0.1;
  float dim=800;
  
  //boundary,
  float lx=0.0;
  float rx=dim;
  
  float ly=0.0;
  float ry=dim;
  
  float lz=0.0;
  float rz=dim;
 

 float x[] = new float[N];
 float y[] =new float[N];
 float z[] = new float[N];
 float G=0.05;
 
 
  
  float[][] i_x = new float[N*_N][N*_N];
  float[][] i_y = new float[N*_N][N*_N];
  
   float[][] v_x = new float[N*_N][N*_N];
  float[][] v_y = new float[N*_N][N*_N];
  
  float[][] dist_x = new float[N-1][N-1];
  float[][] dist_y = new float[N-1][N-1];
  
  

  
  
  
  float [] px = new float[N];
  float [] py = new float[N];
  
  float cx,cy, dt,t;
  
  float gx=0.0,gy=0.0;
  float vx=0.0,vy=0.0;
  float ax=50.0,ay = 50.0;

  float[][] V = new float[N][N];
  //constants
 
  
  
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

void setup() {
   size(800 ,800, P2D);
  //cam = new PeasyCam(this, 800);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(800);
  //cam.lookAt(0, 0, 0);
  for(int i = 0; i<N ; i++){
    pos_vec[i]= new vec( random(0, rx),random(0, rx), 0.0);
    //vel_vec[i]= new vec(0.0,0.0, 0.0);
    vel_vec[i]= new vec(random(10.0, 7.0), random(-40.0, 5.0),0.0);
    acc_vec[i]= new vec(0.0,0.0,0.0);
    
    //m[i]= random(100000, 2000000);
    m[i]=100000.0;
  
  }
  //m[0]=10000000;
  pos_vec[0].x=0;
   pos_vec[0].y=0;
    pos_vec[0].z=0;
   vel_vec[0].x=0.0;
   vel_vec[0].y=0.0;
   vel_vec[0].z=0.0;
  
}
void draw() {
  //rotateX(0.5);
  //rotateY(-.5);
  background(0);
     
     t=0.01;
   solver();
  
  
   
   
   
   renderer("_2D");
   
   
   
   //_3DPotSurface(N,_N);
   
}

void _3DGrid(int N, int _N) {
 for(int k=0; k<N; k=k+_N){ 
  for(int j=0; j<N; j=j+_N){
     for(int i=0; i<N; i=i+_N){
         for(int l=0; l<_N; l=l+1)
         {
           if(i!=N-_N ){
            line(i+l,j,k,i+l+1, j, k);}
           if(j!=N-_N ){
            line(i,j+l,k,i, j+l+1, k);}
            if(k!=N-_N ){
            line(i, j,k+l, i, j, k+l+1);}
         }
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

void gravForce(){
  
  
  
  
  for(int i=0;i<N;i++){
    for(int j=0;j<N;j++){
      if(i!=j){
         //println("......");
          //println("j:",j);
          //println("m:",m[j]);
         
        
          distSq = pow(pos_vec[j].x-pos_vec[i].x, 2)+ pow(pos_vec[j].y-pos_vec[i].y, 2) + pow(pos_vec[j].z-pos_vec[i].z, 2);
          dist   = sqrt(distSq);
          
          if(distSq>10*r*r){
            accMag = G*m[j]/(distSq*dist);
          
           }
           else{
           
             accMag=0.0;
                
           }
           temp_vx+= accMag*(pos_vec[j].x-pos_vec[i].x);
           temp_vy+= accMag*(pos_vec[j].y-pos_vec[i].y);
           temp_vz+= accMag*(pos_vec[j].z-pos_vec[i].z);
 
      } 
      
    } 
    acc_vec[i].x= temp_vx;
    acc_vec[i].y=  temp_vy;
    acc_vec[i].z= temp_vz;
    
    temp_vx=0.0;
    temp_vy=0.0;
    temp_vz=0.0;
    
  }  
}

void solver(){
  //println("calculating.....");

  gravForce();
 
  for (int i=0;i<N;i++){
    //println(i);
    //println(acc_vec[i].x, acc_vec[i].y, acc_vec[i].z);
    
    vel_vec[i].x=vel_vec[i].x+acc_vec[i].x*t;
    
    vel_vec[i].y=vel_vec[i].y+acc_vec[i].y*t;
    
    vel_vec[i].z=vel_vec[i].z+acc_vec[i].z*t;
    //println(vel_vec[i].x, vel_vec[i].y, vel_vec[i].z );
    
    
    pos_vec[i].x=pos_vec[i].x+vel_vec[i].x*t;
    
    pos_vec[i].y=pos_vec[i].y+vel_vec[i].y*t;
    
    pos_vec[i].z=pos_vec[i].z+vel_vec[i].z*t;
    
    //collision
    if(pos_vec[i].x>rx-r/2){
      vel_vec[i].x=-R*vel_vec[i].x;
      pos_vec[i].x=rx-r/2-1;
    }
    else if(pos_vec[i].x<lx+r/2){
      vel_vec[i].x=-R*vel_vec[i].x;
      pos_vec[i].x=lx+r/2+1;
    }
    
    
    if(pos_vec[i].y>ry-r/2){
      vel_vec[i].y=-R*vel_vec[i].y;
      pos_vec[i].y=ry-r/2-1;
    }
    else if(pos_vec[i].y<ly+r/2){
      vel_vec[i].y=-R*vel_vec[i].y;
      pos_vec[i].y=ly+r/2+1;
    }
    
    
    if(pos_vec[i].z>rz-r/2){
      vel_vec[i].z=-R*vel_vec[i].z;
      pos_vec[i].z=rz-r/2-1;
    }
   else if(pos_vec[i].z<lz+r/2){
      vel_vec[i].z=-R*vel_vec[i].z;
      pos_vec[i].z=lz+r/2+1;
    }
    
    //interparticle collision
    for(int j=0;j<N;j++){
      if(i!=j){
        if(distSq<=2*r){
             vel_vec[i].x=vel_vec[j].x;
             vel_vec[i].y=vel_vec[j].y;
             vel_vec[i].z=vel_vec[j].z;
           
         }
           
         }   
     }
   
  }
    
    //println(pos_vec[i].x, pos_vec[i].y, pos_vec[i].z );

}

void renderer(String render_dim)
{
  noStroke();
  for (int i=1;i<N;i++){
    //fill(m[i]/420*255,255, 255- m[i]/420*255);

    fill(255);
    //strokeCap(ROUND);
    //strokeWeight(100);
    if(render_dim=="_3D"){
    //pushMatrix();
    //translate(pos_vec[i].x, pos_vec[i].y,pos_vec[i].z);
   // sphere(r);
    
    //popMatrix();
    //noFill();
    //strokeWeight(2);
    //stroke(255,0,0);
    //drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 5*acc_vec[i].x,pos_vec[i].y+5*acc_vec[i].y);
    //stroke(0,0,255);
    //drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 5*vel_vec[i].x,pos_vec[i].y+5*vel_vec[i].y);
    //noStroke();
  
   
   //fill(0,255,0);
    //strokeCap(ROUND);
    //strokeWeight(100);
    //pushMatrix();
    //translate(pos_vec[0].x, pos_vec[0].y,pos_vec[0].z);
    //sphere(5*r);
    
    //popMatrix();
  }
    
  
  if(render_dim=="_2D"){
    
    circle(pos_vec[i].x, pos_vec[i].y,r);
    
    
   
    //noFill();
    //strokeWeight(2);
    //stroke(255,0,0);
    //drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 5*acc_vec[i].x,pos_vec[i].y+5*acc_vec[i].y);
    //stroke(0,0,255);
    //drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 5*vel_vec[i].x,pos_vec[i].y+5*vel_vec[i].y);
    //noStroke();
  
   fill(0,255,0);
    //strokeCap(ROUND);
    //strokeWeight(100);
    
   circle(pos_vec[0].x, pos_vec[0].y,5*r);
  
  }
}
  
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
