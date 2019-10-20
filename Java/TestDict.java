import java.util.HashMap;
import java.util.Map;

public class TestDict
{
   public static void main(String[] args)
   {
      int[] validValues = {101, 108, 201, 213, 266,
         304, 311, 409, 411, 412};
      double[] prices   = {0.29, 1.23, 3.50, 0.69, 6.79,
         3.19, 0.99, 0.89, 1.26, 8.00};
      Map<Integer, Double> dictionary = new HashMap<Integer, Double>();
      for (int i = 0; i < validValues.length; ++i)
         dictionary.put(validValues[i], prices[i]);
      
      for (Map.Entry<Integer, Double> item : dictionary.entrySet())
      {
         System.out.println("Item #" + item.getKey() + " is $" + item.getValue());
      }
   }
      
}