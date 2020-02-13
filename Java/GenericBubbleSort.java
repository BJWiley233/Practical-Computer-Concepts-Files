import java.util.Comparator;

public class GenericBubbleSort {

	public static void main(String[] args) {
	
        String[] elements = {"Jessica", "Freddy", "Ryan", "Vincent", "Sophia", "Rebecca"};
        
        long startTime = System.currentTimeMillis();  
        bubbleSort(elements, null);
        long endTime = System.currentTimeMillis();
        
        // Check that it at least appears sorted
        System.out.print("The sored array is: " );
        for (String s: elements) {
        	System.out.print(s + " ");
        }
        System.out.println();
        
        System.out.println("For " + 
            6 + " elements, the program ran " + 
           (endTime - startTime) + " milliseconds ");
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static <T extends Comparable> void bubbleSort(T[] elements, Comparator<T> comp) {		
		for (int i = 0; i < (elements.length-1); i++){
			boolean swap = false;
		    for (int j = 0; j < elements.length-(i+1); j++) { 
		    	// If comp is null, use the natural sort order.
		    	if (comp == null) {
		    		if (elements[j].compareTo(elements[j+1]) > 0) {
			    		swap(elements, j, j+1);
			            swap = true;	    			
		    		}
		    	}
		    	
		    	// Use Comparator comp method
		    	else if (comp.compare(elements[j], elements[j+1]) > 0) {
		    		swap(elements, j, j+1);
		            swap = true;
		    	}
		    }
		    if (!swap) {
		    	break;
		    }
	    }
		
	}
	
	public static<T> void swap(T[] elements, int i, int j){
		T temp = elements[i];
		elements[i] = elements[j];
		elements[j] = temp;
	}
}
