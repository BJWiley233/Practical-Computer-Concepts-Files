import java.util.Comparator;

public class SequentialSearchWithObjects {

	/*
	 * main class searching for String objects
	 */
    public static void main(String[] args) {
        String[] elements = {"Chuck", "Sophia",
            "Rebecca", "Vincent", "Ryan"};
        String valueToFind = "Chuck";
        
        // all three searches below are equivalent.
        //
        // searching with no Comparator, null is default
        int index = sequentialSearch(elements, valueToFind);
        System.out.println("Value found at arrayIndex " + index);
        
        // searching with explicit null Comparator
        index = sequentialSearch(elements, valueToFind, null);
        System.out.println("Value found at arrayIndex " + index);
        
        // searching with a Comparator.  
        index = sequentialSearch(elements, valueToFind, new Compare<String>());
        System.out.println("Value found at arrayIndex " + index);
    }
	
    /*
     * Explicit comparator using the natural sort order
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
	 * @param elements array of elements to search
	 * @param valueToFind value to find in array
	 * @return position of value in array
	 */
	public static <T extends Comparable<T>> int sequentialSearch(T[] elements,
			T valueToFind){
		return(sequentialSearch(elements, valueToFind, null));
	}
	
	/**
	 * Sequential search for object using Comparable or Comparator
	 * 
	 * @param elements array of objects to search 
	 * @param valueToFind value to find
	 * @param c comparator to use, null to use natural sort order
	 * @return position of value in array
	 */
	public static <T extends Comparable<T>>  int sequentialSearch(T[] elements, 
            T valueToFind, Comparator<T> c){
		
		// search through array
		for (int i = 0; i < elements.length; i++){
			// if c is null,  no Comparator, use natural sort order
			if (c == null) {
		        if (elements[i].compareTo(valueToFind) == 0)
		    	    return i;
			}
			// Comparator is used
		    else {
		       	if (c.compare(elements[i], valueToFind) == 0)
		       	    return i;
		    }
	    }
		// item is not found, return -1
		return -1;
	}
	
	
}
