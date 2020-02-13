import com.chuckkann.datastructures.utility.stack.ArrayListStack;
import com.chuckkann.datastructures.utility.stack.LinkedListStack;
import com.chuckkann.datastructures.Stack;
import java.util.Iterator;
class TestArrayListStack {
    public static void main(String[] args) {
        Stack<String> c = new LinkedListStack<String>(3);

        System.out.println("testing add(element) and add(index, element)");
		c.push("A"); 
		c.push("B"); 
		c.push("C"); 
       
  		System.out.println("size is " + c.size());

        System.out.println("testing iterator");
        for (String s : c) {
           System.out.println(s);
        }

        System.out.println("testing printing list");
        System.out.println(c);


        System.out.println("testing pop");
        while (! c.isEmpty()) {
           System.out.println(c.pop());
        }
        
        System.out.println("testing error");
        System.out.println(c.pop());
    }
}
