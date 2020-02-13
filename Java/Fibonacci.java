
public class Fibonacci {

	public static void main(String[] args) {
		for (long i = 3; i < 40; i++) {
			System.out.println(i + " " + fibonacci(i));
		}
	
	}
	
	public static int fibonacci(long n) {
		if (n == 0 || n == 1)
			return 1;
		else
			return fibonacci(n-1) + fibonacci(n-2);
		
	}

}
