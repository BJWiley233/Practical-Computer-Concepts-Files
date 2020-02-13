import java.util.Random;

import com.chuckkann.datastructures.Bag;
import com.chuckkann.datastructures.DsIterator;
import com.chuckkann.datastructures.bag.ArrayBag;

/**
 * This project was implemented using Objects.
 * Implements the reverse iterator for the ArrayBag class.  
 * Implements the setIteratorToEnd, hasPrevious, and Previous methods. 
 * Uses a while loop to obtain the previous item in bag after setting
 * the iterator to the end.
 * 
 * Also includes a method to compare and reverse iteration .
 * 
 * @author Brian Wiley
 * @since 6/29/2019
 *
 */

public class ReverseArrayBagTest {

	public static void main(String[] args) {
		
		// Create Person Bag
		Bag<Person> pb = new ArrayBag<Person>();
		
		// Fill bag
		pb.add(new Person("Jessica", 5));
		pb.add(new Person("Vincent", 14));
		pb.add(new Person("Ryan", 11));
		pb.add(new Person("Sophia", 16));
		pb.add(new Person("Rebecca", 15));
		pb.add(new Person("Tony", 26));
		pb.add(new Person("Brian", 5));
		pb.add(new Person("Chuck", 92));
		pb.add(new Person("Brittany", 1));
		pb.add(new Person("Kristine", 54));
		
		// Print out Person Bag using iterator
		for (Person p : pb) {
			System.out.println(p);
		}
		System.out.println();
		//Bag<Integer> intBag = new ArrayBag<Integer>();

		// Create Person DsIterator and set to end
		DsIterator<Person> pbIterator = pb.iterator();
		pbIterator.setIteratorToEnd();
		
		// Create reverse Person array for comparison
		Person[] reversePersonArray = new Person[pb.size()];
		int x = 0;
		
		// Using the Person DsIterator assigned reverse to
		// reverse Person array as well as print out for visual
		while(pbIterator.hasPrevious()) {
			reversePersonArray[x] = (Person) pbIterator.previous();
			System.out.println(reversePersonArray[x]);
			++x;
		}
		System.out.println();
		
		// Cast personArray to object to use comparison method
		Object[] personArray = pb.toArray();
		
		// If reverse is reverse print confirmation
		if (compareReverse(personArray, reversePersonArray))
			System.out.println("Reverse iterator for Person Bag is indeed reverse");
		System.out.println();

		
		/* Testing with integer and then compares that the reverse 
		 * is indeed the reverse.
		 */
		
		// Create ArrayBag and not Bag since we need allocationSize
		// to fill bag using a for loop.  This method is not in Collection
		// interface from class.  We could add this to Collection if needed.
		ArrayBag<Integer> integerBag = new ArrayBag<Integer>(500);
		Random randomNumber = new Random();
		for (int i = 0; i < integerBag.allocationSize(); ++i) {
			integerBag.add(randomNumber.nextInt(1000) + 1);
		}
		// Cast to Object to use to compare to reverse array from reverse iterator
		Object[] integerArray = integerBag.toArray();

		// Create DsIterator for integer bag to add the reverse iteration
		// to a reverse array for comparison
		DsIterator<Integer> intIterator = integerBag.iterator();
		intIterator.setIteratorToEnd();
		Integer[] reverseIntegerArray = new Integer[integerBag.size()];
		int i = 0;
		while(intIterator.hasPrevious()) {
			reverseIntegerArray[i] = (Integer) intIterator.previous();
			++i;
		}
		
		// Call to comparison method
		if (compareReverse(integerArray, reverseIntegerArray))
			System.out.println("True to Integer bag as well");
	}
	
	/** 
	 * This method is used to compare any two object arrays are
	 * the reverse of each other.
	 * 
	 * @param <T>
	 * @param x first ("forward") array to compare
	 * @param y second ("reverse") array to compare
	 * @return true if reverse array backwards equals forward array
	 */
	
	public static <T> boolean compareReverse(T[] x, T[] y) {
		boolean reversed = true;
		if (x.length != y.length) {
			reversed = false;
		}
		for (int i = 0; i < x.length; ++i) {
			if (x[i] != y[y.length - 1 - i]) {
				reversed = false;
			}
		}
		return reversed;		
	}
}



