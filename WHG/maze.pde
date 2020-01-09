int shape[] = {2,1,3,1,4,1,5,2,5,3,5,4,5,5,5,6,5,7,6,2,7,2,8,2,9,2,10,2,11,2,12,2,13,1,14,1,15,1,16,1,17,1,18,2,18,3,18,4,18,5,18,6,18,7,17,8,16,8,16,8,15,8,14,7,14,6,14,5,14,4,14,3,13,8,12,8,11,8,10,8,9,8,7,8,6,9,5,9,4,9,3,9,2,9,1,8,1,7,1,6,1,5,1,4,1,3,1,2,8,8};
squares walls[];
class maze {
  //squares square;
  maze() {
    rect(100, 100, 500, 500) ;
    walls = new squares[shape.length/2];
    
  }
  void make() {
    

    int count = 0;
  for(int i = 0; i<shape.length-1;i+=2){
   walls[count] = new squares(shape[i]*100,shape[i+1]*100);
   count++;
  }
      fill(200);
      noStroke();
  rect(600,300,800,500);
  rect(500,800,200,100);
  rect(1300,200,200,100);
    fill(0,255,0,150);
    noStroke();
    rect(200,200,300,700);
    rect(1500,200,300,600);
    stroke(5);
  }
  void place(){
        fill(200);
  for(int i = 0; i<walls.length;i++){
   walls[i].place();
  
  }
    fill(0,255,0,150);
    noStroke();
    rect(200,200,300,700);
    rect(1500,200,300,600);
    stroke(5);
  }
}
