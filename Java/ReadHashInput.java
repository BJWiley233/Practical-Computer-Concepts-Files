/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**This class has the method for reading in the data for the required input 
 * and test cases.   
 * <p>***THIS CLASS IS REQUIRED TO READ IN THE REQUIRED INPUT AND TEST CASES.***
 * 
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class ReadHashInput {
   
   
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
    */
   public static <T> ArrayList<T> readData(BufferedReader input, String dataType, int kmerSize) 
         throws IOException {

      ArrayList<T> arrayList = new ArrayList<T>();
      String line;
      boolean keepLine;
      int nextInt = 0;
      
      if (dataType.toUpperCase().compareTo("INTEGER") == 0 || 
            dataType.toUpperCase().compareTo("INT") == 0) {
         while ((line = input.readLine()) != null) {
            keepLine = true;
            if(line.trim().length() > 0) {
               try {
                 nextInt = Integer.parseInt(line);

               } catch (NumberFormatException e) {
                  System.err.println("Entry not an integer");
                  keepLine = false;
               }

               if (keepLine) {
                  arrayList.add((T) (Object) nextInt); 
               }
            }
         }   
      }
      else if (dataType.toUpperCase().compareTo("FASTA") == 0 || 
            dataType.toUpperCase().compareTo("FA") == 0) {
               input.readLine(); // skip first line
               StringBuilder sb = new StringBuilder();
               line = input.readLine();
               while (line != null) {
                  sb.append(line);
                  line = input.readLine();
               }
               String sequence = sb.toString();
               for (int i = 0; i < (sequence.length() - kmerSize + 1); ++i) {
                  arrayList.add((T) sequence.substring(i, i + kmerSize));
               }
               
            }

      
      return arrayList;
   }
   
   public void windowEntry() {
   }
   
}
