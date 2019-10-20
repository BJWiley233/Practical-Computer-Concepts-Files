import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

/**
 * Trying implementation of Python's Itertools.product implementation
 * of Cartesian Product without recursion: 
 * @see <a href="https://docs.python.org/2/library/itertools.html#itertools.product">itertools.product</a>
 * @see <a href="https://stackoverflow.com/questions/37348906/convert-this-single-line-nested-for-loop-to-multi-line-in-python">
 * Resource for explanation of list comprehension back to nested loops</a>
 * <pre>
 * {@code 
 * result = [[]]
 for pool in pools:
	nresult = []
	for x in result2:
		for y in pool:
			nresult.append(x+[y])
	result = nresult
* }
* </pre>
*/

public class CartesianProduct {
	
	public static void main(String[] args) {
		List<String> aSet = new ArrayList(Arrays.asList("A", "B"));
		List<List<String>> pools = new ArrayList<List<String>>();
		int repeat = 3;
		for (int i = 0; i < repeat; ++i) {
			pools.add(aSet);
		}
		List<List<String>> result = new ArrayList<List<String>>();
		for (List<String> pool : pools) {
			//System.out.println(pool);
			List<String> nresult = new ArrayList<String>();
			for (List<String> x : result) {
				for (String y : pool) {
					nresult.addAll(x);
					System.out.println(nresult);
				}	
			}
			result = nresult;  // error here, cannot do nested list = regular list like in Python
		}
		System.out.println(result);
	}
}
