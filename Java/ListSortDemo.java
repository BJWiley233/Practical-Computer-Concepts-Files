import java.util.Scanner;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

public class ListSortDemo
{
   public static void main(String[] args)
   {
      List<Integer> bubbleArray = new ArrayList<>();
      Scanner input = new Scanner(System.in);
      int i;     
      for (i = 0; i < 5; ++i)
      {
         System.out.print("Enter a number >> ");
         bubbleArray.add(input.nextInt());
      }
      
      
      Collections.sort(bubbleArray);
      for (int val : bubbleArray)
         System.out.println(val + " ");  
   }
}
      