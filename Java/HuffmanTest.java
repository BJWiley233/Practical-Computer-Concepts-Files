import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import com.chuckkann.datastructures.DataStructuresException;

public class HuffmanTest {

	public static void main(String[] args) throws DataStructuresException, IOException {
		String str = "This is a test of something cool";
		int[] test = HuffmanCodeForBytes.countFrequency(str);
		System.out.println("Counts");
        for (int i = 0; i < test.length; i++) {
        	if (test[i] != 0) 
        	    System.out.println((char)i + " " + test[i] );
        }
        System.out.println();
        
        // Build Huffman Tree
        HuffmanCodeForBytes.HuffmanRoot root = HuffmanCodeForBytes.buildTree(test);

        // Create array of strings 0s and 1s for each leaf in Huffman tree which are the letters in str
        String[] hc = HuffmanCodeForBytes.buildHuffmanCode(root);
        System.out.println("String length: " + str.length());
        System.out.println();
        
        // Print out codes for ASCII letters in Huffman tree
        System.out.println("Codes for Huffman Tree:");
        for (int i = 0; i < hc.length; i++) {
        	String s = hc[i];
        	if (s != null)
        	    System.out.println((char)i + " : " + s);
        }
        
        // Encode String array
        String encoded = HuffmanCodeForBytes.encodeString(hc, str);
        System.out.println();
        System.out.println("Full Encypted code:");
        System.out.println(encoded);

        // writes encoded bytes to file
        fileOutputStreamByteSingle("outputSteamTest.txt", encoded);
        
        // decodes bytes to original string
        String decoded = HuffmanCodeForBytes.decodeString(root, encoded);
        System.out.println();
        System.out.println("Decoded String from Encypted code:");
        System.out.println(decoded);
        
        System.out.println();
        if (decoded.compareTo(str) == 0)
        	System.out.println("Strings equal");

	}
	
	/**
	 * Reused from link: https://www.baeldung.com/java-outputstream.  Not sure if this is what
	 * was meant regarding output streams
	 * @param file
	 * @param data
	 * @throws IOException
	 * @see <a href="https://www.baeldung.com/java-outputstream">
	 * Baeldung by Kumar Chandrakant</a>
	 */
	public static void fileOutputStreamByteSingle(String file, String data) throws IOException {
	    byte[] bytes = data.getBytes();
	    try (OutputStream out = new FileOutputStream(file)) {
	        out.write(bytes);
	        out.close();
	    }
	}

}
