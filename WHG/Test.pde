

///**
// * Tests a simple evaluator that runs for 100 generations, and scores fitness based on the amount of connections in the network.
// * 
// * @author hydrozoa
// */
//public class TestEvaluatorHundredSum {
  
//  public void main() {
//    innovationGenerator nodeInnovation = new innovationGenerator();
//    innovationGenerator connectionInnovation = new innovationGenerator();
    
//    genome genome = new genome();
//    int n1 = nodeInnovation.getInn();
//    int n2 = nodeInnovation.getInn();
//    int n3 = nodeInnovation.getInn();
//    genome.addNodeGene(new nodeGene(TYPE.INPUT, n1));
//    genome.addNodeGene(new nodeGene(TYPE.INPUT, n2));
//    genome.addNodeGene(new nodeGene(TYPE.OUTPUT, n3));
    
//    int c1 = connectionInnovation.getInn();
//    int c2 = connectionInnovation.getInn();
//    genome.addConnectionGene(new connectionGene(n1,n3,0.5f,true,c1));
//    genome.addConnectionGene(new connectionGene(n2,n3,0.5f,true,c2));
    
    
//    evaluate eval = new evaluate(100, genome, nodeInnovation, connectionInnovation);
//    {
//      @Override
//       float evaluateGenome(genome genome) {
//        float weightSum = 0f;
//        for (connectionGene cg : genome.getConnectionGenes().values()) {
//          if (cg.isExpressed()) {
//            weightSum += Math.abs(cg.getWeight());
//          }
//        }
//        float difference = Math.abs(weightSum-100f);
//        return (1000f/difference);
//      }
//    };
    
//    for (int i = 0; i < 1000; i++) {
//      eval.Evaluate();
//      print("Generation: "+i);
//      print("\tHighest fitness: "+eval.getHighestFitness());
//      print("\tAmount of species: "+eval.getSpeciesAmount());
//      print("\tConnections in best performer: "+eval.getFittestGenome().getConnectionGenes().values().size());
//      float weightSum = 0;
//      for (connectionGene cg : eval.getFittestGenome().getConnectionGenes().values()) {
//        if (cg.isExpressed()) {
//          weightSum += Math.abs(cg.getWeight());
//        }
//      }
//      System.out.print("\tWeight sum: "+weightSum);
//      System.out.print("\n");
//      if (i%10==0) {
//        //genomePrinter.printGenome(eval.getFittestGenome(), "output/connection_sum_100/"+i+".png");
//      }
//    }
//  }

//}
