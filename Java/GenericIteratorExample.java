
public class GenericIteratorExample {

	public static void main(String[] args) {
		GenericArray<String> ga = new GenericArray<String>(6);
		ga.set(0, "Jessica");
		ga.set(1, "Freddy");
		ga.set(2, "Sophia");
		ga.set(3, "Rebecca");
		ga.set(4, "Vincent");
		ga.set(5, "Ryan");
		
		for(String s: ga) {
			System.out.println(s);
		}

	}

}
