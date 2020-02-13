import com.chuckkann.datastructures.indexedlist.LinkedList;

public class LinkedListTest {

	public static void main(String[] args) {
		LinkedList<Integer> integerLL = new LinkedList<Integer>();
		/*for (Integer i : integerLL)
			System.out.println(i);
			*/
		integerLL.add(1);
		integerLL.add(2);
		integerLL.add(2);
		integerLL.add(3);
		integerLL.add(2);
		
		System.out.println(integerLL.indexOf(4, 2));
		System.out.println();
		integerLL.remove(0);
		integerLL.remove(0);
		integerLL.remove(0);
		integerLL.remove(0);
		for (Integer i : integerLL)
			System.out.println(i);
		
		integerLL.add(1);
		integerLL.add(2);
		integerLL.add(2);
		integerLL.add(3);
		for (Integer i : integerLL)
			System.out.println(i);

		//System.out.println(integerLL.lastIndexOf(2));

	}

}
