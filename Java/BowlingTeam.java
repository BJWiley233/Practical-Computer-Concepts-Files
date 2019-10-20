public class BowlingTeam
{
   private String teamName;
   private int numMembers;
   private String[] members;
      
   public BowlingTeam(int numMembers)
   {
      this.members = new String[numMembers];
   }   
   
   public void setTeamName(String teamName)
   {
      this.teamName = teamName;
   }
   public String getTeamName()
   {
      return teamName;
   }
   public void setMember(int number, String name)
   {
      members[number] = name;
   }
   public String getMember(int number)
   {
      return members[number];
   }
   public int length()
   {
      return members.length;
   }
}