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
 * Main driver for the required input from DynamicLab2Input.txt and do all
 * pairwise combinations for Longest Common Subsequence in each pair.  Can
 * be ran from the folder Submission/src with 
 * <p>{@code java DriverLCS.java ../DynamicLab2Input.txt ../DynamicLab2Output.txt}
 * @author bjwil
 *
 */
public class DriverLCS {

   public static void main(String[] args) throws IOException {
      
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
      
      // runs each pairwise comparison for LCS and writes to file
      try {
         BufferedWriter bw = new BufferedWriter(new FileWriter(args[1]));
      
         for (int i = 0 ; i < input.size()-1; ++i) {
            for (int j = i+1; j < input.size(); ++j) {
               LCS longCommSeq = new LCS(input.get(i), input.get(j));
               System.out.println("Longest Common Subequence between S" +
                     (i+1) + " and S" + (j+1) + " has length " + 
                     longCommSeq.lcsLength());
               bw.write("Longest Common Subequence between S" +
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
      
      System.out.println("Results written to " + args[1]);

   }

}
