import java.util.Random;

public class CombSort {

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
        int[] elements = new int[arraySize];
        
        Random randomNumber = new Random();
        
        for (int i = 0; i < elements.length; i++){
            elements[i] = randomNumber.nextInt();
        }
        
        long startTime = System.currentTimeMillis();
        
        combSort(elements);
        
        long endTime = System.currentTimeMillis();
        
        // Check that it at least appears sorted
        System.out.print("First 10 value in the array are: " );
        for (int i = 0; i < 10; i++) {
        	System.out.print(elements[i] + " ");
        }
        System.out.println();
        
        System.out.println("For " + 
            arraySize + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
	}
	
	public static void combSort(int[] elements) {
		
		int gap = elements.length;
		
		for (int i = 0; i < (elements.length-1); i++){
			gap = (int)(gap / 1.3);
			if (gap < 1)
				gap = 1;
			
			boolean swap = false;
		    for (int j = 0; (j + gap) < (elements.length); j++) { 
		    	if (elements[j] > elements[j+gap]) {
		    		swap(elements, j, j+gap);
		            swap = true;
		    	}
		    }
		    if (!swap && (gap == 1)) {
		    	break;
		    }
	    }
		
	}
	
	public static void swap(int[] elements, int i, int j){
		int temp = elements[i];
		elements[i] = elements[j];
		elements[j] = temp;
	}
}
