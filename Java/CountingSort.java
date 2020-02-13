import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;



public class CountingSort {

	
	public void countingSort(ArrayList<Integer> A, ArrayList<Integer> B, int k) {
		//System.out.println(B.size());
		while(B.size() < A.size()) B.add(0);
		Integer[] C = new Integer[k+1];
		for (int i = 0; i <= k; ++i) {
			C[i] = 0;	
		}
		for (int j = 0; j < A.size(); ++j) {
			C[A.get(j)] = C[A.get(j)] + 1;
		}

		for (int i = 1; i <= k; ++i)
			C[i] = C[i] + C[i-1];
	
		for (int j = (A.size() - 1); j >= 0; --j) {
			B.set((C[A.get(j)] - 1), A.get(j));
			C[A.get(j)] = C[A.get(j)] - 1;
		}
		for (Integer i: B)
			System.out.print(i + " ");
	}
	
	public void radixSort(ArrayList<Integer> A, int d) {
		for (Integer j : A)
			System.out.print(j + " ");
		System.out.println();
		System.out.println();
		for (int i = 0; i < d; ++i) {
			for (Integer k : A)
				System.out.print((int)(k/Math.pow(10,i)) % 10 + " ");

			System.out.println();
			for (Integer j : A)
				System.out.print(j + " ");
			System.out.println();
		}
		
			
	
	}
	
	public static void main (String[] args) {
		
		ArrayList<Integer> A = new ArrayList<Integer>(Arrays.asList(2, 5, 3, 0, 2, 3, 0, 3));
		ArrayList<Integer> B = new ArrayList<Integer>(A.size());
		//while(B.size() < A.size()) B.add(0);

		CountingSort testCountingSort = new CountingSort();
		//testCountingSort.countingSort(A, B, 5);
	
		Random random = new Random();
		ArrayList<Integer> A1 = new ArrayList<Integer>(20);
		for (int i = 0; i < 20; ++i)
			A1.add((random.nextInt(900) + 100));
		ArrayList<Integer> B1 = new ArrayList<Integer>(A.size());
		
		//System.out.println(Collections.max(A1));
		//testCountingSort.countingSort(A1, B1, Collections.max(A1));

		testCountingSort.radixSort(A1, 3);
	}
}
