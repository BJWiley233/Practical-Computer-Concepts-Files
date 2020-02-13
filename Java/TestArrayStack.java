import com.chuckkann.datastructures.utility.stack.ArrayListStack;

public class TestArrayStack {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		ArrayListStack<Integer> arrayListStack = new ArrayListStack<Integer>();
		arrayListStack.push(1);
		for (Integer i : arrayListStack)
			System.out.println(i);
	}

}
