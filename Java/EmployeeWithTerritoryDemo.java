public class EmployeeWithTerritoryDemo
{
   public static void main(String[] args)
   {
      EmployeeWithTerritory northernRep = new EmployeeWithTerritory();
      
      if (northernRep instanceof EmployeeWithTerritory)
         System.out.println("true");
      System.out.println(northernRep instanceof EmployeeWithTerritory);
   }
}