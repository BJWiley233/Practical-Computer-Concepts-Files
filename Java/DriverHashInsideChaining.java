import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class DriverHashInsideChaining {
   
   public static void main(String[] args) {
      
      List<Integer> input = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         input = ReadHashInput.readData(br, "int", 0);
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      List<Integer> inputTest = new ArrayList<Integer>(
            Arrays.asList(20, 35, 16, 40, 45, 25, 32, 37, 22, 55));
      
      
      String schemes[] = {"3", "6", "11"};
      //String csvFiles[] = {args[1], args[2], args[3]};
      int htSlots[] = {120, 120, 120};
      int htModulo[] = {120, 113, -1};
      int buckets[] = {1, 1, 1};
      boolean isModuloScheme[] = {true, true, false};
      
      
      HashTableInsideChaining<Integer, Counter> ht0 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                   isModuloScheme[0]);
      
      for (int j = 0; j < input.size(); ++j) {
         ht0.insert(input.get(j), new Counter());
      }
      ht0.printPretty(14, 24, 5);
      System.out.println(ht0.numElements());
      System.out.println("Collisions: " + ht0.numCollisions());
      System.out.println("Dups: " + ht0.duplicates());
      /*
      System.out.println();
      HashTableInsideChaining<Integer, Counter> ht1 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                   isModuloScheme[1]);
      
      for (int j = 0; j < input.size(); ++j) {
         ht1.insert(input.get(j), new Counter());
      }
      ht1.printPretty(14, 24, 5);
      System.out.println(ht1.numElements());
      System.out.println(ht1.numCollisions());
      */
      System.out.println();
      HashTableInsideChaining<Integer, Counter> htTest = 
            new HashTableInsideChaining<Integer, Counter>(10, 10, 1, 
                   true);
      for (int j = 0; j < inputTest.size(); ++j) {
         htTest.insert(inputTest.get(j), new Counter());
      }
      htTest.printPretty(16, 2, 5);
      System.out.println(htTest.numElements());
      System.out.println("Collisions: " + htTest.numCollisions());
      
   }
}
