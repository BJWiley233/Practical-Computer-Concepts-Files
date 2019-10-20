public class School
{
   private NameAndAddress nameAdd;
   private int enrollment;
   public School(String name, String add, int zip, int enrollment)
   {           
      nameAdd = new NameAndAddress(name, add, zip);
      this.enrollment = enrollment;
   }
   public void display()
   {
      System.out.println("The School information:");
      nameAdd.display();
      System.out.println("Enrollment is: " + enrollment);
   }
}