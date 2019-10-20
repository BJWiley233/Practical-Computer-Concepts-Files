public class TestArray
{
   public static void main(String[] args)
   {
      double[] someDoubles = {1.1, 1.2, 1.3, 1.4, 1.5};
      //someDoubles = {1.1, 1.2, 1.3, 1.4, 1.5};
      //System.out.println(someDoubles);
      for (double val : someDoubles)
         System.out.println(val);
   }
}