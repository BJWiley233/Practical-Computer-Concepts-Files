import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class HashTest {

   public static void main(String[] args) {
      
 List<Integer> input = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[1]));
         input = ReadHashInput.readData(br, "int", 0);
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      /*
       * Arrays for instantiating the hash tables with schema parameters
       * to be passed to the constuctors.  There is only 8 array entries
       * as we repeat schemes 1-3 with our own hashing scheme so parameter 
       * for boolean divisionHashing to constructor is set to false for
       * schemes 9-11
       */
      int htSlots[] = {120, 120, 120, 120, 120, 120, 120, 120};
      int htModulo[] = {120, 120, 120, 113, 113, 113, 41, 41};
      int buckets[] = {1, 1, 1, 1, 1, 1, 3, 3};
      double c1[] = {1, (double)1/2, 0, 1, (double)1/2, 0, 1, (double)1/2};
      double c2[] = {0, (double)1/2, 0, 0, (double)1/2, 0, 0, (double)1/2};
      boolean isDivision[] = {true, true, true, true, true, true, true, true};

      HashTableProbing<Integer, Counter> ht2_50 = 
            new HashTableProbing<Integer, Counter>(100000, 100000, buckets[1], 
                  c1[1], c2[1], isDivision[1]);
      
      HashTableProbing<Integer, Counter> ht5_50 = 
            new HashTableProbing<Integer, Counter>(100000, 99991, buckets[4], 
                  c1[4], c2[4], isDivision[4]);
      
   
         for (Integer i : input) {
            ht2_50.insert(i, new Counter());
            ht5_50.insert(i, new Counter());
         }
      
         List<Integer> input1 = new ArrayList<Integer>();
         
         try {
            BufferedReader br = new BufferedReader(new FileReader(args[2]));
            input1 = ReadHashInput.readData(br, "int", 0);
         }
         catch (IOException e) {
            System.err.println("Error" + e);
         }
      
         HashTableProbing<Integer, Counter> ht2_100 = 
               new HashTableProbing<Integer, Counter>(100000, 100000, buckets[1], 
                     c1[1], c2[1], isDivision[1]);
         
         HashTableProbing<Integer, Counter> ht5_100 = 
               new HashTableProbing<Integer, Counter>(100000, 99991, buckets[4], 
                     c1[4], c2[4], isDivision[4]);
         
      
            for (Integer i : input1) {
               ht2_100.insert(i, new Counter());
               ht5_100.insert(i, new Counter());
            }
            
            System.out.println(ht2_50.numCollisions()); 
            System.out.println(ht5_50.numCollisions()); 
            
            System.out.println(); 
            System.out.println(ht2_100.numCollisions()); 
            System.out.println(ht5_100.numCollisions()); 
   }

}
