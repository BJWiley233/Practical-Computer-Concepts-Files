/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** 
 * Class to read in the required input as well as a single FastA and multiple
 * FastA files.  The output files are written directly from the Drivers as
 * they are just standard output streams and need no modifications.
 * 
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-11-06
 */
public class ReadDynamicInput {
   
   /**
    * Reads in required input for Project from DynamicLab2Input.txt
    * @param <T>
    * @param br BufferedReader for required input text
    * @return list of sequences for required input
    * @throws IOException
    */
   @SuppressWarnings("unchecked")
   public static <T> List<T> inputList(BufferedReader br) throws IOException {
      
      List<T> input = new ArrayList<T>();
      String line;
      
      while ((line = br.readLine()) != null) {
         if (line.trim().length() > 0) {
            line = line.substring(line.indexOf("=") + 2, line.length());
            input.add((T) line);
         }
      }

      return input;        
   }
   
   /**
    * Reads in a single sequence from FastA
    * @param br Buffered reader for single sequence in FastA
    * @return A single sequence
    * @throws IOException
    */
   public static String readFasta(BufferedReader br) throws IOException {
      String line;
      br.readLine(); // skip first line
      StringBuilder sb = new StringBuilder();
      line = br.readLine();
      while (line != null) {
         sb.append(line);
         line = br.readLine();
      }
      String sequence = sb.toString();
      
      return sequence;
   }
   
   /**
    * Reads in multiple sequences from FastA
    * @param br Buffered reader for multiple sequences in FastA
    * @return 2-D ArrayList with species name being first entry and sequence
    * being second entry
    * @throws IOException
    */
   public static List<ArrayList<String>> readFastaMultiple(BufferedReader br) throws IOException {
      List<ArrayList<String>> proteinSeqs = new ArrayList<ArrayList<String>>();
      String line;
      String regex = "^>";
      Pattern pattern = Pattern.compile(regex);
      String species = "";
      String sequence;
      line = br.readLine();
      
      while (line != null) {
         Matcher matcher = pattern.matcher(line);
         if (matcher.lookingAt()) {
            species = line.substring(line.indexOf("OS=")+3, line.indexOf("OX=")-1);
         }
         StringBuilder sb = new StringBuilder();
         line = br.readLine();
         matcher = pattern.matcher(line);
         while (!matcher.lookingAt() && line != null) {
            sb.append(line);
            line = br.readLine();
            if (line != null) {
               matcher = pattern.matcher(line);
            }
         }
         sequence = sb.toString();
         ArrayList<String> eachSeq = new ArrayList<String>();
         eachSeq.add(species);
         eachSeq.add(sequence);
         proteinSeqs.add(eachSeq);
      }
      
      return proteinSeqs;
   }
  
}
