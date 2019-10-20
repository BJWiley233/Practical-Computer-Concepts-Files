public class NestRealEstate
{
   private int listingNumber;
   private double price;
   private HouseData houseData;
   public NestRealEstate(int num, double price, String address, int sqFt)
   {
      listingNumber = num;
      this.price = price;
      houseData = new HouseData(address, sqFt);
   }
   public void display()
   {
      System.out.println("Listing number #" + listingNumber + " Selling for $" + price);
   }
   private class HouseData
   {
      private String streetAddress;
      private int squareFeet;
      public HouseData(String address, int sqFt)
      {
         streetAddress = address;
         squareFeet = sqFt;
      }
   }
}