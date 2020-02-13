import java.util.ArrayList;

public class PersonSortExample {

   public static void main(String[] args) {
      ArrayList<Person> al = new ArrayList<Person>();
      
      al.add(new Person("Jessica", 5));
      al.add(new Person("Vincent", 14));
      al.add(new Person("Ryan", 11));
      al.add(new Person("Sophia", 16));
      al.add(new Person("Rebecca", 15));

      
      System.out.println("Sorted by age ascending");
      al.sort(null);
      System.out.println(al);

      System.out.println("Sorted by age descending");
      al.sort(Person.sortAgeDescending);
      System.out.println(al);
      
      System.out.println("Sorted by name");
      al.sort(Person.sortName);
      System.out.println(al);
   }

}
