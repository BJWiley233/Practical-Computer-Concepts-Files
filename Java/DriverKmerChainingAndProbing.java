import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class DriverKmerChainingAndProbing {
   
   public static void main(String [] args) throws IOException {
      
      List<String> inputKmer = new ArrayList<String>();
      // Did a large kmer 22 so the duplicate print doesn't overload driver
      try {
         BufferedReader br = new BufferedReader(new FileReader(args[0]));
         inputKmer = ReadHashInput.readData(br, "fasta", 22);
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
      System.out.println(inputKmer.size());
      
      HashTableChaining<String, Counter> htKmer = new HashTableChaining<String, Counter>();
   
      for (String s : inputKmer) {
         htKmer.insert(s, new Counter());
      }
      System.out.println(htKmer.numElements());
      for (KeyValue<String, Counter> kv : htKmer.flattenSort("v", "d", true, 10))
         System.out.println(kv);
      System.out.println("\n");
   }
}
