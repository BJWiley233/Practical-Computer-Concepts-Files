public class NameAndAddress
{
   private String name;
   private String address;
   private int zipCode;
   public NameAndAddress(String name, String address, int zip)
   {
      this.name = name;
      this.address = address;
      zipCode = zip;
   }
   public void display()
   {
      System.out.println(name);
      System.out.println(address);
      System.out.println(zipCode);
   }
}