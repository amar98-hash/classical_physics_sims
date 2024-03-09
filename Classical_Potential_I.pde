/**
 * Mouse 2D.
 *
 * Moving the mouse changes the position and size of each box.
 */

int N =600, M=1, step=20;

float P[][] = new float[N][N];

float dt=0.0, maxPot=0.0, lim=1000.0;


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


void setup() {
  size(600, 600);
  loadPixels();

  for (int i = 0; i<M; i++) {
    pos_vec[i]= new vec(8.0*i+5.0, 80*sin(2*PI*(4*i)/M)*exp(-pow(i-M/2, 2)) + width/2, 0.0);
    //vel_vec[i]= new vec(0.0,0.0, 0.0);
    vel_vec[i]= new vec(0.0, 0.0, 0.0);
    acc_vec[i]= new vec(0.0, 0.0, 0.0);
  }
  for (int i = 0; i<N; i++) {
    for (int j = 0; j<N; j++) {

      F[i][j]= new vec(0.0, 0.0, 0.0);
    }
  }

  maxPot = 5.0/(2*sqrt(1/float(N)));
  println(maxPot);
}

void draw() {
  background(0);
  //fill(255, 204);

  dt=0.1;





  Potential(pos_vec[0].x, pos_vec[0].y);
  Force();
  ForceField();
  solver();
  //particle();
}

void Potential(float y0, float x0) {
  float N_ = N, p;

  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      P[i][j]=50.0/sqrt(pow(float(i)/N_-x0/N_, 2) + pow(float(j)/N_-y0/N_, 2));
      //println(P[i][j]);
    }
  }
}

void Force() {
  float N_ = N, p, theta=0.0;
  for (int j=1; j<N-1; j++) {
    for (int i=1; i<N-1; i++) {
      F[i][j].x=-(P[i+1][j]-P[i][j]);
      F[i][j].y=-(P[i][j+1]-P[i][j]);

      if (pow(F[i][j].x, 2)+pow(F[i][j].y, 2)>lim) {
        theta= atan2(F[i][j].y, F[i][j].x);
        F[i][j].x=20*cos(theta)  ;
        F[i][j].y= 20*sin(theta);
      }
    }
  }
}

void particle() {
  // Loop through every pixel
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      // Create a grayscale color based on random number
      color c = color(255-255*60/(P[i][j]), 0.0, 255*60/(P[i][j]));
      // Set pixel at that location to random color
      //println(255*60/(P[i][j]),0.0, 255*abs(1-60/(P[i][j])));
      pixels[j+i*N] = c;
    }
  }
  updatePixels();
}


void solver() {
  //println("calculating.....");

  float R=0.7, rx, lx, ry, ly, rz, lz, r;
  //elasticForce(20, 0.01);

  Force();


  for (int i=0; i<M; i++) {


    //println(vel_vec[i].x, vel_vec[i].y, vel_vec[i].z );

    // if(!dragging){

    acc_vec[i].x=0.0;
    acc_vec[i].y=9.8;

    vel_vec[i].x=vel_vec[i].x+acc_vec[i].x*dt;

    vel_vec[i].y=vel_vec[i].y+acc_vec[i].y*dt;

    vel_vec[i].z=vel_vec[i].z+acc_vec[i].z*dt;


    pos_vec[i].x=pos_vec[i].x+vel_vec[i].x*dt;

    pos_vec[i].y=pos_vec[i].y+vel_vec[i].y*dt;
    if (pos_vec[i].y>580) {
      vel_vec[i].y=-vel_vec[i].y;
      vel_vec[i].x=20.0;
    }
    if (pos_vec[i].x>580) {
      vel_vec[i].x=-vel_vec[i].x;
      vel_vec[i].x=-20.0;
    }

    pos_vec[i].z=pos_vec[i].z+vel_vec[i].z*dt;
  }


  // }

  //println(pos_vec[i].x, pos_vec[i].y, pos_vec[i].z );
}

void ForceField() {



  for (int j = 0; j < N; j=j+step) {
    for (int i = 0; i < N; i=i+step) {

      //noFill();
      //strokeWeight(2);
      stroke(255);
      drawArrow(j, i, j+ F[i][j].y, i+F[i][j].x);
      //stroke(0,0,255);
      //drawArrow(pos_vec[i].x, pos_vec[i].y,pos_vec[i].x+ 5*vel_vec[i].x,pos_vec[i].y+5*vel_vec[i].y);
      //noStroke();

      //fill(0,255,0);
      //strokeCap(ROUND);
      //strokeWeight(100);
    }
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
