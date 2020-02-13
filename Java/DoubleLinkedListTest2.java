import java.util.Comparator;

import com.chuckkann.datastructures.DsIterator;
import com.chuckkann.datastructures.indexedlist.DoublyLinkedList2;

/**
 * 
 * @author bjwil
 *
 */

public class DoubleLinkedListTest2 {

	public static void main(String[] args) {
		DoublyLinkedList2<Integer> integerDLL = new DoublyLinkedList2<Integer>();
		Integer[] intItems = {9, 11, 13};
		for (Integer i : integerDLL)
			System.out.println(i);
		// Test adding at beginning, inside, and array at end
		integerDLL.add(7);
		integerDLL.add(0, 3);
		integerDLL.add(1, 5);
		integerDLL.add(0, 1);
		integerDLL.add(integerDLL.size(), intItems);
		integerDLL.add(7, 15);
		integerDLL.add(3, 15);
		integerDLL.add(0, 7);
		
		System.out.println("Here is your list forward:");
		for (Integer i : integerDLL)
			System.out.print(i + " ");
		System.out.println();
		DsIterator<Integer> iterator = integerDLL.iterator();
		System.out.println("And here is your list backwards:");
		iterator.setIteratorToEnd();
		while (iterator.hasPrevious()) {
			System.out.print(iterator.previous() + " ");
		}
		System.out.println("\n");

		// Test index of and last index of
		System.out.print("The first index of 15 starting at index 5 is ");
		System.out.println(integerDLL.indexOf(5, 15, new Compare<Integer>()));
		System.out.print("The last index of 7 is ");
		System.out.println(integerDLL.lastIndexOf(7));
		System.out.println();
		
		// Test set
		System.out.print("Index 6 was ");
		System.out.print(integerDLL.set(6, 99));
		System.out.println(" and now it is " + integerDLL.retrieve(6));
		for (Integer i : integerDLL)
			System.out.print(i + " ");
		System.out.println("\n");
		
		// Test removing inside and at numElements which is out of range
		try {
			System.out.println(integerDLL.remove(integerDLL.size()));
		} catch (Exception e) {
			System.out.println("Index of array size is out of bounds");
		}
		System.out.println(integerDLL.remove(2));
		for (Integer k : integerDLL)
			System.out.print(k + " ");
		System.out.println();
		System.out.println(integerDLL.remove(5));
		for (Integer k : integerDLL)
			System.out.print(k + " ");
		System.out.println("\n");
		
		// Test removing at end and beginning until list is empty without iterator
		for (int i = integerDLL.size() - 1; i >= 0; i--) {
			// Remove at ends
			if (i % 2 == 1) {
				System.out.println(integerDLL.remove(i));
				for (Integer k : integerDLL)
					System.out.print(k + " ");
				System.out.println();
			}
			// Remove at beginning
			else {
				System.out.println(integerDLL.remove(0));
				for (Integer k : integerDLL)
					System.out.print(k + " ");
				System.out.println();
			}
		}
		System.out.println("Is empty? " + integerDLL.isEmpty());
		System.out.println("Size is: " + integerDLL.size());
		
		// Test we can still iterate with no exception even when list is blank
		for (Integer i : integerDLL)
			System.out.println(i);
		System.out.println("");
		
		
		// After removing all elements, test adding back in and using iterators forward and back
		integerDLL.add(2);
		integerDLL.add(1, 12);
		integerDLL.add(1, 4);
		Integer[] intEvenItems = {6, 8, 10};
		integerDLL.add(2, intEvenItems);
		System.out.println("New size is: " + integerDLL.size());
		
		// Forward iteration
		int j = 1;
		System.out.println("Try iterating forward");
		try {
			for (Integer i : integerDLL) {
				System.out.println("Node #" + j + "(index " + (j - 1) + ")" + " is " + i);
				++j;
				}
			} catch (NullPointerException e) {         // Just making sure no null pointers
				System.out.println("OK after clear");
			}
		System.out.println("");
		// Reverse iteration
		DsIterator<Integer> reverseDLL = integerDLL.iterator();
		reverseDLL.setIteratorToEnd();
		j = integerDLL.size();
		System.out.println("Try iterating backward");
		while (reverseDLL.hasPrevious()) {
			System.out.println("Node #" + j + "(index " + (j - 1) + ")" + " is " + reverseDLL.previous());
			--j;
		}
		System.out.println("\n");	
				
		
		// Test remove() in forward iterator
		DoublyLinkedList2<Integer> integerDLLRemove = new DoublyLinkedList2<Integer>();
		integerDLLRemove.add(new Integer[]{7, 8, 9, 10, 11, 12});
		DsIterator<Integer> removeIterator = integerDLLRemove.iterator();
		removeIterator.setIteratorToStart();
		
		System.out.println("Try removing with forward iterator:");
		while (removeIterator.hasNext()) {
			removeIterator.next();
			removeIterator.remove();
			for (Integer k : integerDLLRemove)
				System.out.print(k + " ");
			System.out.println("*");
		}
		if (integerDLLRemove.size() == 0 ) 
			System.out.println("Cleared");
		// Test we can still iterate with no exception even when list is blank from remove() in iterator
		try {
			System.out.println("Size after forward iterator = " + integerDLLRemove.size());
			for (Integer i : integerDLLRemove)
				System.out.println("Still but shouldn't be: " + i);
		} catch (NullPointerException e) {         // Just making sure no null pointers
			System.out.println("Nothing here but exception!");
		} finally {
			System.out.println("Final size: " + integerDLLRemove.size());
		}
		System.out.println();
		
		// add back in elements after all have been removed with remove() in iterator
		integerDLLRemove.add(new Integer[]{13, 14, 15, 16, 17, 18});
		
		// check only new added elements exist
		System.out.println("New List:");
		for (Integer i : integerDLLRemove)
			System.out.print(i + " ");
		System.out.println();
		
		// Test remove() in backward iterator
		removeIterator.setIteratorToEnd();
		System.out.println("Size before backward iterator = " + integerDLLRemove.size());
		
		System.out.println("Try removing with backwards iterator:");
		while (removeIterator.hasPrevious()) {
			removeIterator.previous();
			removeIterator.remove();
			for (Integer i : integerDLLRemove)
				System.out.print(i + " ");
			System.out.println("*");
		}
		
		try {
			System.out.println("Size after forward iterator = " + integerDLLRemove.size());
			for (Integer i : integerDLLRemove)
				System.out.println("Still Here Ugh!: " + i);
		} catch (NullPointerException e) {
			System.out.println("Nothing here but exception ugh");
		} finally {
			System.out.println("Final size: " + integerDLLRemove.size());
		}
		
	}

	private static class Compare<T extends Comparable<T>> 
	implements Comparator<T> {
		public int compare(T o1, T o2) {
		    return o1.compareTo(o2);
		}
	}
}
