class balls{
  int speed;
  int xs,ys,xends,xstarts,sizes;
  int x,y,xend,xstart,size;
 balls(int x3, int x1, int y1, int x2){
speed = 10;
x=x3;
y=y1;
xend = x2;
xstart = x1;
size = 50;
ellipse(x,y,size,size);
 }
 void move(){
   x+=speed;
   fill(0,0,255);
   ellipse(x,y,size,size);
   if(x>xend-size/2||x<xstart+size/2){
    speed*=-1; 
   }
 }
   int getX(){
     return x;
 }
 int getY(){
 return y;
 }
 int getSize(){
 return size;
 }
 
  int getRad(){
 return size/2;
 }
 
 void reset(int x3, int x1, int y1, int x2){
x=x3;
y=y1;
xend = x2;
xstart = x1;
size = 50;
 }
}
