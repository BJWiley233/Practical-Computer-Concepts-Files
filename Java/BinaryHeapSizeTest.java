import com.chuckkann.datastructures.PriorityQueue;
import com.chuckkann.datastructures.utility.queue.BinaryHeap;



public class BinaryHeapSizeTest {

	public static void main(String[] args) {
		PriorityQueue<Integer> pq = 
				new BinaryHeap<Integer>(256); // 256 for 8 bit code

		System.out.println(pq.size());
		
		DefaultIntValues test =  new DefaultIntValues();
		System.out.println(test.size());
	}

}
