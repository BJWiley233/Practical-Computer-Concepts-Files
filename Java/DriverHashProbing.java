import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DriverHashProbing {

   public static void main(String[] args) {
      
      List<Integer> input = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         input = ReadHashInput.readData(br, "int", 0);
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      String schemes[] = {"1", "2", "4", "5", "7", "8"};
      //String csvFiles[] = {args[1], args[2], args[3]};
      int htSlots[] = {120, 120, 120, 120, 120, 120};
      int htModulo[] = {120, 120, 113, 113, 41, 41};
      int buckets[] = {1, 1, 1, 1, 3, 3};
      double c1[] = {1, (double)1/2, 1, (double)1/2, 1, (double)1/2};
      double c2[] = {0, (double)1/2, 0, (double)1/2, 0, (double)1/2};
      boolean isModuloScheme[] = {true, true, true, true, true, true};
      
      HashTableProbing<Integer, Counter> ht = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isModuloScheme[0]);
      
      int k = 6;
      System.out.println("Scheme " + schemes[0]);
      
        for (int j = 0; j < k; ++j) { ht.insert(input.get(j), new Counter()); }
        
        ht.delete(12501); ht.delete(72501); ht.delete(22705); ht.delete(84883); 
        ht.printPretty(10, 24, 5);
        System.out.println();
        
        for (int j = k; j < input.size(); ++j) { ht.insert(input.get(j), new
        Counter()); }

        ht.printPretty(10, 24, 5);
        System.out.println("Scheme " + schemes[0]);
        System.out.println(ht.numElements() + " elements added");
        System.out.println(ht.numCollisions() + " collisions"); 
        System.out.println(ht.duplicates() + " dups");
        System.out.println(ht.numElementsNotAdded() + " elems not added");
        //ht.getFreeSpaces();
        System.out.println(ht.stackSize() + " stack size");
        
      System.out.println();
      
      
      HashTableProbing<Integer, Counter> ht7 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                   c1[4], c2[4], isModuloScheme[4]);
      
      System.out.println("Scheme " + schemes[4]);
      for (int j = 0; j < k; ++j) { ht7.insert(input.get(j), new Counter()); }
      
      ht7.delete(12501); ht7.delete(72501); ht7.delete(22705); ht7.delete(84883); 
      ht7.printPretty3Buckets(10);
      System.out.println();
      
      for (int j = k; j < input.size(); ++j) { ht7.insert(input.get(j), new
      Counter()); }
      
      
      ht7.printPretty3Buckets(10);
      System.out.println("Scheme " + schemes[4]);
      System.out.println(ht7.numElements() + " elements added");
      System.out.println(ht7.numCollisions() + " collisions"); 
      System.out.println(ht7.duplicates() + " dups");
      System.out.println(ht7.numElementsNotAdded() + " elems not added");
      /*
      
      System.out.println();
      
      HashTableProbing<Integer, Counter> ht8 = 
            new HashTableProbing<Integer, Counter>(htSlots[5], htModulo[5], buckets[5], 
                  c1[5], c2[5], isModuloScheme[5]);
      
      System.out.println("Scheme " + schemes[5]);
      for (int j = 0; j < input.size(); ++j) {
         ht8.insert(input.get(j), new Counter());
      }
      
      ht8.printPretty3Buckets(10);
      System.out.println("Scheme " + schemes[5]);
      System.out.println(ht8.numElements() + " elements added");
      System.out.println(ht8.numCollisions() + " collisions"); 
      System.out.println(ht8.duplicates() + " dups");
      System.out.println(ht8.numElementsNotAdded() + " elems not added");
      */
      
   }
   
   

}
