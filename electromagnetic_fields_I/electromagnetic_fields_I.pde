
import peasy.*;

PeasyCam cam;

int L=100,M=100,N=100;

float [][][] electric_pot = new float[L][M][N];

float [] x = new float[L]; 
float [] y = new float[M]; 
float [] z = new float[N]; 



//int[][][] green_arr= new int[L][M][N];

//int[][][] blue_arr= new int[L][M][N];

  
  //boundary,
  float lx=0.0;
  float rx=L;
  
  float ly=0.0;
  float ry=M;
  
  float lz=0.0;
  float rz=N;
  
  float G=0.05, R=0.6, r=10.0;  //coefficient of restitution.
  float distSq=0.0, dist=0.0, accMag=0.0, temp_vx=0.0, temp_vy=0.0, temp_vz=0.0;

float t=0.0;

  
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
  
  
  
  

void setup() {
   size(800 ,800, P3D);
  cam = new PeasyCam(this, 800);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(800);
  cam.lookAt(0, 0, 0);
   for(int i=0; i<L;i++){
      x[i]=(i-L/2.0)/float(L);     // 1/L = 0.01 step, 100 points., -50/100 to 50/100
      println(i,": ", x[i]);
   }
  
   for(int i=0; i<M;i++){
      y[i]=(i-M/2)/float(M);     // 1/M = 0.01 precision.
      println(i,": ",y[i]);
   }
  
   for(int i=0; i<N;i++){
      z[i]=(i-N/2)/float(N);     // 1/N = 0.01 precision.
      println(i,": ",z[i]);
   }
  
  
  for(int i = 0; i<N ; i++){
    pos_vec[i]= new vec( random(0, N),random(0, N), 0.0);
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
   //solver();
  
  
   
   
   
  // renderer("_2D");
  
  scalar_field(1,1,1,20.0);
 
   _2DGrid(20);
   
   
  
   
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


void _2DGrid(int _N) {
 stroke(200);
  for(int j=0; j<M; j=j+_N){
     for(int i=0; i<L; i=i+_N){
         for(int l=0; l<_N; l=l+1)
         {
           if(i!=L-_N ){
            line(i+l,j,electric_pot[i+l][j][0],i+l+1, j, electric_pot[i+l+1][j][0]);}
           if(j!=M-_N ){
            line(i,j+l,electric_pot[i][j+l][0],i, j+l+1, electric_pot[i][j+l+1][0]);}
            }
         }
     }
   noStroke();
 }



void scalar_field(float cx, float cy, float cz, float A){
  
  for(int k=0; k<N;k++){
    for(int j=0; j<M;j++){
      for(int i=0; i<L;i++){
          electric_pot[i][j][k]= A*cos(2*PI*x[i])*sin(2*PI*y[j]);
          //println(x[i], y[j], electric_pot[i][j][k]);
      }
    }
  }
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
