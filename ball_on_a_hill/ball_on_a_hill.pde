/**
 * Mouse 2D.
 *
 * Moving the mouse changes the position and size of each box.
 */

int N =600, M=2, step=20;

float P[][] = new float[N][N];

float dt=0.0, maxPot=0.0, lim=1000.0;

float xoff = 0;

float R=0.99;

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

vec [][] color_vec  = new vec[N][N];

vec [] hill = new vec[N];


void setup() {
  size(600, 600);
  loadPixels();

  for (int i = 0; i<M; i++) {
    pos_vec[i]= new vec(300,100,0);
    //vel_vec[i]= new vec(0.0,0.0, 0.0);
    vel_vec[i]= new vec(0.0, 0.0, 0.0);
    acc_vec[i]= new vec(0.0, 0.0, 0.0);
    
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

  dt=0.4;


 terrain(true);
  
  Potential(0.0, 600.0);
  Force();
  //ForceField(15);
  solver();
  colorMap(false);
  
  
  drawObject(12);
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


void Potential(float x0, float y0) {
  float N_ = N, p;
  // i index is y axis.
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      P[i][j]=265*float(i)/N_;
      //println(i, j, abs(P[j][i]));
    }
  }
}

void Force() {
  float N_ = N, p, theta=0.0, FMagSq=0.0;
  for (int j=1; j<N-1; j++) {
    for (int i=1; i<N-1; i++) {
      F[i][j].x=(P[i+1][j]-P[i][j]);
      F[i][j].y=(P[i][j+1]-P[i][j]);
      
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
      color_vec[i][j].x = (P[i][j]); //red
      color_vec[i][j].y = 0.0; // green;
      color_vec[i][j].z = 255-(P[i][j]);  //blue
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

    //acc_vec[i].x= F[300][ceil(pos_vec[i].x)].x;
    acc_vec[i].y= 9.8*F[ceil(pos_vec[i].y)][200].x;
    posIdx_x= ceil(pos_vec[i].x);
   
    posIdx_y=ceil(pos_vec[i].y);
     
    println(hill[posIdx_x].y);
 

    vel_vec[i].x=vel_vec[i].x+acc_vec[i].x*dt;

    vel_vec[i].y=vel_vec[i].y+acc_vec[i].y*dt;

    vel_vec[i].z=vel_vec[i].z+acc_vec[i].z*dt;


    pos_vec[i].x=pos_vec[i].x+vel_vec[i].x*dt;

    pos_vec[i].y=pos_vec[i].y+vel_vec[i].y*dt;
    if (pos_vec[i].y>(hill[posIdx_x].y-6)) {
      pos_vec[i].y=hill[posIdx_x].y-7;
      vel_vec[i].y=-R*vel_vec[i].y;
      vel_vec[i].x=random(-20,20);
    }
    if (pos_vec[i].x>600-6) {
       pos_vec[i].x=600-7;
      vel_vec[i].x=-R*vel_vec[i].x;
      //vel_vec[i].x=20*noise(float(i),-1,1);
    }
    else if(pos_vec[i].x<6){
       pos_vec[i].x=7;
      
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

void drawObject(float radius){

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
