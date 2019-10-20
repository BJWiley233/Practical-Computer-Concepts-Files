import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class DriverHash {

   @SuppressWarnings("unchecked")
   public static void main(String[] args) {
      
      List<Integer> input = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         input = ReadHashInput.readData(br, "int", 0);
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      
      //String csvFiles[] = {args[1], args[2], args[3]};
      int htSlots[] = {120, 120, 120, 120, 120, 120, 120, 120};
      int htModulo[] = {120, 120, 120, 113, 113, 113, 41, 41};
      int buckets[] = {1, 1, 1, 1, 1, 1, 3, 3};
      double c1[] = {1, (double)1/2, 0, 1, (double)1/2, 0, 1, (double)1/2};
      double c2[] = {0, (double)1/2, 0, 0, (double)1/2, 0, 0, (double)1/2};
      boolean isModuloScheme[] = {true, true, true, true, true, true, true, true};
      
  
      HashTableProbing<Integer, Counter> ht1 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isModuloScheme[0]);
      
      HashTableProbing<Integer, Counter> ht2 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], isModuloScheme[1]);
      
      HashTableInsideChaining<Integer, Counter> ht3 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                   isModuloScheme[2]);
      
      HashTableProbing<Integer, Counter> ht4 = 
            new HashTableProbing<Integer, Counter>(htSlots[3], htModulo[3], buckets[3], 
                  c1[3], c2[3], isModuloScheme[3]);
      
      HashTableProbing<Integer, Counter> ht5 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  c1[4], c2[4], isModuloScheme[4]);
      
      HashTableInsideChaining<Integer, Counter> ht6 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[5], htModulo[5], buckets[5], 
                   isModuloScheme[5]);
      
      HashTableProbing<Integer, Counter> ht7 = 
            new HashTableProbing<Integer, Counter>(htSlots[6], htModulo[6], buckets[6], 
                  c1[6], c2[6], isModuloScheme[6]);
      
      HashTableProbing<Integer, Counter> ht8 = 
            new HashTableProbing<Integer, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  c1[7], c2[7], isModuloScheme[7]);
      
      
      String probingSchemes[] = {"1-Linear Probing", "2-Quadratic Probing", "4-Linear Probing", 
            "5-Quadratic Probing", "7-Linear Probing", "8-Quadratic Probing"};
      String chainingSchemes[] = {"3-Coalesced Chaining", "6-Coalesced Chaining"};
      @SuppressWarnings("rawtypes")
      HashTableProbing [] htProbing = {ht1, ht2, ht4, ht5, ht7, ht8};
      @SuppressWarnings("rawtypes")
      HashTableInsideChaining [] htChaining = {ht3, ht6};
      
      for (int j = 0; j < htProbing.length; ++j) {
         System.out.println(probingSchemes[j]);
         for (Integer i : input)
            htProbing[j].insert(i, new Counter());
      }
      
      for (int j = 0; j < htChaining.length; ++j) {
         System.out.println(chainingSchemes[j]);
         for (Integer i : input)
            htChaining[j].insert(i, new Counter());
      }
      System.out.println("\n");
      
      
      String entry = "";
      int i = 0;
      int probing = 0;
      int chaining = 0;
      int totalSchemes = 8;
      Scanner scanner = new Scanner(System.in);
      
      entry = args[1].toUpperCase();
      
      while (entry.toUpperCase() != "Q") {
         
         switch(entry) {
         
            case "A":
               
               for (i = 0; i < totalSchemes; ++i) {
                  if (i == 2 || i == 5) {
                     System.out.println(i + " Scheme " + chainingSchemes[chaining]);
                     htChaining[chaining].printPretty(14, 24, 5);
                     System.out.println(htChaining[chaining].numElements() + " element(s) added");
                     System.out.println(htChaining[chaining].numCollisions() + " collision(s)"); 
                     System.out.println(htChaining[chaining].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htChaining[chaining].duplicates() + " duplicate(s)");
                     System.out.println();
                     chaining++;
                  }
                  else if (i == 6 || i == 7) {
                     System.out.println(i + " Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty3Buckets(14);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     System.out.println();
                     probing++;
                  }
                  else {
                     System.out.println(i + " Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty(14, 24, 5);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     probing++;
                     System.out.println();
                  }
               }
               probing = 0;
               chaining = 0;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "Q":
               System.exit(1);
               break;
            
            case "1":
               System.out.println(1 + " Scheme " + probingSchemes[0]);
               htProbing[0].printPretty(14, 24, 5);
               System.out.println(htProbing[0].numElements() + " element(s) added");
               System.out.println(htProbing[0].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[0].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[0].duplicates() + " duplicate(s)");
               System.out.println();
               probing = 1;
               i = 1;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "2":
               System.out.println(2 + " Scheme " + probingSchemes[1]);
               htProbing[1].printPretty(14, 24, 5);
               System.out.println(htProbing[1].numElements() + " element(s) added");
               System.out.println(htProbing[1].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[1].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[1].duplicates() + " duplicate(s)");
               System.out.println();
               probing = 2;
               i = 2;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "3":
               System.out.println(3 + " Scheme " + chainingSchemes[0]);
               htChaining[0].printPretty(14, 24, 5);
               System.out.println(htChaining[0].numElements() + " element(s) added");
               System.out.println(htChaining[0].numCollisions() + " collision(s)"); 
               System.out.println(htChaining[0].numElementsNotAdded() + " element(s) not added");
               System.out.println(htChaining[0].duplicates() + " duplicate(s)");
               System.out.println();
               chaining++;
               i = 3;
               probing = 2;
               chaining = 1;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "R":
               for (; i < totalSchemes; ++i) {
                  if (i == 2 || i == 5) {
                     System.out.println(i + " Scheme " + chainingSchemes[chaining]);
                     htChaining[chaining].printPretty(14, 24, 5);
                     System.out.println(htChaining[chaining].numElements() + " element(s) added");
                     System.out.println(htChaining[chaining].numCollisions() + " collision(s)"); 
                     System.out.println(htChaining[chaining].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htChaining[chaining].duplicates() + " duplicate(s)");
                     System.out.println();
                     chaining++;
                  }
                  else if (i == 6 || i == 7) {
                     System.out.println(i + " Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty3Buckets(14);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     System.out.println();
                     probing++;
                  }
                  else {
                     System.out.println(i + " Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty(14, 24, 5);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     probing++;
                     System.out.println();
                  }
               }
               probing = 0;
               chaining = 0;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "":
               if (i == 2 || i == 5) {
                  System.out.println(i+1 + " Scheme " + chainingSchemes[chaining]);
                  htChaining[chaining].printPretty(14, 24, 5);
                  System.out.println(htChaining[chaining].numElements() + " element(s) added");
                  System.out.println(htChaining[chaining].numCollisions() + " collision(s)"); 
                  System.out.println(htChaining[chaining].numElementsNotAdded() + " element(s) not added");
                  System.out.println(htChaining[chaining].duplicates() + " duplicate(s)");
                  System.out.println();
                  chaining++;
               }
               else if (i == 6 || i == 7) {
                  System.out.println(i+1 + " Scheme " + probingSchemes[probing]);
                  htProbing[probing].printPretty3Buckets(14);
                  System.out.println(htProbing[probing].numElements() + " element(s) added");
                  System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                  System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                  System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                  System.out.println();
                  probing++;
               }
               else {
                  System.out.println(i+1 + " Scheme " + probingSchemes[probing]);
                  htProbing[probing].printPretty(14, 24, 5);
                  System.out.println(htProbing[probing].numElements() + " element(s) added");
                  System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                  System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                  System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                  probing++;
                  System.out.println();
               }
               ++i;
               entry = prompt(scanner).toUpperCase();
               break;
               
               
            default: 
               System.err.println("Invalid entry");
               entry = prompt(scanner).toUpperCase();
         }
      }  
      
   }
      
      
   public static String prompt(Scanner scanner) {
      System.out.println("Choose an entry below to print a scheme");
      System.out.println("A/a: prints all schemes");
      System.out.println("1: prints scheme 1");
      System.out.println("2: prints scheme 2");
      System.out.println("3: prints scheme 3");
      System.out.println("4: prints scheme 4");
      System.out.println("5: prints scheme 5");
      System.out.println("6: prints scheme 6");
      System.out.println("7: prints scheme 7");
      System.out.println("8: prints scheme 8");
      System.out.println("R/r: prints remaining schemes");
      System.out.println("Enter: prints next");
      System.out.println("Q/q: quit");
      
      return scanner.nextLine();
      
   }
}
