/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * Implementation of SQUARE-MATRIX-MULTIPL-RECURSIVE(A,B) from text on page
 * 77. Run time is &theta;(n<sup>3</sup>).  
 *
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class SquareMatrixMultiplyRecursive {
   
   /*
    * class variable to count the # of multiplications
    * it is private so it cannot be access outside the class
    */
   private static int numberMultiplications = 0;  

   /**
    * Use if you wanted to return number of multiplications and not have to
    * do it under {@link SquareMatrixMultiplyRecursive#writeData(ArrayList, 
    * PrintWriter)}
    * @return <b>numberMultiplications</b>
    */
   public static int returnNumMult() {
      return numberMultiplications;
   }
   
      
   /**
    * Method to write data for each class.  Basically the only line that changes
    * in each class is the one that calls the main method:
    * 
    * <ul><li>{@code Integer[][] c = squareMatrixMulitplyRecursive(abList.get(0), 
    * abList.get(1));}</li></ul>
    * 
    * @param abList ArrayLists that contains both matrices.
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
      
      Integer[][] c = squareMatrixMulitplyRecursive(abList.get(0), abList.get(1));
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
	 * Implementation of SQUARE-MATRIX-MULTIPLY-RECURSIVE(A, B) in the text.  
	 * Requires helper functions for partitioning T(n/2) matrices A, B and 
	 * then joining back to build final matrix C.
	 * 
	 * @param matrixA
	 * @param matrixB
	 * @return <b>matrixC</b> is the cross product from matrixA times matrixB
	 * @see {@linkplain SquareMatrixMultiplyRecursive#subMatrix(Integer[][], 
	 * Integer[][], int, int)}
	 * @see {@linkplain SquareMatrixMultiplyRecursive#sum(Integer[][], 
	 * Integer[][])}
	 * @see {@linkplain SquareMatrixMultiplyRecursive#joinMatrix(Integer[][], 
	 * Integer[][], int, int)}
	 */
	
	public static Integer[][] squareMatrixMulitplyRecursive(Integer[][] matrixA, 
	      Integer[][] matrixB) {
	   
		int n = matrixA.length;
		Integer[][] matrixC = new Integer[n][n];
		if (n == 1) {
			matrixC[0][0] = matrixA[0][0] * matrixB[0][0];
			++numberMultiplications;
		}
		else {
			
		   /*
		    * Partition part here.  We break out 4 square sub matrices.  First 
		    * we initialize then we need to use a help function subMatrix() to 
		    * actually create each sub matrix. See description for subMatrix 
		    * above the method below. 
		    */
			Integer[][] a11 = new Integer[n/2][n/2];
			Integer[][] a12 = new Integer[n/2][n/2];
			Integer[][] a21 = new Integer[n/2][n/2];
			Integer[][] a22 = new Integer[n/2][n/2];
			Integer[][] b11 = new Integer[n/2][n/2];
			Integer[][] b12 = new Integer[n/2][n/2];
			Integer[][] b21 = new Integer[n/2][n/2];
			Integer[][] b22 = new Integer[n/2][n/2];
			
			subMatrix(matrixA, a11, 0, 0);
			subMatrix(matrixA, a12, 0, n/2);
			subMatrix(matrixA, a21, n/2, 0);
			subMatrix(matrixA, a22, n/2, n/2);
			
			subMatrix(matrixB, b11, 0, 0);
			subMatrix(matrixB, b12, 0, n/2);
			subMatrix(matrixB, b21, n/2, 0);
			subMatrix(matrixB, b22, n/2, n/2);
			
			Integer[][] c11 = sum(squareMatrixMulitplyRecursive(a11, b11), 
			      squareMatrixMulitplyRecursive(a12, b21));
			Integer[][] c12 = sum(squareMatrixMulitplyRecursive(a11, b12), 
			      squareMatrixMulitplyRecursive(a12, b22));
			Integer[][] c21 = sum(squareMatrixMulitplyRecursive(a21, b11), 
			      squareMatrixMulitplyRecursive(a22, b21));
			Integer[][] c22 = sum(squareMatrixMulitplyRecursive(a21, b12), 
			      squareMatrixMulitplyRecursive(a22, b22));
			
			joinMatrix(matrixC, c11, 0, 0);
			joinMatrix(matrixC, c12, 0, n/2);
			joinMatrix(matrixC, c21, n/2, 0);
			joinMatrix(matrixC, c22, n/2, n/2);
			
			
		}

		return matrixC;
	}
	
	/**
	 * This function will divide a main matrix into its respective sub matrices.  
	 * It gets called every time there is a recursive call to 
	 * squareMatrixMulitpleRecursive so it will work down to last recursive call 
	 * of 2x2 matrix and subset into 4 1x1 matrices.  It works like this.
	 * <p>
	 * For a<sub>11</sub> it will take {@code iIndex} of 0 and {@code jIndex} 
	 * of 0.  We need to subset main matrix from {@code iIndex}  0..(n/2)-1 
	 * rows and from {@code jIndex} 0..(n/2)-1 columns. Set {@code i2 = iIndex 
	 * = 0} and {@code j2 = jIndex = 0} and iterate by row for each column n/2 
	 * times.  For a<sub>11</sub> i1 will always equal i2 and j1 will always 
	 * equal j2.  This is only for a<sub>11</sub> and the other 3 sub matrices 
	 * are offset. For a<sub>12</sub> as this is the upper right sub-matrix we 
	 * offset columns with {@code jIndex = n/2 = j2} where we will start at 
	 * column index n/2 of main matrix.  For a<sub>21</sub> as this is the 
	 * lower left sub-matrix we offset rows with {@code iIndex = n/2 = i2} 
	 * where we will start at row index n/2 of main matrix. Finally for 
	 * a<sub>22</sub> this is really just off-setting the combination of 
	 * a<sub>12</sub> and a<sub>21</sub>, the rows and the columns, with {@code 
	 * iIndex = n/2 = i2 = jIndex = n/2 = j2}.
	 * </p>
	 * 
	 * @param mainMatrix
	 * @param subMatrix
	 * @param iIndex
	 * @param jIndex
	 */
	public static void subMatrix(Integer[][] mainMatrix, Integer[][] subMatrix,
			int iIndex, int jIndex) {
		for (int i1 = 0, i2 = iIndex; i1 < subMatrix.length; ++i1, ++i2) {
			for (int j1 = 0, j2 = jIndex; j1 < subMatrix.length; ++j1, ++j2) {
				subMatrix[i1][j1] = mainMatrix[i2][j2];
			}
		}
	}
	
	/**
	 * This is a helper method to join the sub matrices that we broken apart by
	 * subMatrix(). It is called in the same order as subMatrix but in the 
	 * nested for loop we reverse it and still iterating of the entire sub 
	 * matrix we insert these values in the main matrix at their respect offset 
	 * in the main matrix.
	 * 
	 * @param mainMatrix
	 * @param subMatrix
	 * @param iIndex
	 * @param jIndex
	 */
	public static void joinMatrix(Integer[][] mainMatrix, Integer[][] subMatrix,
			int iIndex, int jIndex) {
	   
		for (int i1 = 0, i2 = iIndex; i1 < subMatrix.length; ++i1, ++i2) {
			for (int j1 = 0, j2 = jIndex; j1 < subMatrix.length; ++j1, ++j2) {
				mainMatrix[i2][j2] = subMatrix[i1][j1];
			}
		}
	}
	
	/**
	 * This is the method that adds up the matrices in lines 6-9 of the 
	 * pseudocode in the text on page 77 of CLRS.
	 * 
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

}
