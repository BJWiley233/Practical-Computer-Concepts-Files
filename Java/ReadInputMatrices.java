/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.StringTokenizer;

/**This class has the method for reading in the data for the required input 
 * and test cases.   
 * <p>***THIS CLASS IS REQUIRED TO READ IN THE REQUIRED INPUT AND TEST CASES.***
 * 
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class ReadInputMatrices {
   
   /**
    * Checks if matrix is a valid power of 2 
    * @param a
    * @return
    */
   public static boolean powerOfTwo (int a) {
      if (a <= 0)
         return false;
      while (a > 1) {
         if (a % 2 != 0) 
            return false;
         a /= 2;
      }
      
      return true;
   }
   
   /**
    * Method to read in the input required for the project.  We only need to 
    * read the required input in once for each class in the driver.  Then each 
    * of the three classes: SquareMatrixMultiply, SquareMatrixMultiplyRecursive, 
    * & StrassensMethod are called to output to each of their respective methods 
    * with each of their respective {@code writeData()} methods.
    * 
    * @param input
    * @return
    * @throws IOException
    * @throws NotPowerOfTwoException 
    */
   public static ArrayList<ArrayList<Integer[][]>> readData(BufferedReader input) 
         throws IOException, NotPowerOfTwoException {
      
      ArrayList<ArrayList<Integer[][]>> finalList = new ArrayList<ArrayList<Integer[][]>>();
      int k = 0;
      int w = 1;
      String line;
      boolean keepMatrices;
      String token;
      int squareSize;
      
      while ((line = input.readLine()) != null) {
         keepMatrices = true;
         squareSize = 0;
         if(line.trim().length() > 0) {
            try {
               try {
                  squareSize = Integer.parseInt(line);
                  if (! powerOfTwo(squareSize)) {
                     for (int i = 0; i < (2*squareSize); ++i)
                        input.readLine();
                     throw new NotPowerOfTwoException("\t*Matrix order is not "
                           + "a power of 2 for matrix set " + w + ". Matrices "
                           + "will be removed for this set.");
                  }
               } catch (NumberFormatException e ) {
                  System.err.println("\t*Invalid Matrix Order in matrix set " 
                           + w + ". Matrices will be removed.");
                  keepMatrices = false;
               }
                  
               Integer[][] matrix1 = new Integer[squareSize][squareSize];
               Integer[][] matrix2 = new Integer[squareSize][squareSize];
   
               for (int i = 0; i < squareSize; ++i) {
                  String array = input.readLine();
                  StringTokenizer t = new StringTokenizer(array, " ");
                  for (int j = 0; j < squareSize; ++j) {
                     token = t.nextToken();
                     try {  
                        matrix1[i][j] = Integer.parseInt(token);
                     } catch (NumberFormatException e) {
                        System.err.println("\t*Invalid entry in matrix set " 
                              + w + ", Entry 1: " + token + ". Matrices will "
                              + "be removed.");
                        keepMatrices = false;
                     }
                  }
               }

               for (int i = 0; i < squareSize; ++i) {
                  String array = input.readLine();
                  StringTokenizer t = new StringTokenizer(array, " ");
                  for (int j = 0; j < squareSize; ++j) {
                     token = t.nextToken();
                     try {  
                        matrix2[i][j] = Integer.parseInt(token);
                     } catch (NumberFormatException e) {
                        System.err.println("\t*Invalid entry in matrix set " 
                              + w + ", Entry 2: " + token + ". Matrices will "
                              + "be removed.");
                        keepMatrices = false;
                     }
                  }
               } 

               if (keepMatrices) {
                  finalList.add(new ArrayList<Integer[][]>(2));
                  finalList.get(k).add(matrix1);
                  finalList.get(k).add(matrix2);
                  ++k;
               }
            } catch (IOException e) {
               System.err.println("Error with Input File: " + e);
            } catch (NotPowerOfTwoException e) {
            } catch (NoSuchElementException e) {
               System.err.println("\t*Missing entries for matrix set " + w + 
                     ". Matrices will be removed.");
            } catch (NullPointerException e) {
               System.err.println("\t*Missing entries for matrix set " + w + 
                     ". Matrices will be removed.");
            }
            ++w;
         }  
         
      }
      
      return finalList;
   }
   
}
