/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

/**
 * Main Class for Longest Common Subsequence.  As Java cannot return more than
 * one variable I made this an instance class so it would keep both 2-D arrays 
 * {@code b} and {@code c}.  It also uses a string variable {@code sequence}
 * to create the LCS instead of printing and has a method to return the sequence.
 * Running LCS and getting the length takes {@code O(mn)} and creating/printing 
 * sequence takes {@code O(m+n)}
 * @author bjwil
 *
 */
public class LCS {
   
   // initialize variables for parameters of algorithm
   private String X, Y;
   private int m, n;
   private String [][] b;
   private int [][] c;
   private String sequence = "";
   
   /**
    * Constructor to assign variables to run main algorithm
    * @param X
    * @param Y
    */
   public LCS(String X, String Y) {
      this.X = X;
      this.Y = Y;
      m = X.length();
      n = Y.length();
      b = new String[m+1][n+1];
      c = new int[m+1][n+1];
   }

   /**
    * Main part of algorithm to construct tables from page 394 CLRS
    * @return length of LCS
    */
   public int lcsLength() {
      
      for (int i = 0; i < m+1; i++)
         c[i][0] = 0;
      for (int j = 0; j < n+1; j++)
         c[0][j] = 0;   
      for (int i = 1; i < m+1; i++) {
         for (int j = 1; j < n+1; j++) {
            if (X.charAt(i-1) == Y.charAt(j-1)) {
               c[i][j] = c[i-1][j-1] + 1;
               b[i][j] = "LU";
            }
            else if (c[i-1][j] >= c[i][j-1]) {
               c[i][j] = c[i-1][j];
               b[i][j] = "U";
            }
            else {
               c[i][j] = c[i][j-1];
               b[i][j] = "L";
            }
         }
      }

      return c[m][n];
   }
   
   /**
    * Method to return the LCS constructed from {@link #setLCS()}
    * @return
    */
   public String getLCS() {
      return sequence;
   }
   
   /** 
    * Method to make initial call to {@link #printLCS(String[][], String, int, int)}
    *  from page 395 CLRS.
    */
   public void setLCS() {
      printLCS(b, X, X.length(), Y.length());
   }
   
   /**
    * Constructs the sequence from initial call and puts it into class variable
    * {@code sequence} so that is can be retrieved from {@link #getLCS()}
    * @param b 2-d array that stores the arrows
    * @param X first sequence
    * @param i length of first sequence X
    * @param j length of second sequence Y
    * @return
    */
   public int printLCS(String[][] b, String X, int i, int j) {
      if (i == 0 || j == 0) {
         return -1;
      }
      if (b[i][j].compareTo("LU") == 0) {
         printLCS(b, X, i-1, j-1);
         sequence = sequence + X.charAt(i-1);
      }
      else if (b[i][j].compareTo("U") == 0) {
         printLCS(b, X, i-1, j);
      }
      else {
         printLCS(b, X, i, j-1);
      }
      
      return 1;
   }
   
   /** 
    * This is just to test problem 15.4-2 to print the LCS without relying
    * on the space to use the String array b[][]
    */
   public void doLCSNoB() {
      System.out.println();
      doLCSPrintNoB(c, X, Y, X.length(), Y.length());
      System.out.println();
   }
   
   /**
    * Method that prints the LCS without using auxiliary array b[][] for 
    * problem 15.4-2
    * @param c 2-D tables that holds the scores for matching characters
    * @param X first sequence
    * @param Y second sequence
    * @param i length of first sequence X
    * @param j length of second sequence Y
    * @return
    */
   public int doLCSPrintNoB(int [][] c, String X, String Y, int i, int j) {
      if (c[i][j] == 0)
         return 0;
      if (X.charAt(i-1) == Y.charAt(j-1)) {
         doLCSPrintNoB(c, X, Y, i - 1, j - 1);
         System.out.print(X.charAt(i-1));
      }
      else if (c[i-1][j] >= c[i][j-1]) {
         doLCSPrintNoB(c, X, Y, i - 1, j);
      }
      else {
         doLCSPrintNoB(c, X, Y, i, j - 1);
      }
      
      return 0;
   }
   
}
