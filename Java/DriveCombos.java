
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class DriveCombos {
   
   
   public static void main(String[] args) {
      
      Combos drive = new Combos();
      
      int arraySize = 28;
      Random random = new Random();
      int[] A = new int[arraySize];
      
      System.out.println("Here is the initial array:");
      for (int i = 0; i < arraySize; ++i)
         A[i] = random.nextInt(100);
      
      
      for (int i : A) System.out.print(i + " ");
      System.out.println();
      System.out.println("Total sum is: " + Arrays.stream(A).sum());
      
      /*
       * Test Deterministic using all n Choose k combinations, i.e. by
       * BruteForce
       */
      List<ArrayList<Integer>> mininumDifference = new ArrayList<ArrayList<Integer>>();
      mininumDifference = drive.bruteForceDeterministic(A);
      System.out.println("\n--------------------------------------------------------------");
      System.out.println("Smallest difference: " +
            Math.abs(mininumDifference.get(1).get(0)-
                  mininumDifference.get(3).get(0)) + "\n");
      System.out.println("Partition: "); 
      System.out.println("1st Subset - " + mininumDifference.get(0) + 
            ", sum = " + mininumDifference.get(1));
      System.out.println("2nd Subset - " + mininumDifference.get(2) + 
            ", sum = " + mininumDifference.get(3));
      
   }
   
}
