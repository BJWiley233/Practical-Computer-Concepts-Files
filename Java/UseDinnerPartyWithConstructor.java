import java.util.*;

public class UseDinnerPartyWithConstructor
{
   public static void main(String[] args)
   {
      int guests, choice;
      DinnerPartyWithConstructor2 aDinnerParty = new DinnerPartyWithConstructor2(50);
      Scanner input = new Scanner(System.in);
      
      System.out.print("Enter # of guests >> ");
      guests = input.nextInt();
      aDinnerParty.setGuests(guests);
      System.out.print("Enter the menu option -- 1 for chicken or 2 for beef >> ");
      choice = input.nextInt();
      aDinnerParty.setDinnerChoice(choice);
      System.out.println("The party has " + aDinnerParty.getGuests() + " guests.");
      System.out.println("Menu option " + aDinnerParty.getDinnerChoice() + " will be served.");
      
      aDinnerParty.displayInvitation();
   }
}