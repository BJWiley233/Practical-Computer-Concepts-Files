public class DemoIncrement
{
   public static void main(String[] args)
   {
      int v = 4;
      int plusPlusV = ++v;
      System.out.println(v);
      v = 4;
      int vPlusPlus = v++;
      System.out.println(v);
      System.out.println(plusPlusV);
      System.out.println(vPlusPlus);
   }
}