
import java.util.ArrayList;
import java.util.List;

public class Combos {
   
   /**
    * This is a recursive way to generate the combos in line 7 of psuedocode
    * @param combinations
    * @param data
    * @param start
    * @param end
    * @param index
    * @param A
    * @param r
    */
   private void createCombinations(List<ArrayList<Integer>> combinations, 
         ArrayList<Integer> data, int start, int end, int index, int[] A, int r) {
      if (index == r) {
         @SuppressWarnings("unchecked")
         ArrayList<Integer> combination = (ArrayList<Integer>) data.clone();
         combinations.add(combination);
      } else if (start <= end) { 
          data.set(index, A[start-1]);
          createCombinations(combinations, data, start + 1, end, index + 1, A, r);
          createCombinations(combinations, data, start + 1, end, index, A, r);
      }
  }
   
   /**
    * 
    * @param n
    * @param r
    * @param A
    * @return
    */
   public List<ArrayList<Integer>> generateCombos(int n, int r, int[] A) {
      List<ArrayList<Integer>> combinations = new ArrayList<>();
      ArrayList<Integer> data = new ArrayList<>(r);
      for (int i = 1; i <= r; ++i) data.add(0);
      createCombinations(combinations, data, 1, n, 0, A, r);
      return combinations;
  }
   

   /**
    * Psuedocode implementation of FIND-MIN-DIFFERENCE-DETERMINISTIC
    * @param A
    * @return
    */
   public List<ArrayList<Integer>> bruteForceDeterministic(int [] A) {
      double arraySum = 0;
      int comboSum = 0;
      double difference = Double.MAX_VALUE;
      for (int i : A) 
         arraySum += i;
      List<ArrayList<Integer>> combos = new ArrayList<>();
      List<ArrayList<Integer>> twoSubArrays = new ArrayList<>(4);
      twoSubArrays.add(new ArrayList<>());
      twoSubArrays.add(new ArrayList<>());
      
    
      for (int i = 1; i <= (A.length/2); ++i) {  
         combos = generateCombos(A.length, i, A);
         for (ArrayList<Integer> combinations : combos) {
            for (int j : combinations) comboSum += j;
            if (Math.abs(comboSum - (arraySum/2)) <= 0.5000001) {
               twoSubArrays.set(0, combinations);
               int sumFirst = twoSubArrays.get(0).stream().mapToInt(Integer::intValue).sum();
               difference = Math.abs(comboSum - (arraySum/2));
               twoSubArrays.set(0, combinations);
               twoSubArrays.get(1).add(sumFirst);
               twoSubArrays.add(new ArrayList<>());
               twoSubArrays.add(new ArrayList<>());
               twoSubArrays.set(2, removeIntegersFromArray(A, twoSubArrays.get(0)));
               int sumSecond = twoSubArrays.get(2).stream().mapToInt(Integer::intValue).sum();

               twoSubArrays.get(3).add(sumSecond);
               return twoSubArrays;
            }
            if (Math.abs(comboSum - (arraySum/2)) < difference) {
               difference = Math.abs(comboSum - (arraySum/2));
               twoSubArrays.set(0, combinations);
            }
            comboSum = 0;
         }
      }
      int sumFirst = twoSubArrays.get(0).stream().mapToInt(Integer::intValue).sum();
      
      twoSubArrays.get(1).add(sumFirst);
      twoSubArrays.add(new ArrayList<>());
      twoSubArrays.add(new ArrayList<>());
      
      twoSubArrays.set(2, removeIntegersFromArray(A, twoSubArrays.get(0)));
      int sumSecond = twoSubArrays.get(2).stream().mapToInt(Integer::intValue).sum();
      twoSubArrays.get(3).add(sumSecond);
      return twoSubArrays;
   }
   
   
   /**
    * This does the partitioning by removing the integers of the combination
    * that provides the small minimum from the entire array to put in its partition
    * @param A
    * @param smallDiffArrayOne
    * @return
    */
   public ArrayList<Integer> removeIntegersFromArray(int[] A, ArrayList<Integer> smallDiffArrayOne) {
      ArrayList<Integer> B = new ArrayList<Integer>();
      for (int i : A) B.add(i);
      for (int i: smallDiffArrayOne) B.remove(B.lastIndexOf(i));
      return B;
   }

}
