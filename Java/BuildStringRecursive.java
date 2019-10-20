import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Vector;

/**
 * Assignment 2
 * Program to build all strings of (set length)<sup>n</sup> possibilities.
 * Also known as the Cartesian Product.
 * Added additional functionality to take in any type list {@code  (int, char, String, Integer, etc)}
 * as well as a {@code Cartesian} class with method to return an {@code ArrayList}.
 * @author Brian Wiley
 */

public class BuildStringRecursive {
	
	/**
	 * Takes original print_0_1_String method from class and simplifies
	 * so all binary options are included. Has 2<sup>n</sup> possibilities.
	 *
	 * @param s empty String to append output
	 * @param n integer length of string
	 * @return all String options for Cartesian product of 0s and 1s
	 */
	public static void print_0_1_String(String s, int n) {
		if (n == s.length())
			System.out.println(s + ",");
		else {
			print_0_1_String(s + "0", n);
			print_0_1_String(s + "1", n);
		}
	}
	
	/**
	 * Extends print_0_1_String to include 2s in addition to 
	 * 0s and 1s. Has 3<sup>n</sup> possibilities.
	 *
	 * @param s empty String to append output
	 * @param n integer length of string
	 * @return all String options for Cartesian product of 0s, 1s & 2s
	 */
	public static void print_0_1_2_String(String s, int n) {
		if (n == s.length())
			System.out.println(s + ",");
		else {
			print_0_1_2_String(s + "0", n);
			print_0_1_2_String(s + "1", n);
			print_0_1_2_String(s + "2", n);
		}
	}
	
	/**
	 * Method prints Cartesian product for any type ArrayList<>.
	 * Has {@link List#size}<sup>n</sup> possibilities.
	 *
	 * @param s empty String to append output
	 * @param n integer length of string
	 * @param typeList any List type
	 * @return all String options for Cartesian product of any length list
	 */
	public static <T> void print_any_String(String s, int n, List<T> typeList) {
		if (n == s.length())
			System.out.println(s + ",");
		else {
			for (T thingInList : typeList)
				print_any_String(s + thingInList, n, typeList);
		}
	}
	
	// main method
	public static void main(String[] args) {
		// initialize string
		String s = "";
		// Start tests for methods above
		List<Integer> intList = new ArrayList<Integer>(Arrays.asList(0, 1));
		print_0_1_String(s, 3);   //2^3 or 8 possibilities
		System.out.println("");
		print_0_1_String(s, 4);   //2^4 or 16 possibilities
		System.out.println("");
		print_0_1_2_String(s, 3); //3^3 or 27 possibilities
		System.out.println("");
		print_any_String(s, 4, intList); // k = length of List where we have k^n possibilities
		System.out.println("");
		print_any_String(s, 3, new ArrayList<Integer>(Arrays.asList(0, 1, 2, 3))); // 4^3 possibilities
		System.out.println("");
		print_any_String(s, 3, new ArrayList<Character>(Arrays.asList('A', 'C', 'G', 'T'))); // 4^3 possibilities
		System.out.println("");
		
		// Tests to take any Generic ArrayList and returns Cartesian Product using Cartesian object
		Cartesian ob = new Cartesian();
		List<String> thisIntList = new ArrayList<String>(ob.print_any_String(s, 
				3, new ArrayList<Integer>(Arrays.asList(0, 1, 2, 3))));
		System.out.println(thisIntList);
		System.out.println(thisIntList.size());
		
		Cartesian ob2 = new Cartesian();
		List<String> thisCharList = new ArrayList<String>(ob2.print_any_String(s, 
				3, new ArrayList<Character>(Arrays.asList('A', 'C', 'G', 'T'))));
		System.out.println(thisCharList);
		System.out.println(thisCharList.size());	
		
		// Testing use of Vector.  Should also work for LinkedList and Stack
		List<Integer> vector = new Vector<>(3); // Autobox
		vector.add(1);
		vector.add(2);
		vector.add(3);
		Cartesian vectorTestOb = new Cartesian();
		List<String> thisVectorIntList = new ArrayList<String>(vectorTestOb.print_any_String(s, 
				3, vector));
		System.out.println(thisVectorIntList);
	}
}
