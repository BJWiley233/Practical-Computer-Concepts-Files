

import java.util.ArrayList;

public class UseCollectionUtility {

	public static void main(String[] args) {
		ArrayList<String> al = new ArrayList<String>();
		al.add("aaa");
		al.add("bbb");
		al.add("aaa");
		al.add("ccc");
		//al.add("aaa");
		al.add("dddd");
		
		System.out.println(CollectionUtils.countOccurrences(al, "aaa"));
	}

}
