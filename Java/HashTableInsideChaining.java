import java.util.Stack;

public class HashTableInsideChaining<K extends Comparable<K>, V extends Comparable<V>> {
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_MODULO = 120;
   private static int DEFAULT_BUCKETS = 1;

   private int n = 0; // the n
   private int m; // the m
   private int modulo;
   private int numBuckets;  // not going to use
   private int collisions = 0;
   private int tableRows;
   
   private int duplicatesCounter = 0;
   private int elementsNotAddedCounter = 0;
   private Stack<Integer> stackTrace;
   private boolean divisionHashing;
   private KeyValue<K, V>[][] keys;
   
   public HashTableInsideChaining() {
      this(DEFAULT_SIZE, DEFAULT_MODULO, DEFAULT_BUCKETS, true);
   }
   
   public HashTableInsideChaining(int modulo, int buckets, boolean divisionHashing) {
      this(DEFAULT_SIZE, modulo, buckets, true);
   }
   
   @SuppressWarnings("unchecked")
   public HashTableInsideChaining(int size, int modulo, int buckets,
         boolean divisionHashing) {
      n = 0;
      m = size;
      this.modulo = modulo;
      this.numBuckets = buckets;
      this.divisionHashing = divisionHashing;
      this.tableRows = size/numBuckets;
      keys = (KeyValue<K, V>[][]) new KeyValue[this.tableRows][buckets];
      stackTrace = new Stack<Integer>();
      for (int i = 0; i < tableRows; ++i) {
         for (int j = 0; j < numBuckets; ++j)
            stackTrace.push(i);
      }
   }
      
   public int numElements() {
      return n;
   }
   
   public int size() {
      return m;
   }
   
   public int duplicates() {
      return duplicatesCounter;
   }
   
   public int stackSize() {
      return stackTrace.size();
   }
   
   public void getFreeSpaces() {
      for (int i : stackTrace) 
         System.out.print(i + " ");
      System.out.println();
   }
   
   public int numCollisions() {
      return collisions;
   }
   
   public int numElementsNotAdded() {
      return elementsNotAddedCounter;
   }
   
   public int hash(K key, int index) {
      return (int) key % modulo;
   }
   
   public int probe(K key, int index) {
      int i;
      if(!(key instanceof Integer)) {
         i = (key.hashCode() & 0x7fffffff) % modulo; 
      }
      else {
         i = hash(key, index);
      }
      return i;
   }
   
   public int ownHashScheme() {
      return -1;
   }
   
   @SuppressWarnings("unchecked")
   public boolean checkDup(K key, V value, KeyValue<K, V> kv) {
      if (kv != null && key.equals(kv.getKey())) {
         duplicatesCounter++;
         System.out.print("Key " + key + " matches existing key " + 
               kv.getKey() + ". ");
         if (kv.getValue() instanceof Counter) {
            System.out.println("Increasing Value Count.");
            Counter newCount = (Counter) kv.getValue();
            newCount.increment();
            kv.setValue((V) newCount); 
         }
         else {
            System.out.println("Overwriting value.");
            kv.setValue(value);
         }
         return true;
      } 
      return false;
   }
   
   public int insert(K key, V value) {
      if (n >= m) {
         System.err.println("Hash table overflow");
         return -1;
      }
      int i = -1;
      int l = 0;  // for buckets
      int h_k = 0;
      if (divisionHashing)
         h_k = probe(key, 0);
      else {
         
      }
      i = h_k;

      try {
      // We check until a slot was free/null or was marketed as deleted. If it was 
      // entered and then deleted, the slot would be not null but we want to use
      // it if it was marked deleted so we use it and exit loop
         while (keys[i][l] != null && !(keys[i][l].wasDeleted())) {
            if (checkDup(key, value, keys[i][l]))
               return -1;
            // don't need to check other buckets, only 1 for chaining
            collisions++;
            // input in last open spot in table represented by the top of the stack
            // since the Last in of the stack is bottom up
            i = stackTrace.pop();
         }
         
         // check if was collision and add next pointer to last element of chain 
         KeyValue<K, V> newKeyValue;
         if (i != h_k) {
            newKeyValue = new KeyValue<K, V>(key, value, false, -1);
            int temp = h_k;
            while(keys[temp][l].getNextPointer() != -1) {
               temp = keys[temp][l].getNextPointer();
            }
            keys[temp][l].setNextPointer(i);
         }
         else {
            newKeyValue = new KeyValue<K, V>(key, value, false, -1);
         }
         keys[i][l] = newKeyValue;
         n++;
         stackTrace.removeElement(i);
         
      } catch (ArrayIndexOutOfBoundsException e) {
         System.err.println("Error" + e + " " + key);
         elementsNotAddedCounter++;
         return -1;
      }
      
      return 1;
   }

   
   public void printPretty(int cellSize, int rows, int columns) {
      try {
         int indexSize = 10;
         int tableWidth = indexSize + 1 + columns + columns*cellSize;
         String rowDivider = "-".repeat(tableWidth);
         System.out.println("Here is your table:");
         String headerIndex = "Index";
         String headerColumn = "Value:Next";
         System.out.println(rowDivider);
         System.out.printf("|%" + (indexSize-1)+"s", headerIndex);
         for (int i = 0; i < columns; ++i) {
            System.out.printf("|%" + (cellSize)+"s", headerColumn);
         }
         System.out.println("|");
         
         for (int i = 0; i < rows*columns; i = i + columns) {
            System.out.println(rowDivider);
            if (columns > 1)
               System.out.printf("|%3s - %-3s", i, i+columns-1);
            else {
               System.out.printf("|%" + (indexSize-1)+"s", i);
            }
               
            for (int j = i, k = 0; (j < i+columns && k < numBuckets); ++j) {
               if (keys[j][k] == null || keys[j][k].getKey() == null) {
                  System.out.printf("|%" + cellSize+"s", "");
               }
               else {
                  System.out.printf("|%" + cellSize+"s", keys[j][k].getKey() + 
                        " : " + keys[j][k].getNextPointer());
               }
               if (j == (i+columns - 1))
                  System.out.println("|");
            }
         }
         System.out.println(rowDivider);
      } catch (ArrayIndexOutOfBoundsException e) {
         System.err.println("\nError" + e);
      }
   }

}
