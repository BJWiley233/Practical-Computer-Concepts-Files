import java.util.Scanner;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class BowlingTeamDemo5
{
   public static void main(String[] args)
   {
      int i;
      int j;
      String teamName;
      String memberName;
      int memNum;
      final int NUM_TEAMS = 3;
      Scanner input = new Scanner(System.in);

      LinkedHashMap<String, List<String>> teams = new LinkedHashMap<String, List<String>>();
      
      for (i = 0; i < NUM_TEAMS; ++i)
      {
         System.out.print("Enter number of members >> ");
         memNum = input.nextInt();
         input.nextLine();
         System.out.print("Enter team name >> ");
         teamName = input.nextLine();
         teams.put(teamName, new ArrayList<String>());
                  
         for (j = 0; j < memNum; ++j)
         {
            System.out.print("Enter member name >> ");
            memberName = input.nextLine();
            teams.get(teamName).add(memberName);
         }
      }
         
      System.out.println(teams);
       
      for (Map.Entry<String, List<String>> item : teams.entrySet())
      {
         System.out.print("Team name " + item.getKey() + ": ");     
         for (j = 0; j < item.getValue().size(); ++j)
         {
            System.out.print(item.getValue().get(j) + " ");
         }
      System.out.println("");
      }
      /* 
      System.out.println("\nEnter team name to see roster");
      name = input.nextLine();
      for (i = 0; i < teams.length; ++i)
         if (name.equalsIgnoreCase(teams[i].getTeamName()))
            for (j = 0; j < teams[i].length(); ++j)
               System.out.println(teams[i].getMember(j));*/
               
   }
}