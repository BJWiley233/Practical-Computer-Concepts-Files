import com.chuckkann.datastructures.DsIterator;
import com.chuckkann.datastructures.utility.queue.QueueCircular;
import com.chuckkann.datastructures.utility.queue.QueueCircular.IteratedItems;

public class TestCircularQueue {

	@SuppressWarnings("unchecked")
	public static void main(String[] args) {
		
		// Create queue
		QueueCircular<Integer> testQC = new QueueCircular<Integer>();
		
		// Enqueue integers
		testQC.enqueue((Integer)1);
		testQC.enqueue((Integer)2);
		testQC.enqueue((Integer)3);
		testQC.enqueue((Integer)4);
		
		// Dequeue and enqueue integers
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 1
		testQC.enqueue((Integer)5);
		testQC.enqueue((Integer)6);
		testQC.enqueue((Integer)7);
		testQC.enqueue((Integer)8);
		testQC.enqueue((Integer)9);
		testQC.enqueue((Integer)10);
		testQC.enqueue((Integer)11);
		
		// Dequeue and enqueue integers
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 2
		testQC.enqueue((Integer)12); 
		System.out.println();
		
		// Test iterator using enhance foreach loop
		System.out.println("Test Forward:");
		for (Integer i: testQC) {
			System.out.println(i);
		}
		System.out.println();
		
		// Create iterator and set to end
		DsIterator<Integer> cqIterator = testQC.iterator();
		cqIterator.setIteratorToEnd();
		
		// Iterate backwards
		System.out.println("Test Backward:");
		while (cqIterator.hasPrevious()) {
			System.out.println(cqIterator.previous());
		}
		System.out.println();
		
		// Dequeue back to "non-cicular" queue so only 12 is remaining
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 3
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 4
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 5
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 6
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 7
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 8
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 9
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 10
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 11
		
		// Enqueue 13 after the only remaining 12
		testQC.enqueue((Integer)13);
		System.out.println();

		// Print forward iterator, start is 1 and end is 2
		System.out.println("Test Forward (Should only print 12 -> 13):");
		for (Integer i: testQC) {
			System.out.println(i);
		}
		System.out.println();
		
		// Set iterator back to start
		cqIterator.setIteratorToStart();
		
		// Test just to make sure you have the total iterated items at 0
		// before iterating again
		((IteratedItems<Integer>)cqIterator).returnTotalIteratedItems();
		
		// Test forward with while loop
		System.out.println("Test Forward again with while loop (Should only print 12 -> 13)");
		while (cqIterator.hasNext()) {
			System.out.println(cqIterator.next());
		}
		
		// Check iterated items should equal size
		((IteratedItems<Integer>)cqIterator).returnTotalIteratedItems();
		System.out.println("Size is: " + testQC.size());
		System.out.println();

		// Set iterator to end
		cqIterator.setIteratorToEnd();	
		
		// Test just to make sure you have the total iterated items at 0
		((IteratedItems<Integer>)cqIterator).returnTotalIteratedItems();

		// Test back again
		System.out.println("Test Backward (Should only print 13 -> 12):");
		while (cqIterator.hasPrevious()) {
			System.out.println(cqIterator.previous());
		}
		System.out.println();
		
		// Test enqueue and dequeue again
		testQC.enqueue((Integer)500);
		testQC.enqueue((Integer)501);
		testQC.enqueue((Integer)502);
		testQC.enqueue((Integer)503);
		System.out.println("Dequeue: " + testQC.dequeue());  // dq 12
		testQC.enqueue((Integer)504);
		testQC.enqueue((Integer)505);
		testQC.enqueue((Integer)506);
		
		// Print final iteration
		System.out.println("Test Forward (Should only print 13 -> 500 -> ... -> 506):");
		for (Integer i: testQC) {
			System.out.println(i);
		}
			
	}	

}
