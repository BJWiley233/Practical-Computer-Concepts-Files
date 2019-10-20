import java.util.Scanner;

public class ValidSupervisor
{
   public static boolean isValidSupervisor(String name)
   {
      boolean isValid;
      switch(name)
      {
         case "Jones":
         case "Staples":
         case "Tejano":
            isValid = true;
            break;
         default:
            isValid = false;
      }
      return isValid;
   }
   
   public static void main(String[] args)
   {
      /*Scanner input = new Scanner(System.in);
      String name = input.nextLine();
      if(isValidSupervisor(name))
         System.out.println("Valid");
      else
         System.out.println("Invalid");*/
      boolean p, q, r;
      p = true;
      q = true;
      r = true;
      
      System.out.println((!q || r));
   }
}