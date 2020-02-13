
public class PrintString {

	public static void main(String[] args) {
	        String s = "";
			print_0_1_String(s, 5);
	}
	
	public static void print_0_1_String(String s, int n) {
		if (n == s.length()) {
			System.out.print(s + " ,");
		}
		else { 
			print_0_1_String(s + "0", n);
			if (s.endsWith("1")) {
				// Do nothing
			}
			else {
				print_0_1_String(s+'1', n);
			}
	    }
    }
}
