/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Implementation of SQUARE-MATRIX-MULTIPLY(A,B) from text on page
 * 75. Run time is &theta;(n<sup>3</sup>).
 *
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class SquareMatrixMultiply {
   
   /*
    * class variable to count the # of multiplications
    * it is private so it cannot be access outside the class
    */   
   private static int numberMultiplications = 0; 
   
   /**
    * Use if you wanted to return number of multiplications and not have to
    * do it under {@link SquareMatrixMultiply#writeData(ArrayList, 
    * PrintWriter)}
    * @return <b>numberMultiplications</b>
    */
   public static int returnNumMult() {
      return numberMultiplications;
   }
   
   /**
    * This method will be called from driver to write data to the given 
    * PrintWriter with name of file for output.  It will take in both 
    * matrixA and matrixB together in an ArrayList.
    * <p>
    * Given file name in README is SquareMatrixMultiply_BrianWiley.txt
    * @param abList ArrayList that contains matrixA and matrixB
    * @param output PrinterWriter
    */
   public static void writeData(ArrayList<Integer[][]> abList, 
         PrintWriter output) {
      
      output.println("Input:");
      output.println(abList.get(0).length);
      for (int i = 0; i < abList.get(0).length; ++i) {
         for (int j = 0; j < abList.get(0).length; ++j) {
            output.print(abList.get(0)[i][j] + " ");
         }
         output.println();
      }
      for (int i = 0; i < abList.get(1).length; ++i) {
         for (int j = 0; j < abList.get(1).length; ++j) {
            output.print(abList.get(1)[i][j] + " ");
         }
         output.println();
      }
      output.println("Answer:");
      
      Integer[][] c = squareMatrixMultiply(abList.get(0), abList.get(1));
      for (int i = 0; i < c.length; ++i) {
         for (int j = 0; j < c.length; ++j) {
            output.print(c[i][j] + " ");
         }
         output.println();
      }
      output.println("Total Multiplications: " + numberMultiplications);
      numberMultiplications = 0;
      output.println();
   }
   
   /**
    * This is the main method in the class that implements the psuedocode from
    * page 75 in CLRS text.  It will take in matrixA and matrixB and return the 
    * cross product in a new matrixC.
    * @param matrixA
    * @param matrixB
    * @return <b>matrixC</b> is the cross product from matrixA times matrixB
    */
   public static Integer[][] squareMatrixMultiply(Integer[][] matrixA, 
         Integer[][] matrixB) {
      
      int n = matrixA.length;
      Integer[][] matrixC = new Integer[n][n];
      for (int i = 0; i < n; ++i) {
         for (int j = 0; j < n; ++j) {
            matrixC[i][j] = 0;
            for (int k = 0; k < n; ++k) {
               matrixC[i][j] = matrixC[i][j] + (matrixA[i][k] * matrixB[k][j]);
               ++numberMultiplications;
            }
         }
      }
      
      return matrixC;
   }
   
}
