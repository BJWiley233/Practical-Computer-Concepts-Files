import java.util.Scanner;
import java.util.Arrays;

public class BubbleSortDemo
{
   public static void main(String[] args)
   {
      int[] bubbleArray = new int[5];
      Scanner input = new Scanner(System.in);
      int i, j;
      int comparisonToMake = bubbleArray.length;
      
      for (i = 0; i < bubbleArray.length; ++i)
      {
         System.out.print("Enter a number >> ");
         bubbleArray[i] = input.nextInt();
      }
      
      
      Arrays.sort(bubbleArray);
      for (int val : bubbleArray)
         System.out.println(val + " ");  
   }
}
      