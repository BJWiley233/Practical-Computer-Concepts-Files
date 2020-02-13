import java.util.Comparator;
import java.util.Random;

/** 
 * This project was implemented using Objects. 
 * Code give answer to problem 3 for Assignment 3.
 * Includes private comparator class used in SequentialSearchWithObjects
 * from class. Includes combSort method which implements the Wikipedia
 * pseudocode algorithm.  Also includes a sortedDuplicateSearch
 * method for linear run time searching of a sorted array.  Must add
 * Command Line argument in Eclipse or shell for length of Integer array.
 * 
 * @author Brian Wiley
 * @since 6/20/2019
 */

public class FinalCombSortObjects {

	/**
	 * @param args args[0] the size of the array to sort
	 */
	public static void main(String[] args) {
		if (args.length != 1){
			System.out.println("Run this program as " + 
		        "'java FinalCombSortObects [array size]'" );
			System.exit(1);
		}
		
        int arraySize = Integer.parseInt(args[0]);
        Integer[] elements = new Integer[arraySize];
        int[] duplicateIndexes = new int[2]; 
        
        Random randomNumber = new Random();
        
        for (int i = 0; i < elements.length; i++){
            elements[i] = randomNumber.nextInt(10000000) + 1;
        }
        // Print first 10 elements of original order
        System.out.print("First 10 values in the original array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(elements[i] + " ");
        }
        System.out.println("");
        long startTime = System.currentTimeMillis();
        combSort(elements, new Compare<Integer>());
        duplicateIndexes = sortedDuplicateSearch(elements, new Compare<Integer>());
        long endTime = System.currentTimeMillis();
        

        // Check that it at least appears sorted
        System.out.print("First 10 values in the sorted array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(elements[i] + " ");
        }
        // Print duplicate indices
        System.out.println("\nDuplicate Indexes are " + duplicateIndexes[0] + " & " + 
                duplicateIndexes[1]);
        
        System.out.println("For " + 
            arraySize + " elements, the sort and search program ran " + 
           (endTime - startTime) + " milliseconds ");
        // Time just the search
        startTime = System.currentTimeMillis();
        duplicateIndexes = sortedDuplicateSearch(elements, new Compare<Integer>());
        endTime = System.currentTimeMillis();
        // Make sure same indexes as above
        System.out.println("\nDuplicate Indexes are " + duplicateIndexes[0] + " & " + 
                duplicateIndexes[1]);
        System.out.println("For " + 
                arraySize + " elements, the search only program ran " + 
               (endTime - startTime) + " milliseconds ");
        
        System.out.println("\n");
        
        /* Test with String 10^7 is 10,000,000 using getStringArray from
         * DuplicateSearchWithObjects.java
         * Why is sort and search faster with Integer over String?
         */
        String[] stringElements = DuplicateSearchWithObjects.getStringArray("ABCDEFGHIJ", 7, 10000000);
        // Print first 10 elements of original order
        System.out.print("First 10 values in the original String array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(stringElements[i] + " ");
        }
        System.out.println("");
        startTime = System.currentTimeMillis(); // start time after creating String array
        combSort(stringElements, new Compare<String>());
        duplicateIndexes = sortedDuplicateSearch(stringElements, new Compare<String>());
        endTime = System.currentTimeMillis();
        
        System.out.print("First 10 values in the sorted String array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(stringElements[i] + " ");
        }
        // Print duplicate indices
        System.out.println("\nDuplicate Indexes are " + duplicateIndexes[0] + " & " + 
        duplicateIndexes[1]);
        
        System.out.println("For String array of " + 
        	stringElements.length + " elements, the sort and search program ran " + 
           (endTime - startTime) + " milliseconds ");
        // Time just the search
        startTime = System.currentTimeMillis();
        duplicateIndexes = sortedDuplicateSearch(stringElements, new Compare<String>());
        endTime = System.currentTimeMillis();
        // Make sure same indexes as above
        System.out.println("\nDuplicate Indexes are " + duplicateIndexes[0] + " & " + 
                duplicateIndexes[1]);
        System.out.println("For String array of " + 
        		stringElements.length + " elements, the search only program ran " + 
               (endTime - startTime) + " milliseconds ");
	}
	
	/**
     * Explicit comparator using the natural sort order. 
     * Extends Comparable for compareTo method and also
     * implements Comparator interface to use its compare
     * method template. The compare method implemented sorts
     * in ascending order.
     */
	private static class Compare<T extends Comparable<T>> 
	implements Comparator<T> {
		public int compare(T o1, T o2){
		    return o1.compareTo(o2);
		}
	}
	
	/**
	 * method that handles a missing Comparator, uses the
	 * null as Comparator.
	 * 
	 * @param <T>
	 * @param elements array of objects to sort
	 * @return sorts the array passed in ascending order
	 */
	public static <T extends Comparable<T>> void combSort(T[] elements) {
		combSort(elements, null);
	}
	
	/** 
	 * Implements the Comb Sort Algorithm using a gap that gets
	 * smaller with each iteration.  Used pseudo code algorithm 
	 * from <a href="https://en.wikipedia.org/wiki/Comb_sort">
	 * Wikipedia Comb Sort</a>.
	 * 
	 * @param <T>
	 * @param elements array of objects
	 * @param c comparator to use, null to use natural sort order
	 * @return sorts the array passed in ascending order
	 */
	public static <T extends Comparable<T>> void combSort(T[] elements,
			Comparator<T> c) {
		
		int gap = elements.length;
		double shrink = 1.3;
		boolean sorted = false;
		
		while (sorted == false) {
			gap = (int)(gap / shrink);
			/* as soon as the gap is 1 the algorithm is finished if 
			 * there are no swaps in next while loop below.  Meaning
			 * sorted stays true and and does not return to false
			 * for a swap
			 */
			if (gap <= 1) {
				gap = 1;
				sorted = true;
			}
			
			int i = 0;
			while((i + gap) < elements.length) {
				if (c == null) {
		    		if (elements[i].compareTo(elements[i+gap]) > 0) {
		    			swap(elements, i, i+gap);
			            sorted = false;
		    		}
		    	}
		    	else {
		    		if (c.compare(elements[i], elements[i+gap]) > 0) {
		    			swap(elements, i, i+gap);
		    			sorted = false;
		    		}
		    	}
				i += 1;
			}
		}
	}
	
	/**
	 * Swaps larger value at index {@code i} with smaller value at
	 * index {@code j}.
	 * 
	 * @param <T>
	 * @param elements array of objects
	 * @param i smaller index with larger value
	 * @param j larger index with smaller value
	 */
	public static <T> void swap(T[] elements, int i, int j) {
		T temp = elements[i];
		elements[i] = elements[j];
		elements[j] = temp;
	}
	
	/**
	 * method that handles a missing Comparator, uses the
	 * null as Comparator.
	 * 
	 * @param elements array of objects to search
	 * @return positions of value in array which are first duplicates
	 */
	public static <T extends Comparable<T>> int[] sortedDuplicateSearch(T[] elements) {
		return(sortedDuplicateSearch(elements, null));
	}
	
	/**
	 * Modified duplicate search for object using Comparable or Comparator
	 * in a sorted array. Extends Comparable with Generic type to allow for any type 
	 * of object array.
	 * 
	 * @param elements array of objects to search 
	 * @param c comparator to use, null to use natural sort order
	 * @return positions of value in array which are first duplicates
	 */
	public static <T extends Comparable<T>> int[] sortedDuplicateSearch(T[] elements, 
            Comparator<T> c) {
		int[] answer = new int[2];
		// search through array
		for (int i = 0; i < (elements.length - 1); i++) {
			// if c is null,  no Comparator, use natural sort order
			if (c == null) {
		        if (elements[i].compareTo(elements[i + 1]) == 0) {
		    	    answer[0] = i;
		    	    answer[1] = i + 1;
		        	return answer;
		        }
			}
			// Comparator is used
		    else {
		       	if (c.compare(elements[i], elements[i + 1]) == 0) {
		       		answer[0] = i;
		    	    answer[1] = i + 1;
		        	return answer;
		       	}
		    }
	    }
		// item is not found, return -1
		answer[0] = -1;
	    answer[1] = -1;
    	return answer;
	}
}
