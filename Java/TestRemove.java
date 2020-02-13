import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;



public class TestRemove {

	public static void main(String[] args) {
		List<String> list = new ArrayList<>();
		//list.addAll(String[] {"Brian", "Chris", "Tom"});
		list.addAll(Arrays.asList(new String[]{"B", "C", "D"}));
		list.remove(0);
		list.remove(0);
		list.remove(0);
		list.addAll(Arrays.asList(new String[]{"B", "C", "D"}));
		// This is a clever way to create the iterator and call iterator.hasNext() like
		// you would do in a while-loop. It would be the same as doing:
//		     Iterator<String> iterator = list.iterator();
//		     while (iterator.hasNext()) {
		for (Iterator<String> iterator = list.iterator(); iterator.hasNext();) {
		    String string = iterator.next();
		    iterator.remove();
		}
		System.out.println(list.size());
		for (String s : list) {
			System.out.println(s);
			System.out.println("b");
		}
	}

}
