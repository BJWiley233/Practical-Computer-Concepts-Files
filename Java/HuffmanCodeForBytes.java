import java.io.Serializable;

import com.chuckkann.datastructures.DataStructuresException;
import com.chuckkann.datastructures.PriorityQueue;
import com.chuckkann.datastructures.utility.queue.BinaryHeap;

public class HuffmanCodeForBytes implements Serializable {

	private static final long serialVersionUID = 1L;
	
	public static int[] countFrequency(String s) {
		int[] frequency = new int[256];
		
		for(int i = 0, n = s.length() ; i < n ; i++) { 
		    char c = s.charAt(i); 
		    frequency[c]++;
		}
		
		return frequency;
	}

	public static HuffmanRoot buildTree(int[] frequency) throws DataStructuresException {
		//Build a priority queue of the text;
		PriorityQueue<AsciiCodeNode> pq = 
			new BinaryHeap<AsciiCodeNode>(256); // 256 for 8 bit code
			
		// put initial nodes in tree
		for (int i = 0; i < frequency.length; i++) {
			if (frequency[i] != 0) {
				AsciiCodeNode acn = new AsciiCodeNode(i, frequency[i]); 
				pq.insert(acn);
			}
		}	
		
		// I wanted to also print the nodes of the Binary Heap
		System.out.println("Nodes of Binary Heap:");
		int j = 1;
		for (AsciiCodeNode acn : pq) {
			System.out.println(j + ": " + acn);
		}
		
		// build tree from priority queue

		if (pq.isEmpty()) {
			throw new DataStructuresException("Your input string did not have any characters in it");
		}
		else if (pq.size() == 1) {
			return pq.deleteFirst();
		}

		int nextAvailable = 256;  // Give each node a unique name
		
		while (pq.size() > 1) {
			// deleteFirst on two nodes, create a new node whose
			// children are these two nodes, and the frequency
			// is the sum of the two nodes
			AsciiCodeNode left = pq.deleteFirst();
			AsciiCodeNode right = pq.deleteFirst();
			AsciiCodeNode newAcn = new AsciiCodeNode(nextAvailable, 
													 left.getFrequency() + right.getFrequency(),
													 left, right);
			// insert the node back into the priority queue as process for creating Huffman tree
			pq.insert(newAcn);
            
			// increase next available for next node to be added
			nextAvailable = nextAvailable + 1;
		}
		
		// What is left should be the root of a Huffman tree
		// I just wanted to print this out so I can see root node and frequency
		System.out.println();
		System.out.println("Huffman root is:");
		int k = 1;
		// should only be 1
		for (AsciiCodeNode acn : pq) {
			System.out.println(k + ": " + acn.getAsciiCode() + ';' + acn.getFrequency());
		}

		// return Huffman root
		return pq.deleteFirst();
	}
	
	/**
	 * 
	 * @param hr
	 * @return table includes the Huffman code at the character's index
	 * @throws DataStructuresException
	 */
	public static String[] buildHuffmanCode(HuffmanRoot hr) throws DataStructuresException {
		String[] table = new String[256];
		// see comments below for generateCode()
		generateCode((AsciiCodeNode)hr, "", table);
		
		return table;
	}
	
	/**
	 * Translate the String s by translating each character in 
	 * s to the corresponding Huffman code.  Append all the 
	 * Huffman codes together.  This is your encrypted String
	 * @return encoded string from Huffman codes the encrypts initial string
	 */
	public static String encodeString(String[] huffmanCode, String s) {
		// Basically just takes each of the characters in str and appends
		// the that index of the String array huffmanCode created in generateCode() 
		// which is mapped to that character
		String encoded = "";
		for (int i = 0; i < s.length(); ++i) {
			char c = s.charAt(i);
			encoded += huffmanCode[c];
		}
		return encoded;
	}
	
	/**
	 * walk the nodes each time starting over at the root.  Note
	 * this is not a recursive function.  If the next character
	 * in s is a 0, node = node.left.  If the character is 1,
	 * node = node.right.  Stop when node.left is null.  The
	 * character in the node will be the original character.
	 */
	public static String decodeString(HuffmanRoot hr, String s) {
		String originalString = "";	
		AsciiCodeNode node = (AsciiCodeNode)hr;
		
		int i = 0;
		// while still 0's and 1's left in encrypted string
		while (i < s.length()) {
			// if we have not reach a left node keep looping until we do
			while (node.getLeft() != null) {
				// if character is '0' walk left and increment i for next letter in encryption
				if (s.charAt(i) == '0') {
					node = node.getLeft();
					++i;
				}
				// if character is '1' walk right and increment i for next letter in encryption
				else if (s.charAt(i) == '1') {
					node = node.getRight();
					++i;
				}
			}
			// after reaching a node which its left is null get the character for the node and append for original string
			originalString += (char) node.getAsciiCode();
			// this restarts the loop back at the root
			node = (AsciiCodeNode)hr;
		}

		return originalString;
	}
	
	/**
	 * if acn.left is null, acn.right must be null, and this is
	 * a left node.  call acn.getAsciiCode to get the ASCII cod
	 * for this leaf.  This is the index for the code in the table.
	 * The string for this code should be in the argumentString "code"
	 */
	private static void generateCode(AsciiCodeNode acn, String code,
			String[] table) {
	
		// since left is null, right is null so this is a leaf and should insert code into table 
		// and index which is the acn.getAscciCode
		if (acn.getLeft() == null)
		{
			table[acn.getAsciiCode()] = code;
		}
		
		// recursive walk the tree for each acn node by calling
		// generateCode for the left and right nodes.  Add a "0" to 
		// the code string when you walk left, and a "1" when you walk right.
		//
		else {
			// if walking left append "0" to code
			generateCode(acn.getLeft(), code + "0", table);
			// if walking right append "1" to code
			generateCode(acn.getRight(), code + "1", table);
		}

	}

	public static interface HuffmanRoot {	
	}
	
	private static class AsciiCodeNode 
	    implements Comparable<AsciiCodeNode>,
	    HuffmanRoot {
		private int asciiCode;
		private int frequency;
		private AsciiCodeNode left, right;
		
		public AsciiCodeNode(int asciiCode, int frequency) {
			this.asciiCode = asciiCode;
			this.frequency = frequency;
			this.left = null;
			this.right = null;
		}
		
		public AsciiCodeNode(int asciiCode, int frequency, 
			   AsciiCodeNode left,
			   AsciiCodeNode right) {
			this.asciiCode = asciiCode;
			this.frequency = frequency;
			this.left = left;
			this.right = right;
		}
		
		public int getAsciiCode() {
			return asciiCode;
		}
		
		public int getFrequency() {
			return frequency;
		}
		
		public AsciiCodeNode getLeft() {
			return left;
		}
		
		public AsciiCodeNode getRight() {
			return right;
		}
						
		public int compareTo(AsciiCodeNode n) {
			if (this.frequency == n.frequency) {
				return this.asciiCode - n.asciiCode;
			}
			return this.frequency - n.frequency;
		}
		
		public String toString() {
			return ((char) asciiCode + ";" + frequency);
		}
	}
}
