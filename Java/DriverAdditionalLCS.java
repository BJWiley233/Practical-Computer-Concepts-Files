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
 * Runs additional sequences against required input sequences as well as
 * does a pairwise comparison of the p53 tumor suppressor antigen protein.
 * Can be ran from the folder Submission/src with 
 * <p>{@code java DriverAdditionalLCS.java ../DynamicLab2Input.txt 
 * ../DynamicAdditionalInput.txt ../DynamicLab2AdditionalOutput.txt 
 * ../uniprot-id_P04637+OR+id_P02340+OR+id_P10361+OR+id_P56423.fasta 
 * ../FastAOutput.txt}
 * @author bjwil
 *
 */
public class DriverAdditionalLCS {

   public static void main(String[] args) {
      
      // list for required input
      List<String> input = new ArrayList<String>();
      
      try {
         System.out.println("Reading in..." + args[0]);
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         input = ReadDynamicInput.inputList(br);
         br.close();
      } catch (IOException e) {
         System.out.println("Error: " + e);
      }
      System.out.println();
      
      // list for addition input to compare to required input
      List<String> additionalInput = new ArrayList<String>();
      
      try {
         System.out.println("Reading in..." + args[1]);
         BufferedReader br = new BufferedReader(new FileReader(args[1]));
         additionalInput = ReadDynamicInput.inputList(br);
         br.close();
      } catch (IOException e) {
         System.out.println("Error: " + e);
      }
      System.out.println();
      
      /*
       *  does a comparison for each of the 4 additional inputs with each
       *  of the 4 required inputs for total of 16 comparisons
       */
      try {
         BufferedWriter bw = new BufferedWriter(new FileWriter(args[2]));
      
         for (int i = 0 ; i < additionalInput.size(); ++i) {
            for (int j = 0; j < input.size(); ++j) {
               LCS longCommSeq = new LCS(additionalInput.get(i), input.get(j));
               System.out.println("Longest Common Subequence between additional input " +
                     (i+1) + " and S" + (j+1) + " has length " + 
                     longCommSeq.lcsLength());
               bw.write("Longest Common Subequence between additional input " +
                     (i+1) + " and S" + (j+1) + " has length " + 
                     longCommSeq.lcsLength() + "\n");
               longCommSeq.setLCS();
               System.out.print("Sequence is: " + longCommSeq.getLCS());
               bw.write("Sequence is: " + longCommSeq.getLCS() + "\n");
               System.out.println("\n");
               bw.newLine();
            }
         }
         bw.close();
      } catch (IOException e) {
         System.out.println("Error " + e);
      }
      
      System.out.println("Results written to " + args[2]);
      System.out.println("\n\n");
      
      // blinker warning that processing FastA for p53 sequences
      try {
         for (int i = 0; i < 4; i++) {
            System.out.print("\rWait! reading in Fasta    ");
            Thread.sleep(500);
            System.out.print("\rWait! reading in Fasta.  ");
            Thread.sleep(500);
            System.out.print("\rWait! reading in Fasta.. ");
            Thread.sleep(500);
            System.out.print("\rWait! reading in Fasta...");
            Thread.sleep(500);
         }
         System.out.println("\rDone!                    ");
      } catch (Exception e) {
         System.out.println("Error " + e);
      }
      System.out.println();
      
      /*
       * Get Longest Common Subsequence of P53 tumor supressor protein between
       * all pairs:
       * Rattus norvegicus - Rat
       * Macaca fascicularis - Crab-eating macaque (cynomolgus monkey)
       * Mus musculus - Mouse
       * Homo sapiens - Human
       */
      List<ArrayList<String>> seqs = new ArrayList<ArrayList<String>>();
      
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[3]));
         seqs = ReadDynamicInput.readFastaMultiple(br);
         br.close();
      } catch (IOException e) {
         System.out.println(e);
      }
      
      double bestMatch = -1;
      double match;
      int firstSpecies = 0;
      int secondSpecies = 0;
      
      // do pairwise comparison and keeping track of best match
      try {
         BufferedWriter bw = new BufferedWriter(new FileWriter(args[4]));
      
         for (int i = 0 ; i < seqs.size()-1; ++i) {
            for (int j = i+1; j < seqs.size(); ++j) {
               LCS longCommSeq = new LCS(seqs.get(i).get(1), seqs.get(j).get(1));
               System.out.println("Longest Common Subequence between " +
                     seqs.get(i).get(0) + " and " + seqs.get(j).get(0) + 
                     " has length " + longCommSeq.lcsLength());
               bw.write("Longest Common Subequence between " +
                     seqs.get(i).get(0) + " and " + seqs.get(j).get(0) + 
                     " has length " + longCommSeq.lcsLength() + "\n");
               longCommSeq.setLCS();
               System.out.println("Sequence is: " + longCommSeq.getLCS());
               bw.write("Sequence is: " + longCommSeq.getLCS() + "\n");
               match = (double)longCommSeq.lcsLength()/((seqs.get(i).get(1).length() +
                     seqs.get(i).get(1).length())/2);
               System.out.println("Percent match based on average length is: " +
                    match);
               bw.write("Percent match based on average length is: " + match + "\n\n");
               System.out.println();
               if (match > bestMatch) {
                  bestMatch = match;
                  firstSpecies = i;
                  secondSpecies = j;
               }
            }
         }
         
         // output highest match
         System.out.println("Highest match was between " + 
               seqs.get(firstSpecies).get(0) + " and " + 
               seqs.get(secondSpecies).get(0) + " with match of " + 
               String.format("%.2f", bestMatch * 100.0) + "%.");
         bw.write("Highest match was between " + 
               seqs.get(firstSpecies).get(0) + " and " + 
               seqs.get(secondSpecies).get(0) + " with match of " + 
               String.format("%.2f", bestMatch * 100.0) + "%.");
         bw.close();
      } catch (IOException e) {
         System.out.println("Error " + e);
      }
      System.out.println();
      
      System.out.println("Results written to " + args[4]);
      
   }

}
