/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 * This is the driver to read in the required input from LabStrassenInput.txt
 * You must call the following code from command line or linux/unix terminal:
 * 
 * <p>{@code javac DriverMatrixMultiplication.java}</p>
 * 
 * <p>{@code java DriverMatrixMultiplication.java 
 * LabStrassenInput.txt 
 * SquareMatrixMultiply_BrianWiley.txt 
 * SquareMatrixMultiplyRecursive_BrianWiley.txt 
 * StrassensMethod_BrianWiley.txt}</p>
 * 
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class DriverMatrixMultiplication {
   
   public static void main(String[] args) throws NotPowerOfTwoException {
      
      List<ArrayList<Integer[][]>> matrices = new ArrayList<ArrayList<Integer[][]>>();
      
      /*
       * The readData method from ReadInputMatrices class reads in the data
       * once and stores into a List of ArrayLists in which each ArrayList
       * include matrixA & matrixB for order 2, 4, 8.  The list is 3 ArrayLists
       * long.
       */
      try {
         BufferedReader input = new BufferedReader(new FileReader(args[0]));
         matrices = ReadInputMatrices.readData(input);   
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }
      
      /*
       * Print results to the text file for SquareMatrixMultiply non recursive.  
       * Given file name in the README is SquareMatrixMultiply_BrianWiley.txt
       */
      try {
         PrintWriter output = new PrintWriter(new FileWriter(args[1]));
         for (ArrayList<Integer[][]> al : matrices)
            SquareMatrixMultiply.writeData(al, output);
         output.flush();
         output.close();
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }

      /*
       * Print results to the text file for SquareMatrixMultiplyRecursive.  
       * Given file name in the README is 
       * SquareMatrixMultiplyRecursive_BrianWiley.txt
       */
      try {
         PrintWriter output = new PrintWriter(new FileWriter(args[2]));
         for (ArrayList<Integer[][]> al : matrices)
            SquareMatrixMultiplyRecursive.writeData(al, output);
         output.flush();
         output.close();
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }
      
      /*
       * Print results to the text file for Strassen's method.  Given file 
       * name in the README is StrassensMethod_BrianWiley.txt
       */
      try {
         PrintWriter output = new PrintWriter(new FileWriter(args[3]));
         for (ArrayList<Integer[][]> al : matrices)
            StrassensMethod.writeData(al, output);
         output.flush();
         output.close();
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }
      
      /*
       * Here we are just testing the speed comparison for SquareMatrixMultiply 
       * from page 75 and SquareMatrixMultiplyRecursive from page 77.  CLRS 
       * indicates both run times are Theta(n^3).  This actually isn't a fair 
       * comparison because in the text for the recursive algorithm there is 
       * a way to partition without coping 12 n/2 x n/2 matrices. I haven't 
       * figured out to do that.
       */
      Random rand = new Random();
      int totalRuns = 10000;
      int squareMatrixSize = 4;
      Integer[][] matrixA = new Integer[squareMatrixSize][squareMatrixSize];
      Integer[][] matrixB = new Integer[squareMatrixSize][squareMatrixSize];
      List<Integer[][]> totalAMatrices = new ArrayList<Integer[][]>();
      List<Integer[][]> totalBMatrices = new ArrayList<Integer[][]>();
      for (int i = 0; i < totalRuns; ++i) {
         for (int j = 0; j < squareMatrixSize; ++j) {
            for (int k = 0; k < squareMatrixSize; ++k) {
               matrixA[j][k] = rand.nextInt(10);
               matrixB[j][k] = rand.nextInt(10);
            }
         }
         totalAMatrices.add(matrixA);
         totalBMatrices.add(matrixB);
      }
      
      // start, end time variables and running of squareMatrixMultiply
      long startNonRec = System.currentTimeMillis();
      for (int i = 0; i < totalRuns; ++i) {
         SquareMatrixMultiply.squareMatrixMultiply(totalAMatrices.get(i), 
               totalBMatrices.get(i));
      }
      long endNonRec = System.currentTimeMillis();
      
      // start, end time variables and running of squareMatrixMulitplyRecursive
      long startRec = System.currentTimeMillis();
      for (int i = 0; i < totalRuns; ++i) {
         SquareMatrixMultiplyRecursive.squareMatrixMulitplyRecursive(
               totalAMatrices.get(i), totalBMatrices.get(i));
      }
      long endRec = System.currentTimeMillis();
      
      // start, end time variables and running of strassensMethod
      long startStrassen = System.currentTimeMillis();
      for (int i = 0; i < totalRuns; ++i) {
         StrassensMethod.strassensMethod(totalAMatrices.get(i), 
               totalBMatrices.get(i));
      }
      long endStrassen = System.currentTimeMillis();
      
      // Output runtime for SquareMatrixMultiply non-recursive page 75 in CLRS
      try {
         PrintWriter output = new PrintWriter(new FileWriter(args[1], true));
         output.println("Total run time for " + totalRuns + " runs of matrix "
               + "order " + squareMatrixSize + " for SquareMatrixMultiply" +
               " is " + (endNonRec-startNonRec) + "ms for average run of " + 
               (endNonRec-startNonRec)/(double)totalRuns + "ms.");

         output.close();
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }
      
      // Output runtime for SquareMatrixMultiplyRecursive page 77 in CLRS
      try {
         PrintWriter output = new PrintWriter(new FileWriter(args[2], true));
         output.println("Total run time for " + totalRuns + " runs of matrix "
               + "order " + squareMatrixSize + " for SquareMatrixMultiplyRecursive" 
               + " is " + (endRec-startRec) + "ms for average run of " 
               + (endRec-startRec)/(double)totalRuns + "ms.");

         output.close();
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }    
      
      // Output runtime for Strassen's method page 79 in CLRS
      try {
         PrintWriter output = new PrintWriter(new FileWriter(args[3], true));
         output.println("Total run time for " + totalRuns + " runs of matrix "
               + "order " + squareMatrixSize + " for Strassen's Method" 
               + " is " + (endStrassen-startStrassen) + "ms for average run "
               + "of " + (endStrassen-startStrassen)/(double)totalRuns + "ms.");

         output.close();
      } catch (IOException e) {
         System.out.print("Error: " + e);
         System.exit(1);
      }
      
   }
}
