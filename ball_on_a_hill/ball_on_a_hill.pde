/**
 * Mouse 2D.
 *
 * Moving the mouse changes the position and size of each box.
 */

int N =600, M=4000, step=20;

float P[][] = new float[N][N];
float H[][] = new float[N][N];


float hill2D[][] = new float[N][N];

float dt=0.0, maxPot=0.0, lim=1000.0;

float xoff = 0;

float R=1, radius=2.0;

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

vec [][] F = new vec[N][N];
vec [] pos_vec = new vec[M];
vec [] vel_vec = new vec[M];
vec [] acc_vec = new vec[M];
float [] mass = new float[M];

vec [][] color_vec  = new vec[N][N];

vec [] hill = new vec[N];


void setup() {
  size(600, 600);
  loadPixels();

  for (int i = 0; i<M; i++) {
    pos_vec[i]= new vec(noise(i)*600,100,0);
    //vel_vec[i]= new vec(0.0,0.0, 0.0);
    vel_vec[i]= new vec(0.0, 0.0, 0.0);
    acc_vec[i]= new vec(0.0, 0.0, 0.0);
    
    mass[i] = 1.0;//20*noise(i);
    
  }
  
  for(int i=0;i<N;i++){
    hill[i]= new vec(0,0,0);
    
  }
  //creates the hill.
  terrain(false);
  
  for (int i = 0; i<N; i++) {
    for (int j = 0; j<N; j++) {

      F[i][j]= new vec(0.0, 0.0, 0.0);
      color_vec[i][j]= new vec(0.0, 0.0, 0.0);
    }
  }

  maxPot = 5.0/(2*sqrt(1/float(N)));
  println(maxPot);
}







void draw() {
  background(0);
  //fill(255, 204);

  dt=0.01;



  terrain2D();
  //Potential(0.0, 600.0);
  //Potential_hill();
  Force();
  //
  solver();
  //colorMap(true);
  //ForceField(15);
   
  
  
  drawObject();
}



void terrain(boolean drawHill){
  float n=0.0, n1=0.0;
  for(int i=0;i<N;i++){
    if(drawHill==false){
    n  = noise(xoff,0,1);
    xoff= xoff+0.002;
    n1 = noise(xoff,0,1);
    
    hill[i].x=i;
    hill[i].y=600-n1*600;
    
    }
    else {
    stroke(200);
    if(i<N-1){
    line(hill[i].x, hill[i].y, hill[i+1].x, hill[i+1].y);}
    noStroke();
    }
    

  }
}


void terrain2D(){
  float n=0.0, n1=0.0, xoff=0.0, yoff=0.0, scale=  200.0;
  for(int i=0;i<N;i++){
    
    for(int j=0;j<N;j++){
    
       n1  = noise(i/scale,j/scale);
       //println(n1);
       hill2D[i][j]= 255*n1;
    
    }
  }
}




void Potential(float x0, float y0) {
  float N_ = N, p;
  // i index is y axis.
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      P[i][j]=255*float(i)/N_;
      //println(i, j, abs(P[j][i]));
    }
  }
}

void Potential_hill(){
  float N_ = N, p;
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++){
       
      H[i][j] = 255*exp(-pow(i-hill[j].y,2)/1000.0);
     // println(H[i][j]);

    }
  }
}

void Force() {
  float N_ = N, p, theta=0.0, FMagSq=0.0;
  for (int j=1; j<N-1; j++) {
    for (int i=1; i<N-1; i++) {
      //F[i][j].x=(P[i+1][j]-P[i][j])-(H[i+1][j]-H[i][j]);
      //F[i][j].y=(P[i][j+1]-P[i][j])-(H[i][j+1]-H[i][j]);
      
      F[i][j].x = hill2D[i+1][j]-hill2D[i][j];
      F[i][j].y = hill2D[i][j+1]-hill2D[i][j];
      
      FMagSq=sqrt(pow(F[i][j].x, 2)+pow(F[i][j].y, 2));
      
      F[i][j].x= F[i][j].x/FMagSq;
      F[i][j].y= F[i][j].y/FMagSq;
      

      
    }
  }
}



void colorMap(boolean render) {
  // Loop through every pixel
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      // Create a grayscale color based on random number
      color_vec[i][j].x = (hill2D[i][j]); //red
      color_vec[i][j].y = 0.0; // green;
      color_vec[i][j].z = 255-(hill2D[i][j]);  //blue
      if(render==true){
      color c = color(color_vec[i][j].x, color_vec[i][j].y, color_vec[i][j].z);
      // Set pixel at that location to random color
      //println(255*60/(P[i][j]),0.0, 255*abs(1-60/(P[i][j])));
      
          pixels[j+i*N] = c;}
    }
  }
  if(render==true){    
      updatePixels();
  }
}


void solver() {
  //println("calculating.....");

  float R=0.7, rx, lx, ry, ly, rz, lz, r;
  //elasticForce(20, 0.01);

  Force();
  
  int posIdx_x=0, posIdx_y=0;


  for (int i=0; i<M; i++) {


    //println(vel_vec[i].x, vel_vec[i].y, vel_vec[i].z );

    // if(!dragging){
    posIdx_x= ceil(pos_vec[i].x);
   
    posIdx_y=ceil(pos_vec[i].y);
     

    acc_vec[i].x= 1/mass[i]*F[posIdx_y][posIdx_x].y;
    acc_vec[i].y= 1/mass[i]*F[posIdx_y][posIdx_x].x;
    
   // println(hill[posIdx_x].y);
 

    vel_vec[i].x=vel_vec[i].x+acc_vec[i].x*dt;

    vel_vec[i].y=vel_vec[i].y+acc_vec[i].y*dt;

    vel_vec[i].z=vel_vec[i].z+acc_vec[i].z*dt;


    pos_vec[i].x=pos_vec[i].x+vel_vec[i].x*dt;

    pos_vec[i].y=pos_vec[i].y+vel_vec[i].y*dt;
    if (pos_vec[i].y>(hill[posIdx_x].y-radius/2.0)) {
      pos_vec[i].y=hill[posIdx_x].y-radius/2.0-1;
      vel_vec[i].y=-R*vel_vec[i].y;
      //vel_vec[i].x=random(-20,20);
    }
    else if(pos_vec[i].y<radius/2.0)
    {
      pos_vec[i].y= radius/2.0+1;
      vel_vec[i].y=-R*vel_vec[i].y;
      
    }
    
    
    if (pos_vec[i].x>600-radius/2.0) {
       pos_vec[i].x=600-radius/2.0-1;
      vel_vec[i].x=-R*vel_vec[i].x;
      //vel_vec[i].x=20*noise(float(i),-1,1);
    }
    else if(pos_vec[i].x<radius/2.0){
       pos_vec[i].x=radius/2.0+1;
      
      vel_vec[i].x=-R*vel_vec[i].x;
      //vel_vec[i].x=20*noise(float(i),-1,1);
    
    }

    pos_vec[i].z=pos_vec[i].z+vel_vec[i].z*dt;
  }


  // }

  //println(pos_vec[i].x, pos_vec[i].y, pos_vec[i].z );
}

void ForceField(float scale) {

  int R=0, G=0, B=0;

  for (int j = 0; j < N; j=j+step) {
    for (int i = 0; i < N; i=i+step) {

      //noFill();
      strokeWeight(2);
      R=int(color_vec[i][j].x);
      G=0;
      B=int(color_vec[i][j].z);

      stroke(R,G,B);
      stroke(255);
      //println(color_vec[i][j].x, 0.0, color_vec[i][j].z);

      drawArrow(j, i, j+ scale*F[i][j].y, i+scale*F[i][j].x);
      //stroke(0,0,255);
      //drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 5*vel_vec[i].x,pos_vec[i].y+5*vel_vec[i].y);
      //noStroke();

      //fill(0,255,0);
      //strokeCap(ROUND);
        //strokeWeight(100);
      noStroke();
    }
  }
}

void drawObject(){

  for(int i=0;i<M;i++){
    stroke(200);
    circle(pos_vec[i].x, pos_vec[i].y, radius);
    noStroke();
  
  
  }
  


  }

void drawArrow(float x1, float y1, float x2, float y2) {
  float a = dist(x1, y1, x2, y2) / 10;
  pushMatrix();
  translate(x2, y2);
  rotate(atan2(y2 - y1, x2 - x1));
  triangle(- a * 2, - a, 0, 0, - a * 2, a);
  popMatrix();
  line(x1, y1, x2, y2);
}
