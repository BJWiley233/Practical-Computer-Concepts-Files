import java.util.Scanner;
import java.util.Arrays;

public class InsertSortDemo
{
   public static void main(String[] args)
   {
      int[] insertArray = new int[5];
      Scanner input = new Scanner(System.in);
      int i, j, temp;
      //int comparisonToMake = bubbleArray.length;
      
      for (i = 0; i < insertArray.length; ++i)
      {
         System.out.print("Enter a number >> ");
         insertArray[i] = input.nextInt();
      }
      
      i = 1;
      while (i < insertArray.length)
      {
         temp = insertArray[i];
         j = i - 1;
         while (j >= 0 && insertArray[j] > temp)
         {
            insertArray[j + 1] = insertArray[j];
            --j;
         }
         insertArray[j + 1] = temp;
         ++i;
      }   
      
      for (int val: insertArray)
         System.out.println(val + " ");     
      /*Arrays.sort(bubbleArray);
      for (int val : bubbleArray)
         System.out.println(val + " "); */
   }
}
      