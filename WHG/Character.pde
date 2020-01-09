int closey; //<>// //<>// //<>// //<>//
int closex;
class box {
  int x, y, size;
  box() {
    x= 250;
    y = 250;
    size = 40;
    rect(x, y, size, size);
  }
  void place() {
    fill(255, 0, 0);
    rect(x, y, size, size);
  }
  boolean hasWon() {
    return (x>1500-size ? true:false) ;
  }

  void reset() {
    x= 250;
    y = 250;
    rect(x, y, size, size);
  }
  void move(int newX, int newY, int s) {
    boolean touching = false;
    for (int i = 0; i<walls.length; i++) {
      if (walls[i].isTouching(x, y, vx, vy)) {
        touching = true;
        break;
      }
    }
    if (!touching) {
      x+=newX;
      y+=newY;
    }
  }
  void setx(int newx) {
    x=newx;
  }
  void sety(int newy) {
    y=newy;
  }
  int getSize() {
    return size;
  }
  void move(int move, int speed, float arr[], int count) {
    switch(move) {
      case(0):
      vx=-speed;//left
      vy=0;
      break;       
      case(1):
      vx=speed;//right
      vy=0;
      break;
      case(2):
      vy=-speed;//up
      vx=0;
      break;
      case(3):
      vy=speed;//down
      vx=0;
      break;
    default:
      return;
    }

    boolean touching = false;
    for (int i = 0; i<walls.length; i++) {
      if (walls[i].isTouching(x, y, vx, vy)) {
        touching = true;
        break;
      }
    }
    textSize(60);
    if (!touching) {
      switch(move) {
        case(0):
        x+=-speed;//left
        text("L", 1950, 400);
        break;       
        case(1):
        x+=speed;//right
        text("R", 1950, 400);
        break;
        case(2):
        y+=-speed;//up
        text("U", 1950, 400);
        break;
        case(3):
        y+=speed;//down
        text("D", 1950, 400);
        break;
      }
    }
  }


  void death() {
    x=250;
    y=250;
  }

  boolean isTouching(int xpos, int ypos, int rad) {
    //int closey;
    //int closex;
    if (xpos<x&&ypos<y) {
      closex = x;
      closey = y;
    } else if (xpos>x+size&&ypos>y+size) {
      closex = x+size;
      closey= y+size;
    } else if (xpos<x&&ypos>y+size) {
      closex = x;
      closey= y+size;
    } else if (xpos>x+size&&ypos<y) {
      closex = x+size;
      closey= y;
    } else if (ypos<y&&xpos>=x&&xpos<=x+size) {
      closey= y;
      closex = xpos;
    } else if (ypos>y+size&&xpos>=x&&xpos<=x+size) {
      closey= y+size;
      closex = xpos;
    } else if (xpos<x) {
      closey= ypos;
      closex = x;
    } else if (xpos>x) {
      closey= ypos;
      closex = x+size;
    } else {
      closey= y;
      closex = x;
    }

    //ellipse(closex, closey, 5, 5);

    if (sqrt(sq(closex-xpos)+sq(closey-ypos))<rad) {
      return true;
    }


    return false;
  }

  float getScore(boolean show) {
    float score = 0;

    if (x< 505) {
      score += sqrt(sq(200-500)+sq(200 - 850)) - sqrt(sq(x-500)+sq(y - 850));
    } else {
      score +=  sqrt(sq(250-505)+sq(250 - 850));
      score+= sqrt(sq(200-1500)+sq(200 - 250)) -sqrt(sq(x-1500)+sq(y - 250));
    }
    if (x>600&&y<775) {
      score+=100 ;
    }
    score = score/((sqrt(sq(250-505)+sq(250 - 850)))+(sqrt(sq(200-1500)+sq(200 - 250)))+100);
    score*=100;
    if (show) {
      line(x, y, 1500, 250);
      textSize(50);
      text(score, 100, 100);
    }
    return score;
  }

  List<Float> getInputs(int px, int py) {

    //List<Float> past
    List<Float> inputs = new ArrayList<Float>();
    float shortestRight = 100000;
    float shortestLeft = 100000;
    float shortestUp = 100000;
    float shortestDown = 100000;
    float d1 = 100000;
    float d2 = 100000;
    float d3 = 100000;
    float d4 = 100000;
    float shortestRight2 = 700;
    float shortestLeft2 = 700;
    float shortestUp2 = 700;
    float shortestDown2 = 700;
    float up = -0;
    float down = -0;
    float left = -0;
    float right = -0;
    boolean found = false;
    boolean found1 = false;
    int current = x+size;
    int currenty = y; //<>//
    int setx = 0;
    int sety = 0;

   

    current = x+size;
    setx = 0;
    sety = 0;
found = false;
    while (current<width) {
      for (int i = 0; i <walls.length; i++) {
        if (walls[i].isTouching(current, y+size, 0, 0, 0)) { //<>//
          found = true;
          setx = walls[i].getX();
          break;
        }

        if (walls[i].isTouching(current, y, 0, 0, 0)) {
          setx = walls[i].getX();
          found = true;
          break; //<>//
        }
      }
      if (found&&shortestRight>current-x) {
        shortestRight = setx - x-size-5;
      }

      current+=20;
    }

    //for (balls b : ball) {
    //  if (b.getY()-b.getRad() <=y+size&&b.getY()+b.getRad()>=y) {
    //    if (shortestRight2>=b.getX()-x+size-100&&b.getX()>x) {
    //      shortestRight2 = b.getX()-x-size ;
    //    }
    //  }
    //}  
    for (balls b : ball) {
      if (b.getY()-b.getRad() <=y+size&&b.getY()+b.getRad()>=y) {
        if (shortestRight>=b.getX()-x+size-100&&b.getX()>x) {
          shortestRight = b.getX()-x-size ;
        } //<>//
      }
    }
    found1 = false;
    found = false;
    current = x;
    while (current>0) {
      for (int i = 0; i <walls.length; i++) {
        if (walls[i].isTouching(current, y+size, 0, 0, 0)&&!found) {
          found = true; //<>//
          setx = walls[i].getX();
          break;
        }
        if (walls[i].isTouching(current, y, 0, 0, 0)) {
          found = true;
          setx = walls[i].getX();
          break;
        }
      }
      if (found&&shortestLeft>current-x) {
        shortestLeft = x-100-setx-5;
      }
      current-=20;
    }

    //for (balls b : ball) {
    //  if (b.getY()-b.getRad() <=y+size&&b.getY()+b.getRad()>=y) {
    //    if (shortestLeft2>=x-100-b.getX()&&b.getX()<x) {
    //      shortestLeft2 = x-100-b.getX() ;
    //    } //<>//
    //  }
    //}
    for (balls b : ball) {
      if (b.getY()-b.getRad() <=y+size&&b.getY()+b.getRad()>=y) {
        if (shortestLeft>=x-100-b.getX()&&b.getX()<x) {
          shortestLeft = x-100-b.getX() ;
        }
      }
    } //<>//
    found1 = false;
    found = false;
    current = y+size;
    while (current<height) {
      for (int i = 0; i <walls.length; i++) {

        if (walls[i].isTouching(x+size, current, 0, 0, 0)&&!found) {
          found = true;
          setx = walls[i].getY();
          break;
        }
        if (walls[i].isTouching(x, current, 0, 0, 0)&&!found1) {
          found = true;
          setx = walls[i].getY();
          break;
        }
      }

      if (found&&shortestDown>current-x) {
        shortestDown = setx - y-size-5; //<>//
      }

      current+=20;
    } 

    //for (balls b : ball) {
    //  if (b.getX()-b.getRad() <=x+size&&b.getX()+b.getRad()>=x) {
    //    if (shortestDown2>=b.getY()-y&&b.getY()>y) {
    //      shortestDown2 = b.getY()  - y-size ; //<>//
    //    }
    //  }
    //}
    for (balls b : ball) {
      if (b.getX()-b.getRad() <=x+size&&b.getX()+b.getRad()>=x) {
        if (shortestDown>=b.getY()-y&&b.getY()>y) {
          shortestDown = b.getY()  - y-size ;
        }
      }
    }
    found1 = false;
    found = false;
    current = y;
    while (current>0) {
      for (int i = 0; i <walls.length; i++) {
        if (walls[i].isTouching(x+size, current, 0, 0, 0)&&!found) {
          found = true;
          setx = walls[i].getY();
          break;
        }

        if (walls[i].isTouching(x, current, 0, 0, 0)&&!found) {
          found = true;
          setx = walls[i].getY();
          break;
        }
      }

      if (found&&shortestUp>current-x) {
        shortestUp = y-setx-100-5;
      }
      current-=20;
    }

    //for (balls b : ball) {
    //  if (b.getX()-b.getRad() <=x+size&&b.getX()+b.getRad()>=x) {
    //    if (shortestUp2>=y-b.getY()-100&&b.getY()<y) {
    //      shortestUp2 = y-b.getY() ;
    //    }
    //  }
    //}
    for (balls b : ball) {
      if (b.getX()-b.getRad() <=x+size&&b.getX()+b.getRad()>=x) {
        if (shortestUp>=y-b.getY()-100&&b.getY()<y) {
          shortestUp = y-b.getY() ;
        }
      }
    }



    //if (x< 505) {
    //  endX= abs(x-500) +1000 ;
    //  endY = abs(y-850)+850-250;
    //} else {
    //  endX= abs(x-1500);
    //  endY = y-250;
    //}
    float w;
    float w1;

    if (x< 505) {
      w=float(550-x);
      w1=float(850-y);
    } else if (x>600&&y<775) {
      w = float(1350-x);
      w1 = float(250-y);
    } else {
      w=650-x;
      w1 = 775-y;
    }
    if (shortestRight<0) {
      shortestRight=0;
    }
    if (shortestLeft<0) {
      shortestLeft=0;
    }
    if (shortestUp<0) {
      shortestUp=0;
    }
    if (shortestDown<0) {
      shortestDown=0;
    }
    shortestRight2=1/(shortestRight2+0.05);
    shortestLeft2=1/(shortestLeft2+0.05);
    shortestUp2=1/(shortestUp2+0.05);
    shortestDown2=1/(shortestDown2+0.05);
    float total = shortestRight + shortestLeft+shortestUp+shortestDown;
    float total2= shortestRight2+shortestLeft2+shortestUp2+shortestDown2;
    float total3= d1+d2+d3+d4;
    if (shortestRight2==shortestLeft2&&shortestUp2==shortestDown2&&shortestLeft2==shortestDown2) {
      shortestRight2=0;
      shortestLeft2=0;
      shortestUp2=0;
      shortestDown2=0;
    }
    inputs.add(shortestRight/total);
    // inputs.add(shortestRight2/total2);//end down
    inputs.add(shortestLeft/total);
    //inputs.add(shortestLeft2/total2);
    inputs.add(shortestUp/total);
    //inputs.add(shortestUp2/total2);
    inputs.add(shortestDown/total);
    //inputs.add(shortestDown2/total2);
    
    if (x<600) {
      if (shortestRight!= 0) {
        right = map(600-pos.x, 0, 400, 0, 1);
      }
      if (shortestDown!=0)
        down = map(900-size-pos.y, 0, 900-size-200, 0, 1);
    } else if (x>=600) {
      if (shortestRight!= 0) {
        right = map(1500-pos.x, 0, 900, 0, 1);
      }
      if (shortestUp!=0)
        up = map(pos.y-100, 0, 900-size-100, 0, 1);
    }

    //if (x<600) {
    //  down = 0.5;
    //} else if (x>600) {
    //  up = 0.5;
    //}

    //  right = 0.5;

    inputs.add(right/(right+left+up+down));
    inputs.add(left/(right+left+up+down));
    inputs.add(up/(right+left+up+down));
    inputs.add(down/(right+left+up+down));


    textSize(30);
    text("R: "+shortestRight, 100, 300);
    text("L: "+shortestLeft, 100, 400);
    text("U: "+shortestUp, 100, 500);
    text("D: "+shortestDown, 100, 600);
    //text("endx: "+endX, 100, 700);
    //text("endy: "+endY, 100, 800);
    text(x, 50, 900);
    text(y, 150, 900);

    return inputs;
  }
}
