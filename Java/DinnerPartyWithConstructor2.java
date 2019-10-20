public class DinnerPartyWithConstructor2 extends PartyWithConstructor2
{
   private int dinnerChoice;
   
   DinnerPartyWithConstructor2(int numGuests)
   {
      int brian; // error: call to super must be first statement in constructor
      super(numGuests);
   }
   
   public int getDinnerChoice()
   {
      return dinnerChoice;
   }
   public void setDinnerChoice(int dinnerChoice)
   {
      this.dinnerChoice = dinnerChoice;
   }
   @Override
   public void displayInvitation()
   {
      System.out.println("Please come to dinner my party!");
   }

}