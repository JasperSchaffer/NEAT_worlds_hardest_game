
class innovationGenerator{
  int ci;
  innovationGenerator(){
    ci = 0;
  }
  int getInn(){
   return ci++; 
  }
  
  int getMax(){
   return ci; 
  }
}
