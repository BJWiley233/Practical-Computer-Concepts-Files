import java.util.Random;

/**
 * This program implements and tests a Binary Search
 * 
 * @author Charles Kann
 *
 */
public class BinarySearch {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		if (args.length != 2){
			System.out.println("Run this program as " + 
		        "'java BinarySearch [array size] [value to find]'" );
			System.exit(1);
		}
		
        int arraySize = Integer.parseInt(args[0]);
        int[] elements = new int[arraySize];
        int valueToFind = Integer.parseInt(args[1]);
        
        Random randomNumber = new Random();
        
        for (int i = 0; i < elements.length; i++){
           elements[i] = randomNumber.nextInt()  % 1000000;
        }
        
        CombSort.combSort(elements);
        
        long startTime = System.nanoTime();
        System.out.println("value found at " + binarySearch(elements, valueToFind));
        long endTime = System.nanoTime();

        
        System.out.println("For " + 
            arraySize + " elements, the program ran " + 
           (endTime - startTime) + " nano seconds ");
	}
	/**
	 * Perform a binary search on an array
	 * 	
	 * @param elements the elements to be searched 
	 * @param valueToFind the value to find
	 * @return the position of the value in the array, -1 if not found
	 */
	public static int binarySearch(int[] elements, int valueToFind){
	    boolean found = false;
	    int start = 0;
	    int end = elements.length;
	    int middle;
	    
	    while (!found){
		    middle = (start + end) / 2;
	        if (elements[middle] == valueToFind){
	        	return middle;
	        }
	        else if (elements[middle] < valueToFind){
	        	start = middle + 1;
	        }
	        else {
	        	end = middle - 1;
	        }
	        if (start == end)
	        	break;
	    }
	    return -1;
	}

}
