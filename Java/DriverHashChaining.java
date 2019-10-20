import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DriverHashChaining {
   
   public static void main(String [] args) throws IOException {
   
      List<Integer> input = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         input = ReadHashInput.readData(br, "int", 0);
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      String schemes[] = {"3", "6"};
      String csvFiles[] = {args[1], args[2], args[3]};
   
      int htSchemes[] = {120, 113};
      boolean isModuloScheme[] = {true, true, false};
      
      for (int i = 0; i < htSchemes.length; ++i) {
         
         System.out.println("Scheme " + schemes[i] + ":");
         // Rename hash tables to ht to make for less code
         HashTableChaining<Integer, Counter> ht = 
            new HashTableChaining<Integer, Counter>(htSchemes[i], isModuloScheme[i]);
         for (Integer j : input) {
            ht.insert(j, new Counter());
         }
         ht.search(38531);
         ht.search(80800);
         ht.search(80801);
         ht.search(39531);
         ht.search(12501);
         ht.writeToCSV(csvFiles[i], ht.helperArray());
         System.out.println();
         
         ht.printPretty(ht.helperArray(), 14);
         
         System.out.println("Number of elements added = " + ht.numElements());
         // 
         System.out.println("Number of duplicates = " + ht.duplicates());
         System.out.println("Number of collisions = " + ht.numCollisions());
         System.out.println("Number of free spaces = " + ht.stackSize());
        /* We want to confirm that number of free slots is equal to number of
         * total number of slots minus the slots filled up.  However to do this
         * we first need to make sure we offset the number of collisions by duplicates
         * and remove the number of duplicates from the collisions because a duplicate 
         * is a collision but does not count as adding an element to n, the 
         * number of items added.  Instead we either increase counter or overwrite.
         * So we don't increase the counter for number of elements for this duplicate
         * and so we do not remove it from the count of elements like we do for 
         * collisions.  Therefore the number of available slots equals:
         * (Total # slots - (# Elements added - (# collisions - # duplicates)))
         */
         if (ht.size()-
                      // subtract true collisions from number of elements
                      (ht.numElements()-
                            // duplicates removed from collisions
                            (ht.numCollisions()-ht.duplicates())) == ht.stackSize()) {
            System.out.print("Free space is correct: ");
            System.out.println("(" + ht.size() + " - (" + ht.numElements() +
                  " - " + "(" + ht.numCollisions() + " - " + ht.duplicates() +
                  "))) = " + ht.stackSize());
         }
         System.out.print("Number of collisions is " + ht.numCollisions() + " for"
               + " a percent of " + 
               ((double) ht.numCollisions()/(ht.numElements()+ht.duplicates())));
         System.out.println(" (" + ht.numCollisions() + "/" + 
               (ht.numElements()+ht.duplicates()) + ")");
         
         System.out.println();
         System.out.println("Printing top 10 count:");
         for (KeyValue<Integer, Counter> kv : ht.flattenSort("v", "d", true, 10))
            System.out.println(kv);
         System.out.println("\n");
      }
   
   }
}
