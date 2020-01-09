class squares {
  int x, y;  

  squares(int x1, int y1) {
    x=x1;
    y=y1;
    strokeWeight(5);
    stroke(100);
    fill(100);
    rect(x, y, 100, 100);
    strokeWeight(2);
  }

  void place() {

    strokeWeight(5);
    fill(0);
    rect(x, y, 100, 100);
    strokeWeight(2);
  }

  boolean isTouching(int x1, int y1, int vx, int vy) {
    if ((x<=x1+vx&&x+100>=x1+vx&&y<=y1+vy&&y+100>=y1+vy)||(x<=x1+vx+pos.getSize()&&x+100>=x1+vx+pos.getSize()&&y<=y1+vy&&y+100>=y1+vy)||(x<=x1+vx&&x+100>=x1+vx&&y<=y1+vy+pos.getSize()&&y+100>=y1+vy+pos.getSize())||(x<=x1+vx+pos.getSize()&&x+100>=x1+vx+pos.getSize()&&y<=y1+vy+pos.getSize()&&y+100>=y1+vy+pos.getSize())) {
    //  if ((x<=x1 &&x+100>=x1 &&y<=y1 &&y+100>=y1 )||(x<=x1 +pos.getSize()&&x+100>=x1 +pos.getSize()&&y<=y1 &&y+100>=y1 )||(x<=x1 &&x+100>=x1 &&y<=y1 +pos.getSize()&&y+100>=y1 +pos.getSize())||(x<=x1 +pos.getSize()&&x+100>=x1 +pos.getSize()&&y<=y1 +pos.getSize()&&y+100>=y1 +pos.getSize())) {
    //  fill(255,0,0);
    //      rect(x, y, 100, 100);
    //strokeWeight(2);
      return true;
    }
    return false;
  }
    boolean isTouching(int x1, int y1, int vx, int vy, int x6) {
    if ((x<=x1+vx&&x+100>=x1+vx&&y<=y1+vy&&y+100>=y1+vy)) {
    //  if ((x<=x1 &&x+100>=x1 &&y<=y1 &&y+100>=y1 )||(x<=x1 +pos.getSize()&&x+100>=x1 +pos.getSize()&&y<=y1 &&y+100>=y1 )||(x<=x1 &&x+100>=x1 &&y<=y1 +pos.getSize()&&y+100>=y1 +pos.getSize())||(x<=x1 +pos.getSize()&&x+100>=x1 +pos.getSize()&&y<=y1 +pos.getSize()&&y+100>=y1 +pos.getSize())) {
    //  fill(255,0,0);
    //      rect(x, y, 100, 100);
    //strokeWeight(2);
      return true;
    }
    return false;
  }
  
  
    boolean isTouching(int x1, int y1, int vx,int vy , int c1,int c2, int c3) {
    if ((x<=x1+vx&&x+100>=x1+vx&&y<=y1+vy&&y+100>=y1+vy)||(x<=x1+vx+pos.getSize()&&x+100>=x1+vx+pos.getSize()&&y<=y1+vy&&y+100>=y1+vy)||(x<=x1+vx&&x+100>=x1+vx&&y<=y1+vy+pos.getSize()&&y+100>=y1+vy+pos.getSize())||(x<=x1+vx+pos.getSize()&&x+100>=x1+vx+pos.getSize()&&y<=y1+vy+pos.getSize()&&y+100>=y1+vy+pos.getSize())) {
    //  if ((x<=x1 &&x+100>=x1 &&y<=y1 &&y+100>=y1 )||(x<=x1 +pos.getSize()&&x+100>=x1 +pos.getSize()&&y<=y1 &&y+100>=y1 )||(x<=x1 &&x+100>=x1 &&y<=y1 +pos.getSize()&&y+100>=y1 +pos.getSize())||(x<=x1 +pos.getSize()&&x+100>=x1 +pos.getSize()&&y<=y1 +pos.getSize()&&y+100>=y1 +pos.getSize())) {
      fill(c1,c2,c3);
          rect(x, y, 100, 100);
    strokeWeight(2);
      return true;
    }
    return false;
  }
  
  int getX(){
   return x; 
  }
  int getY(){
   return y; 
  }
}
