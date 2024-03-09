
int L=40,M=40,N=40;

int[][][] red_arr= new int[L][M][N];

int[][][] green_arr= new int[L][M][N];

int[][][] blue_arr= new int[L][M][N];



import peasy.*;

PeasyCam cam;


float t=0.0;

float w1=1.0, w2=10.0, w3=21.4;

void setup(){
  cam = new PeasyCam(this, 400);
   cam.lookAt(0, 0, 0);
   size(400, 400, P3D);
   noStroke();
colorMode(RGB, 400);
smooth(4);
   color_func();


}



void draw(){
background(0);



  
t++;  
//updatePixels();
_3D_Plot();



}

void color_func(){

  for(int k=0; k<N;k++){
    for(int j=0; j<M;j++){
      for(int i=0; i<L;i++){
          red_arr[i][j][k]=int(255*abs(exp(-(i*i+j*j+k*k))));
          green_arr[i][j][k]=int(255*abs(exp(-(i*i+j*j+k*k))));
          blue_arr[i][j][k]=int(255*abs(exp(-(i*i+j*j+k*k))));
      }
    }
  }
 }
 
 
 void _3D_Plot(){
blendMode(BLEND);

  for(int k=0; k<N;k++){
    for(int j=0; j<M;j++){
      for(int i=0; i<L;i++){
          stroke(red_arr[i][j][k],green_arr[i][j][k],blue_arr[i][j][k]);
          //strokeWeight(1);
          point(i,j,k);
          noStroke();
      }
    }
  }
 }
