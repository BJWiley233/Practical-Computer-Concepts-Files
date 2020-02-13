

import java.util.Collection;
import java.util.Comparator;

/**
 * @author Chuck
 *
 */
public final class CollectionUtils {

	/**
	 *  Disable the constructor so this class cannot
	 *  be instantiated.
	 */
	private CollectionUtils() {
	}
	
	/**
	 * Count the number of times elementToCount occurs
	 * in the Collection c.
	 * 
	 * @param c the collection of elements
	 * @param elementToCount the element to count
	 * @return the number of times elementToCount is in c
	 */
	public static<E extends Comparable<E>> int countOccurrences(Collection<E> c, E elementToCount){
		return countOccurrences(c, elementToCount, null);
	}

	public static<E extends Comparable<E>> int countOccurrences(Collection<E> c, E elementToCount, Comparator<E> comparator){
		int count = 0;
		for(E e : c){
			if (comparator != null) {
				if (comparator.compare(e, elementToCount) == 0) {
					count = count + 1;
				}
			}
			else {
			    if (e.compareTo(elementToCount) == 0){
			    	count = count + 1;
			    }
			}		    
		}
		return count;
	}
}

