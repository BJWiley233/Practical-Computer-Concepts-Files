public class DemoIncrement2
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
      int w = 17, x = 17, y = 18;
      boolean compare1 = (++w == y);
      boolean compare2 = (x++ == y);
      System.out.println(compare1);
      System.out.println(compare2);
   }
}