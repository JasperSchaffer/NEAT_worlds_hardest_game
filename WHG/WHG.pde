import java.util.*;  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.util.Map.Entry;
List<Integer> nodep = new ArrayList<Integer>();
box pos;
int dead;
boolean won;
int gen;
int outputNum;
int inputNum;
int population;
float ph;
int pastcounter;
int px, py;
boolean fast;
maze maze;
innovationGenerator nodeInn;
innovationGenerator connectionInn;
evaluate neat;
genome genome;
int speed;
int indexnum;
balls[] ball;
int vx;
int vy;
int amountOfMoves;
boolean test;
boolean slow = false;
boolean savedGenome;
List<Integer> steps;
enum TYPE {
  INPUT, 
    HIDDEN, 
    OUTPUT;
}
void setup() {
  won = false;
  fast = true;
  px =0;
  py = 0;
  pastcounter=0;
  ph =1;
  test = false;
  outputNum=4;
  inputNum=8;
  amountOfMoves=1000;
  indexnum = 0;
  speed = 5;
  population = 50;
  MUTATION_RATE = 0.7;
  ADD_CONNECTION_RATE = 0.1;
  ADD_NODE_RATE = 0.1;

  gen = 0;
  steps = new ArrayList<Integer>();
  nodeInn = new innovationGenerator();
  connectionInn = new innovationGenerator();

  if (!savedGenome) {
    genome = new genome();

    for (int i = 0; i < inputNum; i++) {
      genome.addNodeGene(new nodeGene(TYPE.INPUT, nodeInn.getInn()));
    }
    for (int i = 0; i < outputNum; i++) {
      genome.addNodeGene(new nodeGene(TYPE.OUTPUT, nodeInn.getInn()));
    }
    for (int i = 0; i < 1; i++) {
      //genome.addConnectionMutation(new Random(), connectionInn, 20);
      genome.addConnectionGene(new connectionGene(6, 10, 1, true, connectionInn.getInn()));
      //genome.addConnectionGene(new connectionGene(11, 15, 1, true, connectionInn.getInn()));
      //genome.addConnectionGene(new connectionGene(1, 15, 1, true, connectionInn.getInn()));
    }
    //genome.addNodeMutation(random, connectionInn,nodeInn);
    //genome.addNodeMutation(random, connectionInn,nodeInn);
    //genome.addNodeMutation(random, connectionInn,nodeInn);
    //genome.addNodeMutation(random, connectionInn, nodeInn);
  }
  neat = new evaluate(population, genome, nodeInn, connectionInn);
  printGenome(600, 1400, 10, 280, genome, 30);
  size(2000, 1800);
  background(  89, 134, 252);
  ball = new balls[5];
  pos = new box();
  maze = new maze();
          ball[0] = new balls(625, 600, 350, 1400);
          ball[1] = new balls(1375, 600, 450, 1400);
          ball[2] = new balls(625, 600, 550, 1400);
          ball[3] = new balls(1375, 600, 650, 1400);
          ball[4] = new balls(625, 600, 750, 1400);

  // loop();
  for (int i = 0; i<50; i++) {
    // steps.add(random.nextInt(4));
    //println(random.nextInt(4));
  }
}

void draw() {
  if (indexnum %10 ==0) {
    px=pos.x;
    py=pos.y;
  }
  if (ph == highscore && !won) {
    pastcounter++;
  } else if (pastcounter!=0 && !won) {
    pastcounter =0;
  }

  if (pastcounter >10&&indexnum < amountOfMoves-5) {
    indexnum = amountOfMoves-5;
  }
  float[] output = new float[outputNum];
  int max = 0;
  background(89, 134, 252);
  maze.make();
  textSize(40);
  text(amountOfMoves, 500, 950);
  if (!test)
    text(indexnum, 300, 950);
  neat.input(pos.getInputs(px, py), genome);
  output =  neat.calculate(genome, 4, true);

  max = maxIndex(output);
  pos.move(max, speed, output, 0);
  //pos.move(vx, vy, speed);
  pos.place();
  //println(pos.x);

  if (pos.getScore(true)==   highscore && indexnum<amountOfMoves-30) {
    indexnum = amountOfMoves-30;
    test = true;
  }

  for (int j = 0; j<5; j++) {
    ball[j].move();
    if (pos.hasWon()) {
      //while (true);
    }
    if (pos.isTouching(ball[j].getX(), ball[j].getY(), ball[j].getRad())) {
      pos.death();
      indexnum = amountOfMoves-5;
    }
    textSize(30);
    text(gen, 300, 150);
  }
  if (indexnum<=amountOfMoves) {
    indexnum++;
  } else {
    ph = highscore;
    indexnum = 0;
    //if (ADD_NODE_RATE>0.1) {
    //  ADD_NODE_RATE -=0.02;
    //}
    //if (ADD_CONNECTION_RATE>0.1) {
    //  ADD_CONNECTION_RATE -=0.01;
    //}

          ball[0].reset(625, 600, 350, 1400);
          ball[1].reset(1375, 600, 450, 1400);
          ball[2].reset(625, 600, 550, 1400);
          ball[3].reset(1375, 600, 650, 1400);
          ball[4].reset(625, 600, 750, 1400);
    gen++;
    genome = neat.Evaluate();
    pos.reset();
    test = false;
  }
  printGenome(200, 1800, 1100, 1700, genome, 30);
}


void printGenome(int x1, int x2, int y1, int y2, genome g, int size) {
  nodep.clear();
  List<Integer> list;
  textSize(30);
  fill(255);

  if (genome != null) {
    list = asSortedList(g.getNodeGenes().keySet());
    int in = 0;
    for (int i = 0; i < list.size(); i++) {
      textAlign(CENTER);
      if ( g.getNodeGenes().get(list.get(i))!= null) { 
        if ( g.getNodeGenes().get(list.get(i)).getType() == TYPE.INPUT) {
          ellipse(x1, (y1)+(in*(y2-y1))/inputNum, size, size);
          g.getNodeGenes().get(list.get(i)).setX1(x1);
          g.getNodeGenes().get(list.get(i)).setY1((y1)+(in*(y2-y1))/inputNum);
          fill(0);
          text(g.getNodeGenes().get(list.get(i)).getX(), x1, (y1)+(in*(y2-y1))/inputNum);
          fill(255);
        } else if (g.getNodeGenes().get(list.get(i)).getType() == TYPE.OUTPUT) {
          ellipse(x2, (y1)+((in-inputNum)*(y2-y1))/outputNum, size, size);
          g.getNodeGenes().get(list.get(i)).setX1(x2);
          g.getNodeGenes().get(list.get(i)).setY1((y1)+((in-inputNum)*(y2-y1))/outputNum);
          fill(0);
          text(g.getNodeGenes().get(list.get(i)).getX(), x2+20, (y1)+((in-inputNum)*(y2-y1))/outputNum-20);
          fill(255);
        } else {

          int z=(((x1))+((((i-inputNum+outputNum)/inputNum)*((x2-x1))/(inputNum*2))))+i*10;
          int z1 = (((y1))+((((i-inputNum+outputNum)%8)*((y2-y1))/8)));
          ellipse(z, z1, size, size);  
          g.getNodeGenes().get(list.get(i)).setX1(z);
          g.getNodeGenes().get(list.get(i)).setY1(z1);

          fill(0);
          text(g.getNodeGenes().get(list.get(i)).getX(), z, z1-20);
          fill(255);
          fill(0);
          textSize(20);
          switch(g.getNodeGenes().get(list.get(i)).getY()) {
            case(0):
            case(1):
            text('+', z, z1+10);
            break;
            case(2):
            case(5):
            text('-', z, z1+10);
            break;
            case(3):
            text("*", z, z1+10);
            break;
            case(4):
            text("sq", z, z1+10);
            break;
          default:
            text(g.getNodeGenes().get(list.get(i)).getY(), z, z1+10);
            break;
          }
          fill(255);
          textSize(30);
        }
      }
      in++;
    }
  }
}


void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      vy=-speed;
      break;
    case DOWN:
      vy=speed;
      break;
    case LEFT:
      vx=-speed;
      break;
    case RIGHT:
      vx=speed;
      break;
    }
  }
}



void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case UP:
      vy=0;
      break;
    case DOWN:
      vy=0;
      break;
    case LEFT:
      vx=0;
      break;
    case RIGHT:
      vx=0;
      break;
    }
  } else if (key =='r') {
    savedGenome = false;
    setup();
  } else if (key =='g') {
    amountOfMoves-=100;
  } else if (key =='h') {
    amountOfMoves +=100;
  } else if (key == 'x') {
    ph = -1;
  } else if (key == 'f') {
    fast = !fast;
  } else if (key=='p') {
    saveGenome(genome);
  } else if (key == 'o') {

    //*****
    //String[] oldNode = {"5","0.62573683", "0","0.0", "0","0.0", "4","1.8937035", "3","0.0", "3","0.0", "1","-0.8147936", "3","0.0", "1","0.0", "5","0.0", "0","0.0", "0","0.0", "5","0.0", "1","0.0", "3","0.0", "4","0.0", "1","0.0", "1","0.0"};
    //String[] oldCon = {"10","14","0.019511174","0","11","15","0.28120148","1","10","17","-2.231138","0","17","14","-0.9276135","1","10","18","2.050998","1","18","17","2.5674455","0","4","13","0.018603226","1","10","19","-0.18063799","0","19","14","0.037032343","1","10","20","1.4427434","0","20","14","-0.6639428","1","0","15","0.30266306","0","0","21","-0.048166312","0","21","15","0.5749349","0","9","16","-1.8233037","0","11","21","-1.727982","1","5","20","-0.36234927","0","21","13","-0.04059806","1","5","22","0.042635653","1","22","20","1.2311578","0","10","23","-1.3377107","1","23","20","1.0719041","1","9","20","0.047614947","0","22","24","0.02177568","1","24","20","1.0456705","0","11","25","-1.1448823","1","25","15","-0.23098996","1","5","26","0.30141804","1","26","22","-0.9139938","1","21","27","-1.1894507","1","27","15","-0.19486636","1","18","28","1.0","1","28","17","2.5674455","1","4","22","0.5509614","1","9","29","1.0","1","29","16","-1.8233037","1","19","13","-0.71338964","1","22","12","-0.3062439","1","19","15","-0.31858003","1","24","30","1.0","1","30","20","1.0456705","1","9","13","-0.10705197","1","25","31","1.0","1","31","15","-0.23098996","0","10","32","1.0","1","32","19","-0.18063799","1","31","33","1.0","1","33","15","-0.23098996","1","19","16","-0.57913446","1","6","15","-0.4229083","1","21","12","0.77266514","1","22","18","0.80204713","1","19","23","-0.18709385","1","0","34","1.0","1","34","21","-0.048166312","1","1","18","0.24914265","1","11","19","-0.16965055","1"};
    //int nodenum = 18;
    //int conNum = 57;

    //String[] oldNode = {"2","0.0", "3","0.0", "1","-1.8411832", "1","-1.2268939", "3","0.9248216", "2","0.0", "4","0.0", "3","0.0", "3","0.0", "0","0.0", "5","0.0", "2","0.0", "0","0.0", "0","0.0", "4","0.0", "0","0.0", "2","0.0", "0","0.0", "3","0.0", "5","0.0", "0","0.0", "0","0.0", "0","0.0", "0","0.0"};
    //String[] oldCon = {"6","10","0.05008789","1","7","11","2.2906897","0","6","12","-0.078743","1","12","10","2.0569422","1","6","11","8.929017E-4","0","7","13","0.041467942","0","13","11","-0.47130728","0","0","11","1.6142514","0","0","14","0.615921","0","14","11","-0.106738724","1","13","15","2.9314232","0","15","11","0.26741013","1","5","9","-0.350016","0","4","9","0.25331882","0","5","11","-0.5661603","1","7","16","1.0","0","16","13","0.041467942","1","4","11","-0.1238327","0","2","11","-0.45468783","1","7","17","1.0","1","17","11","2.2906897","1","13","18","1.0","0","18","15","2.9314232","1","7","19","1.0","1","19","11","2.2906897","0","0","8","-0.3313775","1","5","20","1.0","1","20","9","-0.350016","1","4","21","1.0","0","21","9","0.25331882","1","7","22","1.0","1","22","16","1.0","1","6","23","1.0","1","23","11","8.929017E-4","1","13","24","1.0","1","24","18","1.0","1","0","20","-0.05267477","1","2","17","0.36957932","1","13","25","1.0","1","25","11","-0.47130728","1","7","26","1.0","1","26","16","1.0","1","0","16","0.3882389","1","17","9","0.36820018","1","7","27","1.0","1","27","19","1.0","1","16","25","0.43096137","1","13","28","1.0","0","28","18","1.0","1","13","29","1.0","1","29","28","1.0","1","7","30","1.0","1","30","16","1.0","1","5","24","0.870875","1","29","31","1.0","1","31","28","1.0","1","0","32","1.0","1","32","14","0.615921","1","6","33","1.0","1","33","11","8.929017E-4","1","19","34","1.0","1","34","11","2.2906897","1","27","14","0.2935555","1","4","35","1.0","1","35","21","1.0","1"};
    //int nodenum = 24;
    //int conNum = 65;
    
    String[] oldNode = {"6", "10", "1.5351157", "0", "0", "11", "-0.19708154", "0", "6", "12", "0.6060673", "0", "12", "10", "0.32174352", "1", "1", "10", "-0.269573", "0", "0", "13", "-1.9245479", "1", "13", "11", "0.1058794", "0", "4", "9", "0.8424462", "1", "0", "14", "0.44724512", "1", "14", "13", "-0.5286794", "0", "13", "15", "1.0", "1", "15", "11", "0.1058794", "0", "2", "10", "0.5835432", "1", "6", "16", "1.0", "0", "16", "12", "0.6060673", "1", "13", "17", "1.0", "1", "17", "11", "0.1058794", "1", "0", "10", "-0.6714183", "1", "3", "11", "0.16188157", "0", "14", "18", "1.0", "1", "18", "13", "-0.5286794", "1", "2", "8", "-0.09203112", "1", "5", "11", "0.2399751", "1", "5", "8", "0.98990774", "0", "0", "19", "1.0", "0", "19", "11", "-0.19708154", "1", "6", "20", "1.0", "1", "20", "16", "1.0", "1", "2", "11", "0.9900398", "1", "15", "21", "1.0", "0", "21", "11", "0.1058794", "1", "0", "22", "1.0", "1", "22", "19", "1.0", "1", "3", "9", "-0.8797823", "1", "3", "23", "1.0", "1", "23", "11", "0.16188157", "0", "5", "24", "1.0", "0", "24", "8", "0.98990774", "1", "23", "25", "1.0", "1", "25", "11", "0.16188157", "1", "14", "26", "1.0", "1", "26", "13", "-0.5286794", "1", "15", "27", "1.0", "1", "27", "21", "1.0", "0", "5", "28", "1.0", "1", "28", "8", "0.98990774", "1", "6", "11", "-0.892578", "1", "6", "29", "1.0", "1", "29", "10", "1.5351157", "1", "0", "30", "1.0", "1", "30", "11", "-0.19708154", "1", "27", "31", "1.0", "1", "31", "21", "1.0", "1", "7", "10", "-0.16160357", "1"};
    String[] oldCon = {"6", "10", "1.5351157", "1", "0", "11", "-0.19708154", "0", "6", "12", "0.6060673", "0", "12", "10", "0.32174352", "1", "1", "10", "-0.269573", "0", "0", "13", "-1.9245479", "1", "13", "11", "0.1058794", "0", "4", "9", "0.8424462", "1", "0", "14", "0.44724512", "1", "14", "13", "-0.5286794", "0", "13", "15", "1.0", "1", "15", "11", "0.1058794", "0", "2", "10", "0.5835432", "1", "6", "16", "1.0", "0", "16", "12", "0.6060673", "1", "13", "17", "1.0", "1", "17", "11", "0.1058794", "1", "0", "10", "-0.6714183", "1", "3", "11", "0.16188157", "0", "14", "18", "1.0", "1", "18", "13", "-0.5286794", "0", "2", "8", "-0.09203112", "1", "5", "11", "0.2399751", "1", "5", "8", "0.98990774", "0", "0", "19", "1.0", "0", "19", "11", "-0.19708154", "1", "6", "20", "1.0", "1", "20", "16", "1.0", "1", "2", "11", "0.9900398", "1", "15", "21", "1.0", "1", "21", "11", "0.1058794", "1", "0", "22", "1.0", "1", "22", "19", "1.0", "1", "3", "9", "-0.8797823", "1", "3", "23", "1.0", "1", "23", "11", "0.16188157", "0", "5", "24", "1.0", "0", "24", "8", "0.98990774", "1", "23", "25", "1.0", "1", "25", "11", "0.16188157", "1", "14", "26", "1.0", "1", "26", "13", "-0.5286794", "1", "15", "27", "1.0", "1", "27", "21", "1.0", "1", "5", "9", "0.7145306", "1", "6", "28", "1.0", "1", "28", "12", "0.6060673", "1", "2", "9", "-0.008497", "1", "3", "29", "1.0", "1", "29", "23", "1.0", "1", "0", "8", "-0.50462544", "1", "5", "30", "1.0", "1", "30", "24", "1.0", "1"};
    int nodenum =19;
    int conNum = 53;
    
    ////win with slow cubes
    //String[] oldNode = {"5", "0.62573683", "1", "0.0", "1", "0.0", "4", "0.0", "0", "0.0"};
    //String[] oldCon = {"10", "14", "-0.5584083", "0", "11", "15", "0.11080129", "1", "10", "17", "-1.7978423", "0", "17", "14", "-0.76142395", "1", "10", "18", "-1.902515", "1", "18", "17", "-1.3427196", "1", "4", "13", "0.1901288", "1", "10", "19", "1.0855784", "1", "19", "14", "0.030013803", "1", "10", "20", "1.0", "1", "20", "14", "-0.5584083", "1", "0", "15", "-0.4615693", "0", "0", "21", "1.0", "1", "21", "15", "-0.4615693", "1", "9", "16", "-0.19193423", "1", "11", "21", "-0.15749705", "1", "5", "20", "-0.51722074", "1", "21", "13", "-0.08208656", "1"};
    //int nodenum = 5;
    //int conNum = 18;
    //*****

    genome = new genome();
    nodeInn = new innovationGenerator();
    connectionInn = new innovationGenerator();
    nodeGene node;
    connectionGene con;
    for (int i = 0; i < inputNum; i++) {
      genome.addNodeGene(new nodeGene(TYPE.INPUT, nodeInn.getInn()));
    }
    for (int i = 0; i < outputNum; i++) {
      genome.addNodeGene(new nodeGene(TYPE.OUTPUT, nodeInn.getInn()));
    }
    for (int i = 0; i< nodenum*2; i+=2) {
      node = new nodeGene(TYPE.HIDDEN, nodeInn.getInn());
      node.setY(int(oldNode[i]));
      node.setB(float(oldNode[i+1]));
      genome.addNodeGene(node);
    }
    conNum*=4;
    for (int i = 0; i < conNum; i+=4) {
      con = new connectionGene(int(oldCon[i]), int(oldCon[i+1]), float(oldCon[i+2]), boolean(int(oldCon[i+3])), connectionInn.getInn());
      genome.addConnectionGene(con);
    }
    savedGenome = true;
    //genome.addConnectionGene(new connectionGene(1, 15, 0.6, true, connectionInn.getInn()));
    //    genome.addConnectionGene(new connectionGene(5, 16, 0.3, true, connectionInn.getInn()));
    setup();
  } else if (key == 'n') {
    indexnum = amountOfMoves;
  } else if (key == 's') {
    if (slow) {
      frameRate(90); 
      slow = !slow;
    } else {
      frameRate(2); 
      slow = !slow;
    }
  }
}

int maxIndex(float arr[]) {
  int mini = 0;
  float min = arr[0];
  for (int i = 0; i< arr.length; i++) {
    if (min == 0 && arr[i]!= -9999999) {
      min = arr[i];
      mini=i;
    }
    if (arr[i]>min&& arr[i]!=-9999999) {
      min = arr[i];
      mini=i;
    }
  }

  fill(255, 0, 0);

  if (min == -9999999)
    return 5;
  return mini;
}

int minIndex(float arr[]) {
  int mini = 0;
  float min = arr[0];
  for (int i = 0; i< arr.length; i++) {
    if (min == 0 && arr[i]!= 0) {
      min = arr[i];
      mini=i;
    }
    if (arr[i]<min&& arr[i]!=0) {
      min = arr[i];
      mini=i;
    }
  }

  if (min == 0)
    return 5;
  return mini;
}

//int maxIndex(float arr[]) {
//  int mini = 0;
//  float min = abs(arr[0]);
//  for (int i = 0; i< arr.length; i++) {
//    if (min == 0 && arr[i]!= 0) {
//      min = abs(arr[i]);
//      mini=i;
//    }
//    if (abs(arr[i])>min&& arr[i]!=0) {
//      min = abs(arr[i]);
//      mini=i;
//    }
//  }
//  if (min == 0)
//    return 4;
//  if (arr[mini]<0) {
//    return -(mini+1);
//  }
//  return (mini+1);
//}
void saveGenome(genome genome) {
  genome g = genome;
  List<Integer>  extra = new ArrayList<Integer>(); 
  List<Integer>  list = asSortedList(g.getNodeGenes().keySet());
  println(list.size()-(inputNum+outputNum));
  print("{"); 
  for (int i = inputNum+outputNum; i < list.size(); i++) {

    print('"');
    print(g.getNodeGenes().get(list.get(i)).getY());
    print('"');
    print(',');
    print('"');
    print(g.getNodeGenes().get(list.get(i)).getB());
    print('"');

    if (i!=list.size()-1) {
      print(", ");
    } else {
      print("};");
    }
  }
  println();
  list = asSortedList(g.getConnectionGenes().keySet());
  println(list.size());
  print("{"); 
  int innode;
  int outnode;
  for (int i = 0; i < list.size(); i++) {
    if (g.getConnectionGenes().get(list.get(i)).getInNode()>= inputNum+outputNum) {
      if (extra.contains(g.getConnectionGenes().get(list.get(i)).getInNode())) {
        innode = findIndex(extra, g.getConnectionGenes().get(list.get(i)).getInNode())+inputNum+outputNum;
      } else {
        extra.add(g.getConnectionGenes().get(list.get(i)).getInNode());
        innode = findIndex(extra, g.getConnectionGenes().get(list.get(i)).getInNode())+inputNum+outputNum;
      }
    } else {
      innode = g.getConnectionGenes().get(list.get(i)).getInNode();
    }

    if (g.getConnectionGenes().get(list.get(i)).getOutNode()>= inputNum+outputNum) {
      if (extra.contains(g.getConnectionGenes().get(list.get(i)).getOutNode())) {
        outnode = findIndex(extra, g.getConnectionGenes().get(list.get(i)).getOutNode())+inputNum+outputNum;
      } else {
        extra.add(g.getConnectionGenes().get(list.get(i)).getOutNode());
        outnode = findIndex(extra, g.getConnectionGenes().get(list.get(i)).getOutNode())+inputNum+outputNum;
      }
    } else {
      outnode = g.getConnectionGenes().get(list.get(i)).getOutNode();
    }
    print('"');
    print(innode);
    print('"'+","+'"'+outnode+'"'+","+'"'+g.getConnectionGenes().get(list.get(i)).getWeight()+'"'+","+'"'+int(g.getConnectionGenes().get(list.get(i)).isExpressed())+'"');
    if (i!=list.size()-1) {
      print(",");
    } else {
      print("};");
    }
  }
}
int findIndex(List<Integer> x, int y) {
  for (int i = 0; i < x.size(); i++) {
    if (x.get(i)==y) {
      return i ;
    }
  }
  return -1;
}
