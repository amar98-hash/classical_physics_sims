
import peasy.*;

PeasyCam cam;

boolean dragging = false; 
int N=200;
  int _N=10;

 float[][] x = new float[2*N][2*N];
  float[][] y = new float[2*N][2*N];
  
   float[][] v_x = new float[2*N][2*N];
  float[][] v_y = new float[2*N][2*N];
  
  float[][] dist_x = new float[N-1][N-1];
  float[][] dist_y = new float[N-1][N-1];
  
  
  float[] z = new float[400];

  
  
  
  float [] px = new float[N];
  float [] py = new float[N];
  
  float cx,cy, t;
  
  float gx=0.0, gy=0.0;
  float vx=0.0, vy=0.0;
  float ax=50.0,ay = 50.0;
  
  
  
  
  //
  float[][] V = new float[N][N];
  //constants
  float G=400.0;
  
  
  

void setup() {
   size(800,800,P3D);
  cam = new PeasyCam(this, 800);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(800);
  cam.lookAt(200, 200, 0);
  
  for(int j=0; j<=2*N-1; j=j+1){
    for(int i=0; i<=2*N-1; i=i+1){
      x[i][j]=_N*(i-N); 
      y[i][j]=_N*(j-N);}}
  
  
  
 
}
void draw() {
  //rotateX(0.5);
  //rotateY(-.5);
  background(0);
     cx=N/2.0;
     cy=N/2.0;
     t=t+0.01;
   // evolver();
     gravPot(cx,cy, N/2.5, N/2.5,10,30);

   stroke(100);
   
   //_3DGrid(N,_N);
   _3DPotSurface(N,_N);
   
}


void _2DGridDist(){
  for(int j=0; j<2*N-1; j=j+1){
    for(int i=0; i<2*N-1; i=i+1){
     // dist_x[i][j]= abs((x[i]-x[i+1]));
    
    }
  

  }

} 

void _2DGridPoints(int N, int _N, float t) {
  float k=0.01;
  float dist;
  
  //static grid points.
  for(int j=0; j<=2*N-1; j=j+1){
    for(int i=0; i<=2*N-1; i=i+1){
      
      if(i>0 & j>0 & i<2*N-1 & j<2*N-1){
        
        v_x[i][j]=v_x[i][j]-k*((x[i][j]-x[i-1][j])+(x[i][j]-x[i+1][j]))*t;
        x[i][j]=x[i][j]+v_x[i][j]*t;
        
        //v_y[i][j]=-k*((y[i][j]-y[i-1][j])+(y[i][j]-y[i+1][j]))*t;
        //y[i][j]=y[i][j]+v_y[i][j]*t;
        
  
      }
      //z[i]=_N*(i-N); 
     
  
   }
  }
}
  
  

void _2DGridLines(int N, int _N) {
  for(int j=0; j<N; j=j+1){
   
   
     for(int i=0; i<N; i=i+1){
        line(x[i][j],y[i][j],x[i+1][j],y[i][j]);
        line(x[i][j],y[i][j],x[i][j],y[i+1][j]);
        
        line(x[i+1][j],y[i][j],x[i][j],y[i][j]);
        line(x[i][j+1],y[i][j],x[i+1][j],y[i][j]);
        
       
        //line(x[i+1],y[j+1], x[i],y[j+1]);
      }
      //y boundary
      //line(x[2*N-1],y[j],x[2*N-1],y[j+1]);
   }

  
  endShape();
  
 
}

void _3DPotSurface(int N, int _N) {
  for(int j=0; j<N-_N; j=j+_N){
     for(int i=0; i<N-_N; i=i+_N){
       for(int k=0; k<=_N; k=k+1){
        line(i+k,j,V[i+k][j],i+k+1, j, V[i+k+1][j]);
        line(i,j+k,V[i][j+k],i, j+k+1, V[i][j+k+1]);
        line(i+_N, j,V[i+_N][j], i+_N, j+1, V[i+_N][j+1]);
       } 
      }
      for(int k=0; k<=_N; k=k+1){
        line(N-_N, j+k,V[N-_N][j+k], N-_N, j+k+1, V[N-_N][j+k+1]);
      }
     }
     for(int i=0; i<N-_N; i=i+_N){
       for(int k=0; k<=_N; k=k+1){
        line(i+k,N-_N,V[i+k][N-_N],i+k+1, N-_N, V[i+k+1][N-_N]);
       } 
      }
  endShape();
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
  endShape();
}


void mousePressed() {
  // Check if the mouse is pressed within the boundaries of the poin
  
    dragging = true; // Start dragging the point
  
}

void mouseReleased() {
  dragging = false; // Stop dragging the point when the mouse is released
}




void gravPot(float cx, float cy,float dx, float dy, float M1, float M2){
  
  
  float dist1, dist2;
  
  for(float x=0; x<N; x++){
     for(float y=0; y<N; y++){
        dist1 = sqrt((x-cx)*(x-cx)+(y-cy)*(y-cy));
        dist2 = sqrt((x-dx)*(x-dx)+(y-dy)*(y-dy));
          V[int(x)][int(y)]=-G*(M1/dist1+M2/dist2);
          //println(V[int(x)][int(y)]);
     }
  
  }
  
  
 //for (int j!=i; j++) { 
  //V[i][j] = G*M/(sqrt((px[i]-px[j])^2+(py[i]-py[j])^2));
  
  
  
 //}
}


void gravForce(float cx, float cy, float px, float py){
  gx= -abs(V[int(cx)][int (cy)]-V[int(px)][int (cy)]);
  gy= -abs(V[int(cx)][int (cy)]-V[int(cx)][int (py)]);
}


void gravPotPlot(){
   for(int x=0; x<N; x++){
     for(int y=0; y<N; y++){
       stroke(255*abs(V[x][y])/10.0,255/(abs(V[x][y])/10.0),0); 
       //stroke(255); 
       point(_N*float(x),_N*float(y),abs(V[x][y]));
     }
   }
}


void solver(){
  println("calculating.....");
  if(ax<50.0 || ax>350 || ay<50.0 || ay>350){
    vx=-vx;
    vy=-vy;
  
  }
  vx=vx+gx*t;
  ax=ax+vx*t;
  vy=vy+gy*t;
  ay=ay+vy*t;
  
  
}

void evolver(){
  
  
  
  cx=100*cos(2*PI*t)+N/2.0;
  cy=100*sin(2*PI*t)+N/2.0;

}
