public class ShortCircuit
{
   public static void main(String[] args)
   {
      if(falseMethod() || trueMethod())
         System.out.println("Both true");
      else
         System.out.println("Both not true");
   }
   public static boolean trueMethod()
   {
      System.out.println("True method");
      return true;
   }
   public static boolean falseMethod()
   {
      System.out.println("False method");
      return false;
   }
}