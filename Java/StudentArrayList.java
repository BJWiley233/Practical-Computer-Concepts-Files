import java.util.ArrayList;

/**
 * Assignment 2
 * Create a Student class, which has a name and a grade.  
 * Make an ArrayList of Students.  
 * Sort the ArrayList by grade(ascending/descending), and name(ascending/descending).
 * @author Brian Wiley
 */

public class StudentArrayList {
	
	public static void main(String[] args) {
		ArrayList<Student> studentList = new ArrayList<Student>();
		// Initialize ArrayList of Student objects and append ArrayList 
		studentList.add(new Student("Taylor", 'B'));
		studentList.add(new Student("Benjamin", 'C'));
		studentList.add(new Student("Mary", 'A'));
		studentList.add(new Student("Christin", 'F'));
		studentList.add(new Student("Robert", 'B'));
		studentList.add(new Student("Brian", 'D'));
		studentList.add(new Student("Amy", 'A'));
		
		// Output by grade ascending
		System.out.println("Sorted by grade ascending");
		studentList.sort(null);
		System.out.println(studentList);
		// Output by grade descending
		System.out.println("");
		System.out.println("Sorted by grade descending");
		studentList.sort(Student.sortDescendingGrade);
		System.out.println(studentList);
		// Output by name ascending
		System.out.println("");
		System.out.println("Sorted by name ascending");
		studentList.sort(Student.sortNameAsc);
		System.out.println(studentList);
		// Output by name descending
		System.out.println("");
		System.out.println("Sorted by name descending");
		studentList.sort(Student.sortNameDesc);
		System.out.println(studentList);
	}	
}
