/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * Driver for the required input for the project.  Creates instance for
 * each of the 11 schemes.  The chaining schemes use a different class than 
 * the probing schemes.  The schemes are instantiated to run the routines
 * for inserting into their respective hash tables based on the parameters
 * passed to the constructors.  This maintains hash table integrity so that
 * the user can not enter incorrect modulus parameters, hash table size, and
 * bucket size.  
 * @author bjwil
 *
 * @see {@code README file in zip folder}, {@link HashTableProbing}, 
 * {@link HashTableInsideChaining}
 */
public class DriverHash {

   @SuppressWarnings({ "unchecked", "rawtypes" })
   public static void main(String[] args) throws IOException {
      
      // Read in default input from LabHashingInput.txt
      List<Integer> input = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
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
      
  
      HashTableProbing<Integer, Counter> ht1 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isDivision[0]);
      
      HashTableProbing<Integer, Counter> ht2 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], isDivision[1]);
      
      HashTableInsideChaining<Integer, Counter> ht3 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  isDivision[2]);
      
      HashTableProbing<Integer, Counter> ht4 = 
            new HashTableProbing<Integer, Counter>(htSlots[3], htModulo[3], buckets[3], 
                  c1[3], c2[3], isDivision[3]);
      
      HashTableProbing<Integer, Counter> ht5 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  c1[4], c2[4], isDivision[4]);
      
      HashTableInsideChaining<Integer, Counter> ht6 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[5], htModulo[5], buckets[5], 
                  isDivision[5]);
      
      HashTableProbing<Integer, Counter> ht7 = 
            new HashTableProbing<Integer, Counter>(htSlots[6], htModulo[6], buckets[6], 
                  c1[6], c2[6], isDivision[6]);
      
      HashTableProbing<Integer, Counter> ht8 = 
            new HashTableProbing<Integer, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  c1[7], c2[7], isDivision[7]);
      
      /*
       * Tables for Schemes 9-11 do not use the modulo hash function.  I just pass
       * a modulo to the Constructor with a boolean whether or not to use it.
       * This makes the constructors easy to make and for grader to see that
       * division method is not being used.  Division hashing is set to false
       */
      HashTableProbing<Integer, Counter> ht9 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], false);
      
      HashTableProbing<Integer, Counter> ht10 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], false);
      
      HashTableInsideChaining<Integer, Counter> ht11 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  false);
      
      /*
       * Additional test for c1 and c2 for schemes 2,5,8,10.  First group tests using
       * 1 for c1 and 2 for c2.  Second group test using 2 for c1 and 3 for c2 
       */
      
      HashTableProbing<Integer, Counter> ht2_1_2 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  1, 2, isDivision[1]);
      
      HashTableProbing<Integer, Counter> ht5_1_2 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  1, 2, isDivision[4]);
      
      HashTableProbing<Integer, Counter> ht8_1_2 = 
            new HashTableProbing<Integer, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  1, 2, isDivision[7]);
      
      HashTableProbing<Integer, Counter> ht10_1_2 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  1, 2, false);
      
      HashTableProbing<Integer, Counter> ht2_2_3 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  2, 3, isDivision[1]);
      
      HashTableProbing<Integer, Counter> ht5_2_3 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  2, 3, isDivision[4]);
      
      HashTableProbing<Integer, Counter> ht8_2_3 = 
            new HashTableProbing<Integer, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  2, 3, isDivision[7]);
      
      HashTableProbing<Integer, Counter> ht10_2_3 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  2, 3, false);
      
      // Strings for outputting schema titles for the tables and writing to file
      String probingSchemes[] = {"1-Linear Probing", "2-Quadratic Probing", 
                                 "4-Linear Probing", "5-Quadratic Probing", 
                                 "7-Linear Probing", "8-Quadratic Probing", 
                                 "9-Linear Probing-Own Scheme", 
                                 "10-Quadratic Probing-Own Scheme"};
      
      String quadAddC1C2Schemes[] = {"2-Quadratic Probing", "5-Quadratic Probing",
                                     "8-Quadratic Probing", "10-Quadratic Probing-Own Scheme",
                                     "2-Quadratic Probing", "5-Quadratic Probing",
                                     "8-Quadratic Probing", "10-Quadratic Probing-Own Scheme"};
      
      String chainingSchemes[] = {"3-Coalesced Chaining", 
                                  "6-Coalesced Chaining",
                                  "11-Coalesced Chaining"};
      
      // Probing schemes
      HashTableProbing [] htProbing = {ht1, ht2, ht4, ht5, ht7, ht8, ht9, ht10};
      // Additional testing for different c1 and c2 for schemes 2,5,8,10
      HashTableProbing [] htQuadAddC1C2 = {ht2_1_2, ht5_1_2, ht8_1_2, 
            ht10_1_2, ht2_2_3, ht5_2_3, ht8_2_3, ht10_2_3};
      // Chaining schemes
      HashTableInsideChaining [] htChaining = {ht3, ht6, ht11};
      

      /*
       * Insert keys from required input into all the tables
       */
      
      for (int j = 0; j < htProbing.length; ++j) {
         System.out.println(probingSchemes[j] + " ... inserting ...");
         for (Integer i : input)
            htProbing[j].insert(i, new Counter());
      }
      
      System.out.println("Testing Quadratic Probing with different c1 & c2 ...");
      for (int j = 0; j < htQuadAddC1C2.length; ++j) {
         for (Integer i : input)
            htQuadAddC1C2[j].insert(i, new Counter());
      }
      
      for (int j = 0; j < htChaining.length; ++j) {
         System.out.println(chainingSchemes[j] + " ... inserting ...");
         for (Integer i : input)
            htChaining[j].insert(i, new Counter());
      }
      System.out.println("\n");
      
      /*
       * Variables for printing out all the hash tables for all 11 schemes
       * and then user can enter a scheme number if he/she wishes to review
       * table and statistics for any particular scheme.  User entry uses 
       * switch statements.
       */
      String entry = "";
      int i = 0;
      int probing = 0;
      int chaining = 0;
      int totalSchemes = 11;
      boolean statsToCSV = false;
      Scanner scanner = new Scanner(System.in);
      
      
      entry = args[1].toUpperCase();
      
      while (entry.toUpperCase() != "Q") {
         
         switch(entry) {
         
            case "A":
               if (!statsToCSV) {
                  try {
                     BufferedWriter bw = new BufferedWriter(new FileWriter(args[2]));
                     bw.write("Scheme Name, # Elements Added, # Collisions, "
                           + "# Duplicates, # Elements Not Added, Elements Not Added\n");
                     bw.close();
                  } catch (IOException e) {
                     System.err.println("Error" + e);
                  }
               }
               for (i = 0; i < totalSchemes; ++i) {
                  if (i == 2 || i == 5 || i == 10) {
                     System.out.println("Scheme " + chainingSchemes[chaining]);
                     htChaining[chaining].printPretty(14, 24, 5);
                     System.out.println(htChaining[chaining].numElements() + " element(s) added");
                     System.out.println(htChaining[chaining].numCollisions() + " collision(s)"); 
                     System.out.println(htChaining[chaining].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htChaining[chaining].duplicates() + " duplicate(s)");
                     System.out.println();
                     
                     if (!statsToCSV) {
                        ReadHashInput.writeStatsToCSV(args[2], chainingSchemes[chaining], 
                              htChaining[chaining].numElements(), htChaining[chaining].numCollisions(), 
                              htChaining[chaining].duplicates(), htChaining[chaining].numElementsNotAdded(), 
                              htChaining[chaining].getElemsNotAdded());
                     }
                     
                     chaining++;
                  }
                  else if (i == 6 || i == 7) {
                     System.out.println("Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty3Buckets(14);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     System.out.println();
                     
                     if (!statsToCSV) {
                        ReadHashInput.writeStatsToCSV(args[2], probingSchemes[probing], 
                              htProbing[probing].numElements(), htProbing[probing].numCollisions(), 
                              htProbing[probing].duplicates(), htProbing[probing].numElementsNotAdded(), 
                              htProbing[probing].getElemsNotAdded());
                     }
                     
                     probing++;
                  }
                  else {
                     System.out.println("Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty(14, 24, 5);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     System.out.println();
                     
                     if (!statsToCSV) {
                        ReadHashInput.writeStatsToCSV(args[2], probingSchemes[probing], 
                              htProbing[probing].numElements(), htProbing[probing].numCollisions(), 
                              htProbing[probing].duplicates(), htProbing[probing].numElementsNotAdded(), 
                              htProbing[probing].getElemsNotAdded());
                     } 
                     
                     probing++;
                  }
               }
               /*
                * Write statistics for different values of c1 and c2 for
                * schemes 2,5,8,10
                */
               if (!statsToCSV) {
                  try {
                     BufferedWriter bw2 = new BufferedWriter(new FileWriter(args[2], true));
                     bw2.write("\n\nAdditional Test: c1=1 & c2=2\n");
                     bw2.close();
                     for (int a = 0; a < 4; ++a) {
                        ReadHashInput.writeStatsToCSV(args[2], quadAddC1C2Schemes[a], 
                              htQuadAddC1C2[a].numElements(), htQuadAddC1C2[a].numCollisions(), 
                              htQuadAddC1C2[a].duplicates(), htQuadAddC1C2[a].numElementsNotAdded(), 
                              htQuadAddC1C2[a].getElemsNotAdded());
                     }
                     BufferedWriter bw3 = new BufferedWriter(new FileWriter(args[2], true));
                     bw3.write("\n\nAdditional Test: c1=2 & c2=3\n");
                     bw3.close();
                     for (int a = 4; a < 8; ++a) {
                        ReadHashInput.writeStatsToCSV(args[2], quadAddC1C2Schemes[a], 
                              htQuadAddC1C2[a].numElements(), htQuadAddC1C2[a].numCollisions(), 
                              htQuadAddC1C2[a].duplicates(), htQuadAddC1C2[a].numElementsNotAdded(), 
                              htQuadAddC1C2[a].getElemsNotAdded());
                     }
                  
                  } catch (IOException e) {
                     System.err.println("Error" + e);
                  }
               }
               statsToCSV = true;
               i = 0;
               probing = 0;
               chaining = 0;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "Q":
               System.exit(1);
               break;
            
            case "1":
               System.out.println("Scheme " + probingSchemes[0]);
               htProbing[0].printPretty(14, 24, 5);
               System.out.println(htProbing[0].numElements() + " element(s) added");
               System.out.println(htProbing[0].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[0].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[0].duplicates() + " duplicate(s)");
               System.out.println();
               i = 1;
               probing = 1;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "2":
               System.out.println("Scheme " + probingSchemes[1]);
               htProbing[1].printPretty(14, 24, 5);
               System.out.println(htProbing[1].numElements() + " element(s) added");
               System.out.println(htProbing[1].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[1].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[1].duplicates() + " duplicate(s)");
               System.out.println();
               i = 2;
               probing = 2;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "3":
               System.out.println("Scheme " + chainingSchemes[0]);
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
               
            case "4":
               System.out.println("Scheme " + probingSchemes[2]);
               htProbing[2].printPretty(14, 24, 5);
               System.out.println(htProbing[2].numElements() + " element(s) added");
               System.out.println(htProbing[2].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[2].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[2].duplicates() + " duplicate(s)");
               System.out.println();
               i = 4;
               probing = 3;
               chaining = 1;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "5":
               System.out.println("Scheme " + probingSchemes[3]);
               htProbing[3].printPretty(14, 24, 5);
               System.out.println(htProbing[3].numElements() + " element(s) added");
               System.out.println(htProbing[3].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[3].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[3].duplicates() + " duplicate(s)");
               System.out.println();
               i = 5;
               probing = 4;
               chaining = 1;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "6":
               System.out.println("Scheme " + chainingSchemes[1]);
               htChaining[1].printPretty(14, 24, 5);
               System.out.println(htChaining[1].numElements() + " element(s) added");
               System.out.println(htChaining[1].numCollisions() + " collision(s)"); 
               System.out.println(htChaining[1].numElementsNotAdded() + " element(s) not added");
               System.out.println(htChaining[1].duplicates() + " duplicate(s)");
               System.out.println();
               chaining++;
               i = 6;
               probing = 4;
               chaining = 2;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "7":
               System.out.println("Scheme " + probingSchemes[4]);
               htProbing[4].printPretty3Buckets(14);
               System.out.println(htProbing[4].numElements() + " element(s) added");
               System.out.println(htProbing[4].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[4].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[4].duplicates() + " duplicate(s)");
               System.out.println();
               i = 7;
               probing = 5;
               chaining = 2;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "8":
               System.out.println("Scheme " + probingSchemes[5]);
               htProbing[5].printPretty3Buckets(14);
               System.out.println(htProbing[5].numElements() + " element(s) added");
               System.out.println(htProbing[5].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[5].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[5].duplicates() + " duplicate(s)");
               System.out.println();
               i = 8;
               probing = 6;
               chaining = 2;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "9":
               System.out.println("Scheme " + probingSchemes[6]);
               htProbing[6].printPretty(14, 24, 5);
               System.out.println(htProbing[6].numElements() + " element(s) added");
               System.out.println(htProbing[6].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[6].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[6].duplicates() + " duplicate(s)");
               System.out.println();
               i = 9;
               probing = 7;
               chaining = 2;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "10":
               System.out.println("Scheme " + probingSchemes[7]);
               htProbing[7].printPretty(14, 24, 5);
               System.out.println(htProbing[7].numElements() + " element(s) added");
               System.out.println(htProbing[7].numCollisions() + " collision(s)"); 
               System.out.println(htProbing[7].numElementsNotAdded() + " element(s) not added");
               System.out.println(htProbing[7].duplicates() + " duplicate(s)");
               System.out.println();
               i = 10;
               probing = 0;
               chaining = 2;
               entry = prompt(scanner).toUpperCase();
               break;
            
            case "11":
               System.out.println("Scheme " + chainingSchemes[2]);
               htChaining[2].printPretty(14, 24, 5);
               System.out.println(htChaining[2].numElements() + " element(s) added");
               System.out.println(htChaining[2].numCollisions() + " collision(s)"); 
               System.out.println(htChaining[2].numElementsNotAdded() + " element(s) not added");
               System.out.println(htChaining[2].duplicates() + " duplicate(s)");
               System.out.println();
               chaining++;
               i = 0;
               probing = 0;
               chaining = 0;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "R":
               for (; i < totalSchemes; ++i) {
                  if (i == 2 || i == 5 || i == 10) {
                     System.out.println("Scheme " + chainingSchemes[chaining]);
                     htChaining[chaining].printPretty(14, 24, 5);
                     System.out.println(htChaining[chaining].numElements() + " element(s) added");
                     System.out.println(htChaining[chaining].numCollisions() + " collision(s)"); 
                     System.out.println(htChaining[chaining].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htChaining[chaining].duplicates() + " duplicate(s)");
                     System.out.println();
                     chaining++;
                  }
                  else if (i == 6 || i == 7) {
                     System.out.println("Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty3Buckets(14);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     System.out.println();
                     probing++;
                  }
                  else {
                     System.out.println("Scheme " + probingSchemes[probing]);
                     htProbing[probing].printPretty(14, 24, 5);
                     System.out.println(htProbing[probing].numElements() + " element(s) added");
                     System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                     System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                     System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                     probing++;
                     System.out.println();
                  }
               }
               i = 0;
               probing = 0;
               chaining = 0;
               entry = prompt(scanner).toUpperCase();
               break;
               
            case "":
               if (i == 11) {
                  i = 0;
                  probing = 0;
                  chaining = 0;
               }
               if (i == 2 || i == 5 || i == 10) {
                  System.out.println("Scheme " + chainingSchemes[chaining]);
                  htChaining[chaining].printPretty(14, 24, 5);
                  System.out.println(htChaining[chaining].numElements() + " element(s) added");
                  System.out.println(htChaining[chaining].numCollisions() + " collision(s)"); 
                  System.out.println(htChaining[chaining].numElementsNotAdded() + " element(s) not added");
                  System.out.println(htChaining[chaining].duplicates() + " duplicate(s)");
                  System.out.println();
                  chaining++;
               }
               else if (i == 6 || i == 7) {
                  System.out.println("Scheme " + probingSchemes[probing]);
                  htProbing[probing].printPretty3Buckets(14);
                  System.out.println(htProbing[probing].numElements() + " element(s) added");
                  System.out.println(htProbing[probing].numCollisions() + " collision(s)"); 
                  System.out.println(htProbing[probing].numElementsNotAdded() + " element(s) not added");
                  System.out.println(htProbing[probing].duplicates() + " duplicate(s)");
                  System.out.println();
                  probing++;
               }
               else {
                  System.out.println("Scheme " + probingSchemes[probing]);
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
      System.out.println("Choose an entry below to print a scheme:");
      System.out.println("A/a: prints all schemes");
      System.out.println("1: prints scheme 1");
      System.out.println("2: prints scheme 2");
      System.out.println("3: prints scheme 3");
      System.out.println("4: prints scheme 4");
      System.out.println("5: prints scheme 5");
      System.out.println("6: prints scheme 6");
      System.out.println("7: prints scheme 7");
      System.out.println("8: prints scheme 8");
      System.out.println("9: prints scheme 9");
      System.out.println("10: prints scheme 10");
      System.out.println("11: prints scheme 11");
      System.out.println("R/r: prints remaining schemes");
      System.out.println("Enter: prints next");
      System.out.println("Q/q: quit");
      
      return scanner.nextLine();
      
   }
}
