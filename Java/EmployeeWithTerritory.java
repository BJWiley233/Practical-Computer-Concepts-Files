public class EmployeeWithTerritory extends Employee
{
   private String territory;
   private int territoryID;
   
   public String getTerritory()
   {
      return territory;
   }
   public void setTerritory(String territory)
   {
      this.territory = territory;
   }
   
   public int getTerritoryID()
   {
      return territoryID;
   }
   public void setTerritoryID(int territoryID)
   {
      this.territoryID = territoryID;
   }
}