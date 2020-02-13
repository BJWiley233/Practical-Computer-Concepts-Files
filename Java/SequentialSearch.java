

import java.util.Random;

/**
 * Program to find a value in an array using Sequential Search
 * 
 * @author Charles Kann
 *
 */
public class SequentialSearch {

	/**
	 * @param args arg[0] is the size of the array to search
	 *             arg[1] is the value to search for 
	 */
	public static void main(String[] args) {
		if (args.length != 2){
			System.out.println("Run this program as " + 
		        "'java SequentialSearch [array size] " + 
                "[value to find]'");
			System.exit(1);
		}
		
        int arraySize = Integer.parseInt(args[0]);
        int[] elements = new int[arraySize];
        int valueToFind = Integer.parseInt(args[1]);
        
        Random randomNumber = new Random();
        
        for (int i = 0; i < elements.length; i++){
            elements[i] = randomNumber.nextInt();
        }
        
        long startTime = System.currentTimeMillis();
        
        int index = sequentialSearch(elements, valueToFind);
        System.out.println("Value found at arrayIndex " + index);
        
        long endTime = System.currentTimeMillis();
        System.out.println("For " + 
            arraySize + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
	}
	
	public static int sequentialSearch(int[] elements, 
            int valueToFind){
		
		for (int i = 0; i < elements.length; i++){
		    if (elements[i] == valueToFind)
		    	return i;
	    }
		return -1;
	}
}
