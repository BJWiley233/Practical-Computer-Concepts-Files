import java.util.Comparator;

/**
 * Assignment 2
 * Student class implements {@code Comparable} and {@code Comparator} interfaces.
 * Has inner classes to change sort order as well as change natural sort order
 * from grade to name.
 * @author Brian Wiley
 */

public class Student implements Comparable<Student> {

	private char grade;
	private String name;
	public static DescendingGradeComparator sortDescendingGrade = new DescendingGradeComparator();
	public static sortNameAscending sortNameAsc = new sortNameAscending();
	public static sortNameDescending sortNameDesc = new sortNameDescending();
	
	// Constructor
	public Student(String name, char grade) {
		this.grade = grade;
		this.name = name;
	}
	@Override
	public String toString() {
		return ("Name: " + name + ", Grade: " + grade);
	}
	@Override
	public int compareTo(Student student) {
		return this.grade - student.grade;
	}
	
	// Inner class to sort grade descending, should make private so information is hidden
	private static class DescendingGradeComparator implements Comparator<Student> {
		public int compare(Student student1, Student student2) {
			Character s1Grade = Character.valueOf(student1.grade); // Cannot invoke compareTo(char) on the primitive type char
			Character s2Grade = Character.valueOf(student2.grade); // Cannot invoke compareTo(char) on the primitive type char
			return s2Grade.compareTo(s1Grade);
		}
	}
	
	// Inner class to sort name ascending, should make private so information is hidden
	private static class sortNameAscending implements Comparator<Student> {
		public int compare(Student student1, Student student2) {
			return student1.name.compareTo(student2.name);
		}
	}
	// Inner class to sort name descending, should make private so information is hidden
	private static class sortNameDescending implements Comparator<Student> {
		public int compare(Student student1, Student student2) {
			return student2.name.compareTo(student1.name);
		}
	}
}
