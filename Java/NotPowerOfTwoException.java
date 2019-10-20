/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

/**
 * Created an Exception to check for the dependency on these
 * algorithms from the text where it indicates 
 * <p>"we assume that n is an exact power of 2 in each of the n x n 
 * matrices." (Pg. </p>
 * 
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-09-24
 */

public class NotPowerOfTwoException extends Exception {
   
   private static final long serialVersionUID = 1L;

   NotPowerOfTwoException(String message) {
      System.err.println(message);
   }

}
