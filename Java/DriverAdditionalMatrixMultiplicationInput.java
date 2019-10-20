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

/**
 * This is the driver to read in the additional input which may more may not be
 * correct.  May have more than or less than 3 sets to perform calculations on.
 * You must call the following code from command line or linux/unix terminal:
 * 
 * <p>{@code javac DriverAdditionalMatrixMultiplicationInput.java}</p>
 * 
 * <p>{@code java DriverAdditionalMatrixMultiplicationInput.java 
 * Incorrect_Input_1_Example.txt Incorrect_Output_1_Example.txt 
 * Correct_Input_2_Examples.txt Correct_Output_2_Examples.txt 
 * Correct_Input_4_Examples.txt Correct_Output_4_Examples.txt 
 * Incorrect_And_Correct_Input_6_Examples.txt 
 * Incorrect_And_Correct_Output_6_Examples.txt}</p>
 * 
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class DriverAdditionalMatrixMultiplicationInput {

   public static void main(String[] args) throws NotPowerOfTwoException  {
      
      /*
       * See README.txt: This will only test for correct input and then test
       * output using Strassen's method only.
       * Must add arguments to 
       * java DriverAdditionalMatrixMultiplicationInput.java:
       * Incorrect_Input_1_Example.txt Incorrect_Output_1_Example.txt 
       * Correct_Input_2_Examples.txt Correct_Output_2_Examples.txt 
       * Correct_Input_4_Examples.txt Correct_Output_4_Examples.txt 
       * Incorrect_And_Correct_Input_6_Examples.txt 
       * Incorrect_And_Correct_Output_6_Examples.txt
       */
      for (int i = 0; i < args.length ; i += 2) {
         try {
            List<ArrayList<Integer[][]>> matricesFile1 = new ArrayList<ArrayList<Integer[][]>>();
            System.out.print("Reading matrices from file: " + "\"" + args[i] 
                  + "\" ...");
            BufferedReader input = new BufferedReader(new FileReader(args[i]));
            System.out.println("Successful");
            matricesFile1 = ReadInputMatrices.readData(input); 
            System.out.println("List of matrix sets is of size " 
                  + matricesFile1.size());
            if (matricesFile1.size() > 0) {
               try {
                  PrintWriter output = new PrintWriter(new FileWriter(args[i+1]));
               
               System.out.println("Writing to file...");
               for (ArrayList<Integer[][]> al : matricesFile1)
                  StrassensMethod.writeData(al, output);
               output.flush();
               output.close();  
               System.out.println("Successfully wrote to file: " + "\"" 
                     + args[i+1] + "\"");
               } catch (ArrayIndexOutOfBoundsException exc) {
                  System.err.println("No output file given.  Please enter "
                        + "output file.");                  
               }
            }
            else {
               try {
               System.err.println("No valid matrix sets. Will not print to file: "
                     + "\"" + args[i+1] + "\"");
               } catch (ArrayIndexOutOfBoundsException exc) {
                  System.err.println("No output file given.  Please enter output "
                        + "file.");                  
               }
            }
         } catch (IOException e) {
            System.err.print("Error with file Input: " + e);
            System.exit(1);
         }
         System.out.println();
      }
     
   }

}
