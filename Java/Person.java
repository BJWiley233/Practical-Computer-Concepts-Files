import java.util.Comparator;

public class Person implements Comparable<Person> {
   private int age;
   private String name;
   public static DescendingAgeComparator sortAgeDescending = 
         new DescendingAgeComparator();
   public static NameComparator sortName = new NameComparator();
   
   public Person(String name, int age) {
      this.name = name;
      this.age = age;
   }
   
   public String toString() {
      return ("name: " + name + ", age: " + age);
   }
   
   // Comparable for natural sort order by age ascending
   public int compareTo(Person p ) {
      return this.age - p.age;
   }
   
   // Comparator to sort by age descending
   private static class DescendingAgeComparator implements Comparator<Person> {
      public int compare(Person p1, Person p2) {
         return (p2.age - p1.age);
      }     
   }
   
   // Comparator to by name
   private static  class NameComparator implements Comparator<Person> {
      public int compare(Person p1, Person p2) {
         return p1.name.compareTo(p2.name);
      }     
   }
}