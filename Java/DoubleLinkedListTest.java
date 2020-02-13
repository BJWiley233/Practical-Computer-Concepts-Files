import java.util.Comparator;

import com.chuckkann.datastructures.DsIterator;
import com.chuckkann.datastructures.indexedlist.DoublyLinkedList;

/**
 * 
 * @author bjwil
 *
 */

public class DoubleLinkedListTest {

	public static void main(String[] args) {
		DoublyLinkedList<Integer> integerDLL = new DoublyLinkedList<Integer>();
		Integer[] intItems = {7, 8, 9};
		integerDLL.add(1);
		integerDLL.add(2);
		integerDLL.add(3);
		//integerDLL.add(2, 3);
		//integerDLL.add(1, 5);
		//integerDLL.add(integerDLL.size(), intItems);
		System.out.println("Removing first element " + integerDLL.remove(0));
		System.out.println("Removing first element " + integerDLL.remove(0));
		System.out.println("Removing first element " + integerDLL.remove(0));
		// test removing last index, first index, and a middle index
		//System.out.println("Removing last element " + integerDLL.remove(integerDLL.size() - 1));
		//System.out.println("Removing first element " + integerDLL.remove(0));
		//System.out.println("Removing third element " + integerDLL.remove(2) + "\n");
		
		// test adding after removing
		//integerDLL.add(5, 100);
		//integerDLL.add(2);
		
		// add more of same to test lastIndexOf
		//integerDLL.add(8);
		//integerDLL.add(8);
		//integerDLL.add(100);
		
		// Print final size
		System.out.println("Final size of Linked List is: " + integerDLL.size() + "\n");
		
		// Print the Linked List by testing iterator forward
		int j = 1;
		for (Integer i : integerDLL) {
			System.out.println("Node #" + j + "(index " + (j - 1) + ")" + " is " + i);
			++j;
		}
		System.out.println("");
		
		// Implement the reverse iteration using 
		j = integerDLL.size();
		DsIterator<Integer> reverseDLL = integerDLL.iterator();
		reverseDLL.setIteratorToEnd();
		while (reverseDLL.hasPrevious()) {
			System.out.println("Node #" + j + "(index " + (j - 1) + ")" + " is " + reverseDLL.previous());
			--j;
		}
		System.out.println("");		
		
		// Test retrieve
		System.out.println("Retrieving index 9: " + integerDLL.retrieve(9));
		System.out.println("Retrieving index 0: " + integerDLL.retrieve(0));
		System.out.println("Retrieving index 4: " + integerDLL.retrieve(4));
		System.out.println("");	
		
		// Test indexOf
		System.out.println("The index of 7 is " + integerDLL.indexOf(7));
		System.out.println("The index of 2 is starting at index 2 is " + integerDLL.indexOf(2, 2));
		System.out.println("The index of 2 is starting at index 2 is " + 
					integerDLL.indexOf(2, 2, new Compare<Integer>()));
		System.out.println("");
		
		// Test lastIndexOf
		System.out.println("The last index of 7 is " + integerDLL.lastIndexOf(7));
		System.out.println("The last index of 8 is " + integerDLL.lastIndexOf(8));
		System.out.println("The last index of 100 is " + 
					integerDLL.lastIndexOf(100, new Compare<Integer>()));
		System.out.println("The last index of 25 is " + integerDLL.lastIndexOf(25));  // not found returns -1
		System.out.println("");
		
		int findNode;  // if findNode is 1 this means first, if 3 then this means 3rd, 
					   // and if findNode = {node}.size() this means the last node
		
		findNode = 1;  // This means the first node.  Will print exception for previous node.
		System.out.println("Node #" + findNode + " is " + integerDLL.returnNode(findNode - 1));
		try {
			System.out.println("The previous node of node #" + findNode + " is " + 
					integerDLL.returnNodePrev(findNode - 1));
		}
		catch (Exception e) {
			System.out.println(e);
		}
		System.out.println("The next node after node #" + findNode + " is " +
				integerDLL.returnNodeNext(findNode - 1));
		System.out.println("");
		
		findNode = 0;  // There is no node #0.  Starts with 1 for first.
		try {
			System.out.println("Node #" + findNode + " is " + integerDLL.returnNode(findNode - 1));
		}
		catch (Exception e) {
			System.out.println(e);
		}
		System.out.println("");
		
		findNode = integerDLL.size(); // This means the last node. Will print exception for last node.
		System.out.println("Node #" + findNode + " is " + integerDLL.returnNode(findNode - 1));
		System.out.println("The previous node of node #" + findNode + " is " + 
				integerDLL.returnNodePrev(findNode - 1));
		try {
			System.out.println("The next node after node #" + findNode + " is " +
					integerDLL.returnNodeNext(findNode - 1));
		}
		catch (Exception e) {
			System.out.println(e);
		}
		System.out.println("");
		
		// Test node in the middle		
		findNode = 3; // This means the 3rd node
		System.out.println("Node #" + findNode + " is " + integerDLL.returnNode(findNode - 1));
		System.out.println("The previous node of node #" + findNode + " is " + 
				integerDLL.returnNodePrev(findNode - 1));
		try {
			System.out.println("The next node after node #" + findNode + " is " +
					integerDLL.returnNodeNext(findNode - 1));
		}
		catch (Exception e) {
			System.out.println(e);
		}
		System.out.println("");
		
		integerDLL.clear();
		if (integerDLL.size() == 0 ) 
			System.out.println("Cleared");
		System.out.println(integerDLL.isEmpty());
		System.out.println("");
		
		
		// Test remove in forward iterator
		DoublyLinkedList<Integer> integerDLLRemove = new DoublyLinkedList<Integer>();
		integerDLLRemove.add(new Integer[]{1, 2, 3});
		DsIterator<Integer> removeIterator = integerDLLRemove.iterator();
		removeIterator.setIteratorToStart();
		
		while (removeIterator.hasNext()) {
			System.out.println("Trying to remove: " + removeIterator.next());
			removeIterator.remove();
			System.out.println("Removed");
			System.out.println("Size " + integerDLLRemove.size());
		}
		if (integerDLLRemove.size() == 0 ) 
			System.out.println("Cleared");
		else 
			System.out.println(integerDLLRemove.size());
		System.out.println();
		
		/*integerDLLRemove.add(new Integer[]{4, 5, 6});
		
		for (Integer i : integerDLLRemove)
			System.out.println("Here: " + i);
		


		// Test Backwards
		integerDLLRemove.add(new Integer[]{4, 5, 6});
		removeIterator.setIteratorToEnd();
		
		// FIXME THE REMOVE AT THE TOP ISNT REACHING nextPtr == null because if inside
		// the remove() I use the code nextPtr.setNextPtr(myPtr.getNextPtr()) the code fails
		for (Integer i : integerDLLRemove)
			System.out.println("Here: " + i);
		System.out.println();
		
		while (removeIterator.hasPrevious()) {
			System.out.println("Removing: " + removeIterator.previous());
			removeIterator.remove();
			System.out.println("Removed");
			System.out.println("Size " + integerDLLRemove.size());
		}
		System.out.println(integerDLLRemove.size());
		if (integerDLLRemove.size() == 0 ) 
			System.out.println("Cleared");
		else 
			System.out.println(integerDLLRemove.size());
		System.out.println();
		
		for (Integer i : integerDLLRemove)
			System.out.println("Here: " + i);
		System.out.println();
		*/
	}
	

	private static class Compare<T extends Comparable<T>> 
	implements Comparator<T> {
		public int compare(T o1, T o2) {
		    return o1.compareTo(o2);
		}
	}
}
