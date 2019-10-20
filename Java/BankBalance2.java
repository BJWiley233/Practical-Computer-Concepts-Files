import java.util.Scanner;

public class BankBalance2
{
   public static void main(String[] args)
   {
      double balance;
      int response;
      int year = 1;
      final double INT_RATE = 0.03;
      Scanner input = new Scanner(System.in);
      System.out.print("Enter initial balance >> ");
      balance = input.nextDouble();
      input.nextLine(); // don't really need
      do
      {
         balance = balance + balance * INT_RATE;
         System.out.println("After year " + year + " at " + INT_RATE*100 + 
               "% interest rate, balance will be $" + balance);
         System.out.print("Enter 1 for next year or any other number to stop >> ");
         response = input.nextInt();
      } while (response == 1);
   }
}