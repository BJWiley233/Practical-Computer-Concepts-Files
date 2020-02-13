import java.util.Comparator;
import java.util.Random;

/**
 * TODO Try sort String objects
 */

public class CombSortObects {

	/**
	 * @param args args[0] the size of the array to sort
	 */
	public static void main(String[] args) {
		if (args.length != 1){
			System.out.println("Run this program as " + 
		        "'java CombSort [array size]'" );
			System.exit(1);
		}
		
        int arraySize = Integer.parseInt(args[0]);
        Integer[] elements = new Integer[arraySize];
        
        Random randomNumber = new Random();
        
        for (int i = 0; i < elements.length; i++){
            elements[i] = randomNumber.nextInt(1000) + 1;
        }
        
        long startTime = System.currentTimeMillis();
        combSort(elements, new Compare<Integer>());
        long endTime = System.currentTimeMillis();
        
        // Check that it at least appears sorted
        System.out.print("First 10 values in the array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(elements[i] + " ");
        }
        System.out.println();
        
        System.out.println("For " + 
            arraySize + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
        
        System.out.println("\n");
        
        String[] stringElements = DuplicateSearchWithObjects.getStringArray("ABCDEFGHIJ", 3, 100);
        startTime = System.currentTimeMillis();
        combSort(stringElements, new Compare<String>());
        endTime = System.currentTimeMillis();
        
        System.out.print("First 10 values in the String array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(stringElements[i] + " ");
        }
        System.out.println();
        
        System.out.println("For String array of " + 
        	stringElements.length + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
	}
	
	private static class Compare<T extends Comparable<T>> 
	implements Comparator<T> {
		public int compare(T o1, T o2){
		    return o1.compareTo(o2);
		}
	}
	
	public static <T extends Comparable<T>> void combSort(T[] elements) {
		combSort(elements, null);
	}
	
	public static <T extends Comparable<T>> void combSort(T[] elements,
			Comparator<T> c) {
		
		int gap = elements.length;
		
		for (int i = 0; i < (elements.length-1); i++) {
			gap = (int)(gap / 1.3);
			
			if (gap < 1)
				gap = 1;
			System.out.println(gap);
			boolean swap = false;
		    for (int j = 0; (j + gap) < (elements.length); j++) { 
		    	if (c == null) {
		    		if (elements[j].compareTo(elements[j+gap]) > 0) {
		    			swap(elements, j, j+gap);
			            swap = true;
		    		}
		    	}
		    	else {
		    		if (c.compare(elements[j], elements[j+gap]) > 0) {
		    			swap(elements, j, j+gap);
		    			swap = true;
		    		}
		    	}
		    }
		    if (!swap && (gap == 1)) {
		    	break;
		    }
	    }
	}
	
	public static <T> void swap(T[] elements, int i, int j) {
		T temp = elements[i];
		elements[i] = elements[j];
		elements[j] = temp;
	}
}
