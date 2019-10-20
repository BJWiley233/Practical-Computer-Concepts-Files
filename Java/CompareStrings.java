import java.util.Scanner;

public class CompareStrings
{
   public static void main(String[] args)
   {
   String aName = "Rose";
   String bName;
   Scanner input = new Scanner(System.in);
   if (bName == null) bName = input.nextLine();
   //String.equals(bName); // error: non-static method equals(Object) cannot be referenced from a static context
   if(aName.equals(bName))
      System.out.println("matches");
   //System.out.println(aName.compareTo(bName));
   }
}