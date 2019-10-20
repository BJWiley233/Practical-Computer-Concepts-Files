/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Implementation of Strassen’s method from text on page
 * 79. Run time is &theta;(n<sup>log<sub>2</sub>7</sup>).
 *
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class StrassensMethod {
   
   /*
    * class variable to count the # of multiplications
    * it is private so it cannot be access outside the class
    */
   private static int numberMultiplications = 0;
   
   /**
    * Use if you wanted to return number of multiplications and not have to
    * do it under {@link StrassensMethod#writeData(ArrayList, PrintWriter)}
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
    * Given file name in README is StrassensMethod_BrianWiley.txt
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
      
      Integer[][] c = strassensMethod(abList.get(0), abList.get(1));
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
    * Main method for Strassen's method.  Just like the others it take in two
    * matrices matrixA and matrixB.  Require the following helper methods
    * @param matrixA
    * @param matrixB
    * @return <b>matrixC</b> is the cross product from matrixA times matrixB
    */
   public static Integer[][] strassensMethod(Integer[][] matrixA, 
         Integer[][] matrixB) {
      
      int n = matrixA.length;
      Integer[][] matrixC = new Integer[n][n];
      Integer[][] a11 = subMatrices(matrixA, 1,1);
      Integer[][] a12 = subMatrices(matrixA, 1,2);
      Integer[][] a21 = subMatrices(matrixA, 2,1);
      Integer[][] a22 = subMatrices(matrixA, 2,2);
      Integer[][] b11 = subMatrices(matrixB, 1,1);
      Integer[][] b12 = subMatrices(matrixB, 1,2);
      Integer[][] b21 = subMatrices(matrixB, 2,1);
      Integer[][] b22 = subMatrices(matrixB, 2,2);
      
      if (n == 1) {
         matrixC[0][0] = matrixA[0][0] * matrixB[0][0];
         ++numberMultiplications;
      }

      else {
         Integer[][] s1 = diff(b12, b22);
         Integer[][] s2 = sum(a11, a12);
         Integer[][] s3 = sum(a21, a22);
         Integer[][] s4 = diff(b21, b11);
         Integer[][] s5 = sum(a11, a22);
         Integer[][] s6 = sum(b11, b22);
         Integer[][] s7 = diff(a12, a22);
         Integer[][] s8 = sum(b21, b22);
         Integer[][] s9 = diff(a11, a21);
         Integer[][] s10 = sum(b11, b12);
         
         Integer[][] p1 = strassensMethod(a11, s1);
         Integer[][] p2 = strassensMethod(s2,b22);
         Integer[][] p3 = strassensMethod(s3,b11);
         Integer[][] p4 = strassensMethod(a22, s4);
         Integer[][] p5 = strassensMethod(s5, s6);
         Integer[][] p6 = strassensMethod(s7, s8);
         Integer[][] p7 = strassensMethod(s9, s10);
         
         setSubMatrixInsideFull(matrixC, sum(diff(sum(p5, p4), p2), p6), 1, 1);
         setSubMatrixInsideFull(matrixC, sum(p1, p2), 1, 2);
         setSubMatrixInsideFull(matrixC, sum(p3, p4), 2, 1);
         setSubMatrixInsideFull(matrixC, diff(diff(sum(p5, p1), p3), p7), 2, 2);  
      }
      
      return matrixC;
   }

   /**
    * This method add two matrices.  Pretty simple, just add same index for
    * each matrix.
    * @param matrixA
    * @param matrixB
    * @return Integer[][] matrix of sum
    */
   public static Integer[][] sum(Integer[][] matrixA, Integer[][] matrixB) {
      Integer[][] c = new Integer[matrixA.length][matrixA.length];
      for (int i = 0; i < c.length; ++i) {
         for (int j = 0; j < c.length; ++j) {
            c[i][j] = matrixA[i][j] + matrixB[i][j];
         }
      }
      
      return c;
   }
   
   /**
    * This method add two matrices.  Pretty simple, just subtract same index 
    * for second matrix from first matrix.
    * @param matrixA
    * @param matrixB
    * @return Integer[][] matrix of difference
    */
   public static Integer[][] diff(Integer[][] matrixA, Integer[][] matrixB) {
      Integer[][] c = new Integer[matrixA.length][matrixA.length];
      for (int i = 0; i < c.length; ++i) {
         for (int j = 0; j < c.length; ++j) {
            c[i][j] = matrixA[i][j] - matrixB[i][j];
         }
      }
      
      return c;
   }

   /**
    * Depending on the subscript passed this will set the sub matrix inside 
    * the larger matrix.
    * @param fullMatrix
    * @param submatrix
    * @param subScript1
    * @param subScript2
    */
   public static void setSubMatrixInsideFull (Integer[][] fullMatrix, 
         Integer[][] submatrix, int subScript1, int subScript2) {
      
      int n = fullMatrix.length;
      int iIndex, jIndex;
      if (subScript1 == 1) 
         iIndex = 0;
      else 
         iIndex = n/2;
      if (subScript2 == 1)
         jIndex = 0;
      else 
         jIndex = n/2;

      for (int i = 0, i1 = iIndex; i < submatrix.length; ++i, ++i1) {
         for (int j = 0, j1 = jIndex; j < submatrix.length; ++j, ++j1) {
            fullMatrix[i1][j1] = submatrix[i][j];
            }
         }
   }
   
   /**
    * This will create a sub-matrix depending on the subscripts passed which
    * is used to divide the matrices by {@code n/2}.  Works like subMatrix
    * in SquareMatrixMultiplyRecursive.  I was try to see how to make it 
    * faster.  Didn't work.
    * @param matrix
    * @param subScript1
    * @param subScript2
    * @return Integer[][] sub-matrix
    * @see {@link SquareMatrixMultiplyRecursive#subMatrix(Integer[][], 
    * Integer[][], int, int)}
    */
   public static Integer[][] subMatrices(Integer[][] matrix, int subScript1, 
         int subScript2) {
      
      int n = matrix.length;
      Integer[][] c = new Integer[n/2][n/2];
      int iIndex, jIndex;
      if (subScript1 == 1) 
         iIndex = 0;
      else 
         iIndex = n/2;
      if (subScript2 == 1)
         jIndex = 0;
      else 
         jIndex = n/2;
      
      for (int i = 0, i1 = iIndex; i < c.length; ++i, ++i1) {
         for (int j = 0, j1 = jIndex; j < c.length; ++j, ++j1) {
               c[i][j] = matrix[i1][j1];
            }
         }
      return c;
   }

}
