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

/**
 * Additional testing for: 
 * <p>85 integers with 5 duplicates in data</p>
 * <p>135 integers with 5 duplicates in data</p>
 * <p>125 Kmers in a list format</p>
 * <p>Fasta file for gene of mouse</p>
 * @author bjwil
 *
 * @see {@code README file in zip folder}
 */
public class DriverHashAdditional {

   @SuppressWarnings({ "unchecked", "rawtypes" })
   public static void main(String[] args) throws IOException {

      /*
       * Arrays for instantiating the hash tables with schema parameters
       * to be passed to the constuctors.  There is only 8 as we repeat
       * schemes 1-3 with our own hasing scheme so parameter for 
       */
      int htSlots[] = {120, 120, 120, 120, 120, 120, 120, 120};
      int htModulo[] = {120, 120, 120, 113, 113, 113, 41, 41};
      int buckets[] = {1, 1, 1, 1, 1, 1, 3, 3};
      double c1[] = {1, (double)1/2, 0, 1, (double)1/2, 0, 1, (double)1/2};
      double c2[] = {0, (double)1/2, 0, 0, (double)1/2, 0, 0, (double)1/2};
      boolean isDivision[] = {true, true, true, true, true, true, true, true};
      
      String probingSchemes[] = {"1-Linear Probing", "2-Quadratic Probing", 
            "4-Linear Probing", "5-Quadratic Probing", 
            "7-Linear Probing", "8-Quadratic Probing", 
            "9-Linear Probing-Own Scheme", 
            "10-Quadratic Probing-Own Scheme"};
      String chainingSchemes[] = {"3-Coalesced Chaining", 
             "6-Coalesced Chaining",
             "11-Coalesced Chaining"};
      
      int i = 0;
      int probing = 0;
      int chaining = 0;
      int totalSchemes = 11;
      
      // Read input for 85 integers
      List<Integer> input85 = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         input85 = ReadHashInput.readData(br, "int", 0);
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      HashTableProbing<Integer, Counter> ht1_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isDivision[0]);
      
      HashTableProbing<Integer, Counter> ht2_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], isDivision[1]);
      
      HashTableInsideChaining<Integer, Counter> ht3_85 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  isDivision[2]);
      
      HashTableProbing<Integer, Counter> ht4_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[3], htModulo[3], buckets[3], 
                  c1[3], c2[3], isDivision[3]);
      
      HashTableProbing<Integer, Counter> ht5_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  c1[4], c2[4], isDivision[4]);
      
      HashTableInsideChaining<Integer, Counter> ht6_85 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[5], htModulo[5], buckets[5], 
                  isDivision[5]);
      
      HashTableProbing<Integer, Counter> ht7_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[6], htModulo[6], buckets[6], 
                  c1[6], c2[6], isDivision[6]);
      
      HashTableProbing<Integer, Counter> ht8_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  c1[7], c2[7], isDivision[7]);
      
      HashTableProbing<Integer, Counter> ht9_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], false);
      
      HashTableProbing<Integer, Counter> ht10_85 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], false);
      
      HashTableInsideChaining<Integer, Counter> ht11_85 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  false);
      
      HashTableProbing [] htProbing_85 = {ht1_85, ht2_85, ht4_85, ht5_85, ht7_85, ht8_85, ht9_85, ht10_85};
      HashTableInsideChaining [] htChaining_85 = {ht3_85, ht6_85, ht11_85};
      
      for (int j = 0; j < htProbing_85.length; ++j) {
         System.out.println(probingSchemes[j]);
         for (Integer in : input85)
            htProbing_85[j].insert(in, new Counter());
      }
      
      for (int j = 0; j < htChaining_85.length; ++j) {
         System.out.println(chainingSchemes[j]);
         for (Integer in : input85)
            htChaining_85[j].insert(in, new Counter());
      }
      
      try {
         BufferedWriter bw85 = new BufferedWriter(new FileWriter(args[4]));
         bw85.write("Testing 85 Integers\n");
         bw85.write("Scheme Name, # Elements Added, # Collisions, "
               + "# Duplicates, # Elements Not Added, Elements Not Added\n");
         bw85.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      for (i = 0; i < totalSchemes; ++i) {
         if (i == 2 || i == 5 || i == 10) {
            ReadHashInput.writeStatsToCSV(args[4], chainingSchemes[chaining], 
                  htChaining_85[chaining].numElements(), htChaining_85[chaining].numCollisions(), 
                  htChaining_85[chaining].duplicates(), htChaining_85[chaining].numElementsNotAdded(), 
                  htChaining_85[chaining].getElemsNotAdded());
            chaining++;
         }
         else if (i == 6 || i == 7) {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_85[probing].numElements(), htProbing_85[probing].numCollisions(), 
                  htProbing_85[probing].duplicates(), htProbing_85[probing].numElementsNotAdded(), 
                  htProbing_85[probing].getElemsNotAdded());
         probing++;
         }
         else {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_85[probing].numElements(), htProbing_85[probing].numCollisions(), 
                  htProbing_85[probing].duplicates(), htProbing_85[probing].numElementsNotAdded(), 
                  htProbing_85[probing].getElemsNotAdded());
         probing++;
         }
         
      }
      System.out.println();
      i = 0;
      probing = 0;
      chaining = 0;
      
      
      // Read input for 135 integers
      List<Integer> input135 = new ArrayList<Integer>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[1]));
         input135 = ReadHashInput.readData(br, "int", 0);
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      HashTableProbing<Integer, Counter> ht1_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isDivision[0]);
      
      HashTableProbing<Integer, Counter> ht2_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], isDivision[1]);
      
      HashTableInsideChaining<Integer, Counter> ht3_135 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  isDivision[2]);
      
      HashTableProbing<Integer, Counter> ht4_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[3], htModulo[3], buckets[3], 
                  c1[3], c2[3], isDivision[3]);
      
      HashTableProbing<Integer, Counter> ht5_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  c1[4], c2[4], isDivision[4]);
      
      HashTableInsideChaining<Integer, Counter> ht6_135 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[5], htModulo[5], buckets[5], 
                  isDivision[5]);
      
      HashTableProbing<Integer, Counter> ht7_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[6], htModulo[6], buckets[6], 
                  c1[6], c2[6], isDivision[6]);
      
      HashTableProbing<Integer, Counter> ht8_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  c1[7], c2[7], isDivision[7]);
      
      HashTableProbing<Integer, Counter> ht9_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], false);
      
      HashTableProbing<Integer, Counter> ht10_135 = 
            new HashTableProbing<Integer, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], false);
      
      HashTableInsideChaining<Integer, Counter> ht11_135 = 
            new HashTableInsideChaining<Integer, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  false);
      
      HashTableProbing [] htProbing_135 = {ht1_135, ht2_135, ht4_135, ht5_135, ht7_135, ht8_135, ht9_135, ht10_135};
      HashTableInsideChaining [] htChaining_135 = {ht3_135, ht6_135, ht11_135};
      
      for (int j = 0; j < htProbing_135.length; ++j) {
         System.out.println(probingSchemes[j]);
         for (Integer in : input135)
            htProbing_135[j].insert(in, new Counter());
      }
      
      for (int j = 0; j < htChaining_135.length; ++j) {
         System.out.println(chainingSchemes[j]);
         for (Integer in : input135)
            htChaining_135[j].insert(in, new Counter());
      }
      
      try {
         BufferedWriter bw135 = new BufferedWriter(new FileWriter(args[4], true));
         bw135.write("\nTesting 135 Integers\n");
         bw135.write("Scheme Name, # Elements Added, # Collisions, "
               + "# Duplicates, # Elements Not Added, Elements Not Added\n");
         bw135.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      for (i = 0; i < totalSchemes; ++i) {
         if (i == 2 || i == 5 || i == 10) {
            ReadHashInput.writeStatsToCSV(args[4], chainingSchemes[chaining], 
                  htChaining_135[chaining].numElements(), htChaining_135[chaining].numCollisions(), 
                  htChaining_135[chaining].duplicates(), htChaining_135[chaining].numElementsNotAdded(), 
                  htChaining_135[chaining].getElemsNotAdded());
            chaining++;
         }
         else if (i == 6 || i == 7) {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_135[probing].numElements(), htProbing_135[probing].numCollisions(), 
                  htProbing_135[probing].duplicates(), htProbing_135[probing].numElementsNotAdded(), 
                  htProbing_135[probing].getElemsNotAdded());
         probing++;
         }
         else {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_135[probing].numElements(), htProbing_135[probing].numCollisions(), 
                  htProbing_135[probing].duplicates(), htProbing_135[probing].numElementsNotAdded(), 
                  htProbing_135[probing].getElemsNotAdded());
         probing++;
         }
         
      }
      System.out.println();
      i = 0;
      probing = 0;
      chaining = 0;
      
      
      // Read input for 125 Kmer strings in list
      List<String> input_kmerList = new ArrayList<String>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[2]));
         input_kmerList = ReadHashInput.readData(br, "str", 0);
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      HashTableProbing<String, Counter> ht1_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isDivision[0]);
      
      HashTableProbing<String, Counter> ht2_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], isDivision[1]);
      
      HashTableInsideChaining<String, Counter> ht3_kmerList = 
            new HashTableInsideChaining<String, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  isDivision[2]);
      
      HashTableProbing<String, Counter> ht4_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[3], htModulo[3], buckets[3], 
                  c1[3], c2[3], isDivision[3]);
      
      HashTableProbing<String, Counter> ht5_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  c1[4], c2[4], isDivision[4]);
      
      HashTableInsideChaining<String, Counter> ht6_kmerList = 
            new HashTableInsideChaining<String, Counter>(htSlots[5], htModulo[5], buckets[5], 
                  isDivision[5]);
      
      HashTableProbing<String, Counter> ht7_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[6], htModulo[6], buckets[6], 
                  c1[6], c2[6], isDivision[6]);
      
      HashTableProbing<String, Counter> ht8_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  c1[7], c2[7], isDivision[7]);
      
      HashTableProbing<String, Counter> ht9_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], false);
      
      HashTableProbing<String, Counter> ht10_kmerList = 
            new HashTableProbing<String, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], false);
      
      HashTableInsideChaining<String, Counter> ht11_kmerList = 
            new HashTableInsideChaining<String, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  false);
      
      HashTableProbing [] htProbing_kmerList = {ht1_kmerList, ht2_kmerList, ht4_kmerList, 
            ht5_kmerList, ht7_kmerList, ht8_kmerList, ht9_kmerList, ht10_kmerList};
      HashTableInsideChaining [] htChaining_kmerList = {ht3_kmerList, ht6_kmerList, ht11_kmerList};
      
      for (int j = 0; j < htProbing_kmerList.length; ++j) {
         System.out.println(probingSchemes[j]);
         for (String str : input_kmerList)
            htProbing_kmerList[j].insert(str, new Counter());
      }
      
      for (int j = 0; j < htChaining_kmerList.length; ++j) {
         System.out.println(chainingSchemes[j]);
         for (String str : input_kmerList)
            htChaining_kmerList[j].insert(str, new Counter());
      }
      
      try {
         BufferedWriter bwKmerList = new BufferedWriter(new FileWriter(args[4], true));
         bwKmerList.write("\nTesting 125 Kmers List\n");
         bwKmerList.write("Scheme Name, # Elements Added, # Collisions, "
               + "# Duplicates, # Elements Not Added, Elements Not Added\n");
         bwKmerList.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      for (i = 0; i < totalSchemes; ++i) {
         if (i == 2 || i == 5 || i == 10) {
            ReadHashInput.writeStatsToCSV(args[4], chainingSchemes[chaining], 
                  htChaining_kmerList[chaining].numElements(), htChaining_kmerList[chaining].numCollisions(), 
                  htChaining_kmerList[chaining].duplicates(), htChaining_kmerList[chaining].numElementsNotAdded(), 
                  htChaining_kmerList[chaining].getElemsNotAdded());
            chaining++;
         }
         else if (i == 6 || i == 7) {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_kmerList[probing].numElements(), htProbing_kmerList[probing].numCollisions(), 
                  htProbing_kmerList[probing].duplicates(), htProbing_kmerList[probing].numElementsNotAdded(), 
                  htProbing_kmerList[probing].getElemsNotAdded());
         probing++;
         }
         else {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_kmerList[probing].numElements(), htProbing_kmerList[probing].numCollisions(), 
                  htProbing_kmerList[probing].duplicates(), htProbing_kmerList[probing].numElementsNotAdded(), 
                  htProbing_kmerList[probing].getElemsNotAdded());
         probing++;
         }
         
      }
      System.out.println();
      i = 0;
      probing = 0;
      chaining = 0;
      
      // Read inputs from fasta file to retrieve kmers from sliding window
      List<String> inputFasta = new ArrayList<String>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[3]));
         inputFasta = ReadHashInput.readData(br, "fasta", 4); // last parameter is kmer size
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      HashTableProbing<String, Counter> ht1_fasta = 
            new HashTableProbing<String, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], isDivision[0]);
      
      HashTableProbing<String, Counter> ht2_fasta = 
            new HashTableProbing<String, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], isDivision[1]);
      
      HashTableInsideChaining<String, Counter> ht3_fasta = 
            new HashTableInsideChaining<String, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  isDivision[2]);
      
      HashTableProbing<String, Counter> ht4_fasta = 
            new HashTableProbing<String, Counter>(htSlots[3], htModulo[3], buckets[3], 
                  c1[3], c2[3], isDivision[3]);
      
      HashTableProbing<String, Counter> ht5_fasta = 
            new HashTableProbing<String, Counter>(htSlots[4], htModulo[4], buckets[4], 
                  c1[4], c2[4], isDivision[4]);
      
      HashTableInsideChaining<String, Counter> ht6_fasta = 
            new HashTableInsideChaining<String, Counter>(htSlots[5], htModulo[5], buckets[5], 
                  isDivision[5]);
      
      HashTableProbing<String, Counter> ht7_fasta = 
            new HashTableProbing<String, Counter>(htSlots[6], htModulo[6], buckets[6], 
                  c1[6], c2[6], isDivision[6]);
      
      HashTableProbing<String, Counter> ht8_fasta = 
            new HashTableProbing<String, Counter>(htSlots[7], htModulo[7], buckets[7], 
                  c1[7], c2[7], isDivision[7]);
      
      HashTableProbing<String, Counter> ht9_fasta = 
            new HashTableProbing<String, Counter>(htSlots[0], htModulo[0], buckets[0], 
                  c1[0], c2[0], false);
      
      HashTableProbing<String, Counter> ht10_fasta = 
            new HashTableProbing<String, Counter>(htSlots[1], htModulo[1], buckets[1], 
                  c1[1], c2[1], false);
      
      HashTableInsideChaining<String, Counter> ht11_fasta = 
            new HashTableInsideChaining<String, Counter>(htSlots[2], htModulo[2], buckets[2], 
                  false);
      
      HashTableProbing [] htProbing_fasta = {ht1_fasta, ht2_fasta, ht4_fasta, 
            ht5_fasta, ht7_fasta, ht8_fasta, ht9_fasta, ht10_fasta};
      HashTableInsideChaining [] htChaining_fasta = {ht3_fasta, ht6_fasta, ht11_fasta};
      
      for (int j = 0; j < htProbing_fasta.length; ++j) {
         System.out.println(probingSchemes[j]);
         for (String str : inputFasta)
            htProbing_fasta[j].insert(str, new Counter());
      }
      
      for (int j = 0; j < htChaining_fasta.length; ++j) {
         System.out.println(chainingSchemes[j]);
         for (String str : inputFasta)
            htChaining_fasta[j].insert(str, new Counter());
      }
      
      try {
         BufferedWriter bwFasta = new BufferedWriter(new FileWriter(args[4], true));
         bwFasta.write("\nTesting Fasta\n");
         bwFasta.write("Scheme Name, # Elements Added, # Collisions, "
               + "# Duplicates, # Elements Not Added, Elements Not Added\n");
         bwFasta.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      
      for (i = 0; i < totalSchemes; ++i) {
         if (i == 2 || i == 5 || i == 10) {
            ReadHashInput.writeStatsToCSV(args[4], chainingSchemes[chaining], 
                  htChaining_fasta[chaining].numElements(), htChaining_fasta[chaining].numCollisions(), 
                  htChaining_fasta[chaining].duplicates(), htChaining_fasta[chaining].numElementsNotAdded(), 
                  htChaining_fasta[chaining].getElemsNotAdded());
            chaining++;
         }
         else if (i == 6 || i == 7) {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_fasta[probing].numElements(), htProbing_fasta[probing].numCollisions(), 
                  htProbing_fasta[probing].duplicates(), htProbing_fasta[probing].numElementsNotAdded(), 
                  htProbing_fasta[probing].getElemsNotAdded());
         probing++;
         }
         else {
            ReadHashInput.writeStatsToCSV(args[4], probingSchemes[probing], 
                  htProbing_fasta[probing].numElements(), htProbing_fasta[probing].numCollisions(), 
                  htProbing_fasta[probing].duplicates(), htProbing_fasta[probing].numElementsNotAdded(), 
                  htProbing_fasta[probing].getElemsNotAdded());
         probing++;
         }
         
      }
      System.out.println();
      
      
      /*
       * write hash table for fasta for first scheme and comparator sorting to csv
       * Writing to FastaOutputAndSorting_Scheme1.csv
       */
      ReadHashInput.writeFastaResults1(args[5], probingSchemes[0], ht1_fasta.getHashTable());
      
      /*
       * Test the sorting comparators for the fasta for just first scheme
       * Print to console and writing to FastaOutputAndSorting_Scheme1.csv
       */
      
      // sort by count descending
      try { 
         BufferedWriter bwFastaComp = new BufferedWriter(new FileWriter(args[5], true));
         bwFastaComp.write("Sorting by descending value/count\n");
         bwFastaComp.write("Key,Value\n");
         System.out.println("Sorting by descending value/count");
         for (KeyValue kv : ht1_fasta.flattenSort("v", "d", true, 10)) {
            System.out.println("Key: " + kv.getKey() + ", Count: " + kv.getValue());
            bwFastaComp.write(kv.getKey() + "," + kv.getValue() + "\n");
         }
         bwFastaComp.write("\n");
         bwFastaComp.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      System.out.println();
      
      // sort by count ascending
      try { 
         BufferedWriter bwFastaComp = new BufferedWriter(new FileWriter(args[5], true));
         bwFastaComp.write("Sorting by ascending value/count\n");
         bwFastaComp.write("Key,Value\n");
         System.out.println("Sorting by ascending value/count");
         for (KeyValue kv : ht1_fasta.flattenSort("v", "a", true, 10)) {
            System.out.println("Key: " + kv.getKey() + ", Count: " + kv.getValue());
            bwFastaComp.write(kv.getKey() + "," + kv.getValue() + "\n");
         }
         bwFastaComp.write("\n");
         bwFastaComp.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      System.out.println();
      
   // sort by key descending
      try { 
         BufferedWriter bwFastaComp = new BufferedWriter(new FileWriter(args[5], true));
         bwFastaComp.write("Sorting by descending key\n");
         bwFastaComp.write("Key\n");
         System.out.println("Sorting by descending key");
         for (KeyValue kv : ht1_fasta.flattenSort("k", "d", true, 10)) {
            System.out.println("Key: " + kv.getKey());
            bwFastaComp.write(kv.getKey() + "\n");
         }
         bwFastaComp.write("\n");
         bwFastaComp.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }
      System.out.println();
      
      // sort by key ascending
      try { 
         BufferedWriter bwFastaComp = new BufferedWriter(new FileWriter(args[5], true));
         bwFastaComp.write("Sorting by ascending key\n");
         bwFastaComp.write("Key\n");
         System.out.println("Sorting by ascending key");
         for (KeyValue kv : ht1_fasta.flattenSort("k", "brian", true, 10)) {
            System.out.println("Key: " + kv.getKey());
            bwFastaComp.write(kv.getKey() + "\n");
         }
         bwFastaComp.write("\n");
         bwFastaComp.close();
      } catch (IOException e) {
         System.err.println("Error" + e);
      }


   }

}
