import java.util.ArrayList;
import java.util.List;

/**
 * Class with method to return an {@code ArrayList} for Cartesian Product.
 * @author Brian Wiley
 */

public class Cartesian {
	// Can't figure how to incorporate inside below method so that object does not
	// need to be created and can use class with static method
   public static void main(String args[]) {
      System.out.println("Works");
   }
   
	List<String> testList = new ArrayList<String>();
	
	/**
	 * Method prints Cartesian product for any type ArrayList<>.
	 * Has {@link List#size}<sup>n</sup> possibilities.
	 *
	 * @param s empty String to append output
	 * @param n integer length of string
	 * @param typeList any List type
	 * @return {@code ArrayList} for Cartesian product of any length list
	 */
	public <T> List<String> print_any_String(String s, int n, List<T> typeList) {
		if (n == s.length())
			testList.add(s);
		else {
			for (T thingInList : typeList)
				print_any_String(s + thingInList, n, typeList);
		}
	return testList;
	}
}
