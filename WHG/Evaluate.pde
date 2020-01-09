import java.util.Collections; //<>// //<>//
import java.util.Comparator;
float highscore;
float MUTATION_RATE = 0.5;
float ADD_CONNECTION_RATE = 0.5;
float ADD_NODE_RATE = 0.15;
class evaluate {
  private FitnessGenomeComparator fitComp = new FitnessGenomeComparator();

  Map<genome, species> speciesMap;
  Map<genome, Float> scoreMap;
  List<genome> genomes;
  List<species> speciesList;
  List<genome> nextGen;

  innovationGenerator nodeInnovation;
  innovationGenerator connectionInnovation;
  Random random = new Random();

  int population;
  //tuning
  float c1 = 1;
  float c2= 0.9;
  float c3 = 0.2;
  float DT = 6;


  genome fittestGenome;

  evaluate(int populationSize, genome startingGenome, innovationGenerator node, innovationGenerator connect) {
    this.population = populationSize;
    this.nodeInnovation = node;
    this.connectionInnovation = connect;
    genomes = new ArrayList<genome>(populationSize);
    for (int i = 0; i < populationSize; i++) {
      genomes.add(new genome(startingGenome));
    }
    nextGen = new ArrayList<genome>(populationSize);
    speciesMap = new HashMap<genome, species>();
    scoreMap = new HashMap<genome, Float>();
    speciesList = new ArrayList<species>();
  }


  genome Evaluate() {
    for (species s : speciesList) {
      s.reset(random);
    }
    scoreMap.clear();
    speciesMap.clear();
    nextGen.clear();
    highscore = Float.MIN_VALUE;
    fittestGenome = null;

    for (genome g : genomes) {
      boolean found = false;
      for (species s : speciesList) {
        if (g.compatibilityD(g, s.mascot(), c1, c2, c3)<DT) {
          s.members.add(g);
          speciesMap.put(g, s);
          found = true;
          break;
        }
      }
      if (!found) {
        species newSpecies = new species(g);
        speciesList.add(newSpecies);
        speciesMap.put(g, newSpecies);
      }
    }

    Iterator<species> i = speciesList.iterator();
    while (i.hasNext()) {
      species s = i.next();
      if (s.members.isEmpty()) {
        i.remove();
      }
    }
    println();
    int a = 0;
    for (genome g : genomes) {
      print(a/10+",");
      species s = speciesMap.get(g);
      float score = evaluateGenome(g);
      float adj = score / s.members.size();

      s.addAdjFit(adj);
      s.fitnessPop.add(new fitnessGenome(g, adj));
      scoreMap.put(g, adj);
      if (score>=highscore) {
        highscore = score;
        fittestGenome = g;
      }
      a++;
    }
    println();

    for (species s : speciesList) {
      Collections.sort(s.fitnessPop(), fitComp);
      Collections.reverse(s.fitnessPop);
      fitnessGenome fittest = s .fitnessPop.get(0);
      nextGen.add(fittest.genome());
    }
    println();
    while (nextGen.size()<population) { 
      species s = getRandomSpeciesBiasedAjdustedFitness(random);

      genome p1 = getRandomGenomeBiasedAdjustedFitness(s, random);
      genome p2 = getRandomGenomeBiasedAdjustedFitness(s, random);
      genome child;
      if (scoreMap.get(p1)>= scoreMap.get(p2)) {
        child = p1.crossover(p1, p2, random);
      } else {
        child = p1.crossover(p2, p2, random);
      }

      if (random.nextFloat()<MUTATION_RATE) {
        child.mutation(random);
      }
      if (random.nextFloat()< ADD_CONNECTION_RATE) {
        child.addConnectionMutation(random, connectionInnovation, 20);
      }

      if (random.nextFloat()< ADD_NODE_RATE) {
        child.addNodeMutation(random, connectionInnovation, nodeInnovation);
      }
      nextGen.add(child);
    }

    genomes = nextGen;
    nextGen = new ArrayList<genome>();
    println(highscore);
    println(speciesList.size());
    return fittestGenome;
  }



  private species getRandomSpeciesBiasedAjdustedFitness(Random random) {
    double completeWeight = 0.0;  // sum of probablities of selecting each species - selection is more probable for species with higher fitness
    for (species s : speciesList) {
      completeWeight += s.totalAdjFit;
    }
    double r = Math.random() * completeWeight;
    double countWeight = 0.0;
    for (species s : speciesList) {
      countWeight += s.totalAdjFit;
      if (countWeight >= r) {
        return s;
      }
    }
    throw new RuntimeException("Couldn't find a species... Number is species in total is "+speciesList.size()+", and the total adjusted fitness is "+completeWeight);
  }

  private genome getRandomGenomeBiasedAdjustedFitness(species selectFrom, Random random) {
    double completeWeight = 0.0;  // sum of probablities of selecting each genome - selection is more probable for genomes with higher fitness
    for (fitnessGenome fg : selectFrom.fitnessPop) {
      completeWeight += fg.fitness();
    }
    double r = Math.random() * completeWeight;
    double countWeight = 0.0;
    for (fitnessGenome fg : selectFrom.fitnessPop) {
      countWeight += fg.fitness();
      if (countWeight >= r) {
        return fg.genome();
      }
    }
    throw new RuntimeException("Couldn't find a genome... Number is genomes in selæected species is "+selectFrom.fitnessPop.size()+", and the total adjusted fitness is "+completeWeight);
  }

  public int getSpeciesAmount() {
    return speciesList.size();
  }

  public float getHighestFitness() {
    return highscore;
  }

  public genome getFittestGenome() {
    return fittestGenome;
  }



  float evaluateGenome (genome g) {
    float pastscore = 0;
    int pastcount =0;
    int timer = 0;
    pos.reset();
    ball[0].reset(625, 600, 350, 1400);
    ball[1].reset(1375, 600, 450, 1400);
    ball[2].reset(625, 600, 550, 1400);
    ball[3].reset(1375, 600, 650, 1400);
    ball[4].reset(625, 600, 750, 1400);

    while (timer<amountOfMoves) {


      input(pos.getInputs(px, py), g);
      float output[] = calculate(g, outputNum, false);
      int  max = maxIndex(output);
      pos.move(max, speed, output, 0);
      for (int i = 0; i < 5; i++) {
        ball[i].move();
        if (pos.hasWon()) {
          float score =  pos.getScore(false);
          pos.reset();
          ball[0].reset(625, 600, 350, 1400);
          ball[1].reset(1375, 600, 450, 1400);
          ball[2].reset(625, 600, 550, 1400);
          ball[3].reset(1375, 600, 650, 1400);
          ball[4].reset(625, 600, 750, 1400);
          saveGenome(g);
          return score*1000;
        }
        if (pos.isTouching(ball[i].getX(), ball[i].getY(), ball[i].getRad())&&pos.x<1100) {
          float score =  pos.getScore(false);
          pos.death();
          timer = amountOfMoves - 10;
          ball[0].reset(625, 600, 350, 1400);
          ball[1].reset(1375, 600, 450, 1400);
          ball[2].reset(625, 600, 550, 1400);
          ball[3].reset(1375, 600, 650, 1400);
          ball[4].reset(625, 600, 750, 1400);
          pos.reset();
          return score;
        } else if (pos.isTouching(ball[i].getX(), ball[i].getY(), ball[i].getRad())) {
          float score =  pos.getScore(false);
          pos.death();
          timer = amountOfMoves - 10;
          ball[0].reset(625, 600, 350, 1400);
          ball[1].reset(1375, 600, 450, 1400);
          ball[2].reset(625, 600, 550, 1400);
          ball[3].reset(1375, 600, 650, 1400);
          ball[4].reset(625, 600, 750, 1400);
          pos.reset();
          return score;
        }
      }
      //if(!fast){
      //if (timer%100 ==0) {
      //  pastscore = pos.getScore(false);
      //}
      //if (timer%100 == 50) {
      //  if ( pastscore == pos.getScore(false)) {
      //    pastcount++;
      //  } else if (pastcount!=0) {
      //    pastcount =0;
      //  }
      //}
      //if (pastcount >10&& timer < amountOfMoves-10) {
      //  timer = amountOfMoves - 10;
      //}
      //}else{
      //        if (timer%20 ==0) {
      //  pastscore = pos.getScore(false);
      //}
      //if (timer%20 == 10) {
      //  if ( pastscore == pos.getScore(false)) {
      //    pastcount++;
      //  } else if (pastcount!=0) {
      //    pastcount =0;
      //  }
      //}
      //if (pastcount >10&& timer < amountOfMoves-10) {
      //  timer = amountOfMoves - 10;
      //}
      //}
      if (px == pos.x && py == pos.y) {
        pastcount++;
      } else {
        pastcount =0;
      }
      if (pastcount >300&& timer < amountOfMoves-10) {
        timer = amountOfMoves - 10;
      }
      timer++;
      px=pos.x;
      py=pos.y;
    }
    float score  = pos.getScore(false);
    return score;
  }


  float[] calculate(genome g, int num, boolean show) {

    float[] outputs = new float[outputNum];
    List<Integer>  list = asSortedList(g.getNodeGenes().keySet());
    for (int i = 0; i < list.size(); i++) {
      if (g.getNodeGenes().get(list.get(i))!=null&&g.getNodeGenes().get(list.get(i)).getType() !=TYPE.INPUT) {
        g.getNodeGenes().get(list.get(i)).setX(-9999999);
      }
    }
    list = asSortedList(g.getConnectionGenes().keySet());
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        int idIn = g.getConnectionGenes().get(list.get(i)).getInNode();
        float weight = g.getConnectionGenes().get(list.get(i)).getWeight();
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        if (g.getNodeGenes().get(idOut).getType() == TYPE.HIDDEN&& e) {
          if (g.getNodeGenes().get(idOut).getX() == -9999999) {
            g.getNodeGenes().get(idOut).setX(0);
          }
          switch(g.getNodeGenes().get(idOut).getY()) {
            case(0):
            case(1):
            g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idOut).getX()+g.getNodeGenes().get(idIn).getX()*weight);
            break;
            case(2):
            case(5):
            g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idOut).getX()-g.getNodeGenes().get(idIn).getX()*weight);
            break;
            case(3):
            if (g.getNodeGenes().get(idOut).getX()==0) {
              g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idOut).getX());
            } else {
              g.getNodeGenes().get(idOut).setX( g.getNodeGenes().get(idOut).getX()* g.getNodeGenes().get(idOut).getX());
            }
            break;
            case(4):
            g.getNodeGenes().get(idOut).setX(sqrt(sq(g.getNodeGenes().get(idOut).getX())+sq(g.getNodeGenes().get(idIn).getX()*weight)));
            break;
          }
          if (show) {
            strokeWeight(abs(weight)*2); 
            if (weight>0) {
              stroke(255);
            }

            line(g.getNodeGenes().get(idOut).getX1(), g.getNodeGenes().get(idOut).getY1(), g.getNodeGenes().get(idIn).getX1(), g.getNodeGenes().get(idIn).getY1());
            strokeWeight(2);
            stroke(0);
          }
        }
      }
    }
    list = asSortedList(g.getNodeGenes().keySet());
    for (int i = 0; i < list.size(); i++) {
      if (g.getNodeGenes().get(list.get(i))!=null&&g.getNodeGenes().get(list.get(i)).getType() ==TYPE.HIDDEN) {
        g.getNodeGenes().get(list.get(i)).setX(g.getNodeGenes().get(list.get(i)).getX()+g.getNodeGenes().get(list.get(i)).getB());
      }
    }
    list = asSortedList(g.getConnectionGenes().keySet());
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        int idIn = g.getConnectionGenes().get(list.get(i)).getInNode();
        float weight = g.getConnectionGenes().get(list.get(i)).getWeight();
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        if (g.getNodeGenes().get(idOut).getType() == TYPE.OUTPUT&&e) {
          if (g.getNodeGenes().get(idOut).getX()==-9999999 ) {
            g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idIn).getX()*weight);
          } else {
            g.getNodeGenes().get(idOut).setX(g.getNodeGenes().get(idOut).getX()+g.getNodeGenes().get(idIn).getX()*weight);
            // outputs[idOut-inputNum]+=(g.getNodeGenes().get(idOut).getX());
          }
          if (show) {
            strokeWeight(abs(weight)*2);
            if (weight>0) {
              stroke(255);
            }

            line(g.getNodeGenes().get(idOut).getX1(), g.getNodeGenes().get(idOut).getY1(), g.getNodeGenes().get(idIn).getX1(), g.getNodeGenes().get(idIn).getY1());
            strokeWeight(2);
            stroke(0);
          }
        }
      }
    }
    for (int i = 0; i < outputNum; i++) {
      outputs[i] = -9999999;
    }
    for (int i = 0; i < list.size(); i++) {
      if (g.getConnectionGenes().get(list.get(i))!=null) {
        boolean e = g.getConnectionGenes().get(list.get(i)).isExpressed();
        int idOut = g.getConnectionGenes().get(list.get(i)).getOutNode();
        if (g.getNodeGenes().get(idOut).getType() == TYPE.OUTPUT&&e) {
          outputs[idOut-inputNum]=(g.getNodeGenes().get(idOut).getX());
        }
      }
    }
    return outputs;
  }

  void input(List<Float> inputs, genome g) {
    for ( int i = 0; i < inputs.size(); i++) {
      if (g.getNodeGenes().get(i).getType() == TYPE.INPUT) {

        g.getNodeGenes().get(i).setX(inputs.get(i));
      }
    }
  }
}

public class FitnessGenomeComparator implements Comparator<fitnessGenome> {

  @Override
    public int compare(fitnessGenome one, fitnessGenome two) {
    if (one.fitness() > two.fitness()) {
      return 1;
    } else if (one.fitness() < two.fitness()) {
      return -1;
    }
    return 0;
  }
}
