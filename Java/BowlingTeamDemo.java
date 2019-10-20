import java.util.Scanner;

public class BowlingTeamDemo
{
   public static void main(String[] args)
   {
      int i;
      int j;
      String name;
      int memNum;
      final int NUM_TEAMS = 3;
      Scanner input = new Scanner(System.in);
      BowlingTeam[] teams = new BowlingTeam[NUM_TEAMS];
      System.out.println(teams.length);
      /*System.out.print("Enter number of members >> ");
      memNum = input.nextInt();
      BowlingTeam teamBowl = new BowlingTeam(memNum);
      input.nextLine();
      //BowlingTeam teamBowl = new BowlingTeam(3);
      System.out.print("Enter team name >> ");
      name = input.nextLine();
      teamBowl.setTeamName(name);*/
      
      for (i = 0; i < NUM_TEAMS; ++i)
      {
         System.out.print("Enter number of members >> ");
         memNum = input.nextInt();
         teams[i] = new BowlingTeam(memNum);
         input.nextLine();
         System.out.println(teams[i].length());
         System.out.print("Enter team name >> ");
         name = input.nextLine();
         teams[i].setTeamName(name);
         for (j = 0; j < memNum; ++j)
            {
               System.out.print("Enter member first name >> ");
               name = input.nextLine();
               teams[i].setMember(j, name);
             }
       }
       
       for (i = 0; i < NUM_TEAMS; ++i)
      {
         System.out.print("Team name " + teams[i].getTeamName() + ": ");     
         for (j = 0; j < teams[i].length(); ++j)
            {
               System.out.print(teams[i].getMember(j) + " ");
             }
         System.out.println("");
       }

      

   }
}