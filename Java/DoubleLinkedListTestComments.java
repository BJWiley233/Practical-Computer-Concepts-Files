import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.Comparator;

import com.chuckkann.datastructures.DsIterator;
import com.chuckkann.datastructures.indexedlist.DoublyLinkedListComments;

/**
 * 
 * @author bjwil
 * @since 7/10/2019
 */

public class DoubleLinkedListTestComments {

	public static void main(String[] args) throws FileNotFoundException {
		
		// Uncomment next 2 lines to print to text file
		//PrintStream out = new PrintStream("./outputDLL.txt");
		//System.setOut(out);
		
		DoublyLinkedListComments<Integer> integerDLL = new DoublyLinkedListComments<Integer>();
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
		
		// Test set and retrieve
		int setIndex = 6;
		System.out.print("Index 6 was ");
		System.out.print(integerDLL.set(setIndex, 99));
		System.out.println(" and now it is " + integerDLL.retrieve(setIndex));
		for (Integer i : integerDLL)
			System.out.print(i + " ");
		System.out.println("\n");
		
		// Test returning nodes
		System.out.println("Node at index 0 is " + integerDLL.returnNode(0));
		System.out.println("Next node after index 0 is " + integerDLL.returnNodeNext(0));
		try {
			System.out.println("Prev node before index 0 is " + integerDLL.returnNodePrev(0));
		} catch (Exception e) {
			System.out.println(e);
		}
		System.out.println("Node at index 9 is " + integerDLL.returnNode(9));
		System.out.println("Prev node before index 9 is " + integerDLL.returnNodePrev(9));
		try {
			System.out.println("Next node after index 9 is " + integerDLL.returnNodeNext(9));
		} catch (Exception e) {
			System.out.println(e);
		}
		System.out.println();
		
		// Test removing inside the ends and at numElements which is out of range
		// Include iteration testing
		DsIterator<Integer> reverseWhileRemovingDLL = integerDLL.iterator();
		try {
			System.out.println(integerDLL.remove(integerDLL.size()));
		} catch (Exception e) {
			System.out.println("Index of size is out of bounds");
		}
		System.out.println("Test removing inside ends");
		System.out.println(integerDLL.remove(2));
		for (Integer k : integerDLL)
			System.out.print(k + " ");
		System.out.println();
		reverseWhileRemovingDLL.setIteratorToEnd();
		while (reverseWhileRemovingDLL.hasPrevious()) {
			System.out.print(reverseWhileRemovingDLL.previous() + " ");
		}
		System.out.println();
		System.out.println(integerDLL.remove(5));
		for (Integer k : integerDLL)
			System.out.print(k + " ");
		System.out.println();
		reverseWhileRemovingDLL.setIteratorToEnd();
		while (reverseWhileRemovingDLL.hasPrevious()) {
			System.out.print(reverseWhileRemovingDLL.previous() + " ");
		}
		System.out.println();
		System.out.println("\n");
		
		// Test removing at end and beginning until list is empty without iterator
		System.out.println("Test removing at ends");
		for (int i = integerDLL.size() - 1; i >= 0; i--) {
			// Remove at ends
			if (i % 2 == 1) {
				System.out.println(integerDLL.remove(i));
				for (Integer k : integerDLL)
					System.out.print(k + " ");
				System.out.println();
				reverseWhileRemovingDLL.setIteratorToEnd();
				while (reverseWhileRemovingDLL.hasPrevious()) {
					System.out.print(reverseWhileRemovingDLL.previous() + " ");
				}
				System.out.println();
			}
			// Remove at beginning
			else {
				System.out.println(integerDLL.remove(0));
				for (Integer k : integerDLL)
					System.out.print(k + " ");
				System.out.println();
				reverseWhileRemovingDLL.setIteratorToEnd();
				while (reverseWhileRemovingDLL.hasPrevious()) {
					System.out.print(reverseWhileRemovingDLL.previous() + " ");
				}
				System.out.println();
			}
		}
		System.out.println("Is empty? " + integerDLL.isEmpty());
		System.out.println("Size is: " + integerDLL.size());
		
		// Test we can still iterate forward with no exception even when list is blank
		for (Integer i : integerDLL)
			System.out.println(i);
		System.out.println("");
		
		// Test we can still iterate backward with no exception even when list is blank
		DsIterator<Integer> reverseBlankDLL = integerDLL.iterator();
		reverseBlankDLL.setIteratorToEnd();
		System.out.println("Try iterating blank list backward:");
		while (reverseBlankDLL.hasPrevious()) {
			System.out.println(reverseBlankDLL.previous());
		}
		System.out.println("\n");
		
		
		// After removing all elements, test adding back in and using iterators forward and back
		integerDLL.add(2);
		integerDLL.add(1, 12);
		integerDLL.add(1, 4);
		Integer[] intEvenItems = {6, 8, 10};
		integerDLL.add(2, intEvenItems);
		System.out.println("New array has size: " + integerDLL.size());
		
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
		DoublyLinkedListComments<Integer> integerDLLRemove = new DoublyLinkedListComments<Integer>();
		integerDLLRemove.add(new Integer[]{4, 5, 6, 7, 8, 9});
		DsIterator<Integer> removeIterator = integerDLLRemove.iterator();
		removeIterator.setIteratorToStart();
		
		int m = 1;
		int n = 0;
		System.out.println("Try removing with forward iterator:");
		while (removeIterator.hasNext()) {
			removeIterator.next();
			removeIterator.remove();
			for (n = 0; n < m; ++n)
				System.out.print("* ");
			for (Integer k : integerDLLRemove)
				System.out.print(k + " ");
			System.out.println("");
			++m;
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
		System.out.println("Size before backward iterator = " + integerDLLRemove.size());
		removeIterator.setIteratorToEnd();
		System.out.println("Try removing with backwards iterator:");
		while (removeIterator.hasPrevious()) {
			removeIterator.previous();
			removeIterator.remove();
			for (Integer i : integerDLLRemove)
				System.out.print(i + " ");
			System.out.println("*");
		}
		// Test we can still iterate with no exception even when list is blank from remove() in iterator
		try {
			System.out.println("Size after forward iterator = " + integerDLLRemove.size());
			for (Integer i : integerDLLRemove)
				System.out.println("Still here but shouldn't be: " + i);
		} catch (NullPointerException e) {
			System.out.println("Nothing here but exception!");
		} finally {
			System.out.println("Final size: " + integerDLLRemove.size());
		}
		System.out.println();
		
		// Last add back in and confirm forward and backward iterator
		integerDLLRemove.add(new Integer[]{90, 91, 92, 93, 94, 95});
		for (Integer i : integerDLLRemove)
			System.out.print(i + " ");
		System.out.println();
		removeIterator.setIteratorToEnd();
		while (removeIterator.hasPrevious())
			System.out.print(removeIterator.previous() + " ");
	}

	private static class Compare<T extends Comparable<T>> 
	implements Comparator<T> {
		public int compare(T o1, T o2) {
		    return o1.compareTo(o2);
		}
	}
}
