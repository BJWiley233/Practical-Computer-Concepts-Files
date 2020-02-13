class ShapeUtilities {
    public static double calculateCircleArea(double radius) {
    	return Math.PI * radius * radius;
    }
}
public class CalculateCircleArea {
    public static void main(String[] args) {
    	System.out.println(ShapeUtilities.calculateCircleArea(3));
    	System.out.println(ShapeUtilities.calculateCircleArea(3));
    }
}