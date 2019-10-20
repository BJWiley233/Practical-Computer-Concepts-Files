import java.util.Stack;

public class HashTableProbing<K extends Comparable<K>, V extends Comparable<V>> {
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_MODULO = 120;
   private static int DEFAULT_BUCKETS = 1;
   private static int DEFAULT_TRAVERSALS = 20;
   private static int DEFAULT_C1 = 1;
   private static int DEFAULT_C2 = 0;
   
   private int n = 0; // the n
   private int m; // the m
   private int modulo;
   private int numBuckets;  // not going to use
   private int collisions = 0;
   private int numTraversals;
   private double c1;
   private double c2;
   private int tableRows;
   
   private int duplicatesCounter = 0;
   private int elementsNotAddedCounter = 0;
   private Stack<Integer> stackTrace;
   private boolean divisionHashing;
   private KeyValue<K, V>[][] keys;
   
   public HashTableProbing() {
      this(DEFAULT_SIZE, DEFAULT_MODULO, DEFAULT_BUCKETS, 
             DEFAULT_C1, DEFAULT_C2, true, DEFAULT_TRAVERSALS);
   }
   
   public HashTableProbing(int modulo, int buckets,
         double c1, double c2, boolean divisionHashing) {
      this(DEFAULT_SIZE, modulo, buckets, c1, c2, true, DEFAULT_TRAVERSALS);
   }
   
   public HashTableProbing(int size, int modulo, int buckets,
         double c1, double c2, boolean divisionHashing) {
      this(size, modulo, buckets, c1, c2, true, DEFAULT_TRAVERSALS);
   }
   
   @SuppressWarnings("unchecked")
   public HashTableProbing(int size, int modulo, int buckets,
         double c1, double c2, boolean divisionHashing, int traversals) {
      n = 0;
      m = size;
      this.modulo = modulo;
      this.numBuckets = buckets;
      this.divisionHashing = divisionHashing;
      this.c1 = c1;
      this.c2 = c2;
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
      return (int) (((int) key + c1*index + c2*Math.pow(index, 2)) % modulo);
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
   
   @SuppressWarnings("unchecked")
   public int insert(K key, V value) {
      int i = -1;
      int traversals = 0;  // for traversals
      int l = 0;  // for buckets
      int index = 1;
      int h_k = 0;
      if (divisionHashing)
         h_k = probe(key, 0);
      else {
      }
      // Set i to initial hash
      i = h_k;
      
      try {
         /*
          * Traverse until we are out of buckets for all slots in the table.
          * We continue to traverse if there is a holder in the slot that is not
          * null and the setDeleted flag is not checked.
          */
         while (keys[i][l] != null && !(keys[i][l].wasDeleted())) {
            //check if duplicate, method updates count, exit insert method
            if (checkDup(key, value, keys[i][l]))
               return -1;
            // check remaining buckets
            for (l = 1; l < numBuckets; ++l) {
               if (checkDup(key, value, keys[i][l]))
                  return -1;
               if (keys[i][l] == null || keys[i][l].wasDeleted()) {
                  KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
                  keys[i][l] = newKeyValue;
                  n++;
                  stackTrace.removeElement(i);
                  return 1;
               }
            }
            l = 0;
            collisions++;
            i = probe((K)(Integer)h_k, index);
            index++;
         }

         KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
         keys[i][l] = newKeyValue;
         n++;
         stackTrace.removeElement(i);
      }
      catch (ArrayIndexOutOfBoundsException e) {
         System.err.println("Error" + e + " " + key);
         elementsNotAddedCounter++;
         return -1;
      }
      return 1;
   }
   
   /**
    * Didn't need to do this for the project but wanted to learn it anyway
    * @param key
    * @return
    */
   @SuppressWarnings("unchecked")
   public int delete(K key) {
      int i = -1;
      int l = 0;  // for buckets
      int index = 1;
      int h_k = 0;
      if (divisionHashing)
         h_k = probe(key, 0);
      else {
      }
      i = h_k;
      
      // check if slot to which key originally hashes is null, if so doesn't exist
      if (keys[i][l] == null) {
         System.out.println("KeyError: " + key + " doesn't exist");
         return -1;
      }
      
      /* traverse to find the key, if you hit a null key doesn't exists
       * we don't need to check for wasDeleted() because if marked as deleted
       * this is placeholder and implies not null   
       */
      while (keys[i][l] != null) {
         
         if (key.equals(keys[i][l].getKey())) {
            System.out.println("Found. Deleting " + key);
            keys[i][l].deleteKey();
            keys[i][l].setDeleted();
            n--;
            return 1;
         }
         i = probe((K)(Integer)h_k, index);
      }
      
      System.out.println("KeyError: " + key + " doesn't exist");
      return -1;

   }
   

   public void printPretty(int cellSize, int rows, int columns) {
      int indexSize = 10;
      int tableWidth = indexSize + 1 + columns + columns*cellSize;
      String rowDivider = "-".repeat(tableWidth);
      System.out.println("Here is your table:");
      for (int i = 0; i < rows*columns; i = i + columns) {
         System.out.println(rowDivider);
         System.out.printf("|%3s - %-3s", i, i+columns-1);
         for (int j = i, k = 0; (j < i+columns && k < numBuckets); ++j) {
            if (keys[j][k] == null) {
               System.out.printf("|%" + cellSize+"s", "");
            }
            else if (keys[j][k].wasDeleted()) {
               System.err.printf("|%" + cellSize+"s", "deleted");
            }
            else {
               System.out.printf("|%" + cellSize+"s", keys[j][k].getKey());
            }
            if (j == (i+columns - 1))
               System.out.println("|");
         }
      }
      System.out.println(rowDivider);
      
   }
   
   public void printPretty3Buckets(int cellSize) {
      int indexSize = 4;
      int tableWidth = indexSize + 1 + numBuckets + numBuckets*cellSize;
      String rowDivider = "-".repeat(tableWidth);
      System.out.println("Here is your table:");
      for (int i = 0; i < tableRows; ++i) {
         System.out.println(rowDivider);
         
         System.out.printf("|%3s", i);
         for (int j = 0; j < numBuckets ; ++j) {
            if (keys[i][j] == null) {
               System.out.printf("|%" + cellSize+"s", "");
            }
            else if (keys[i][j].wasDeleted()) {
               System.err.printf("|%" + cellSize+"s", "deleted");
            }
            else {
               System.out.printf("|%" + cellSize+"s", keys[i][j].getKey());
            }
            if (j == (numBuckets - 1))
               System.out.println("|");
         }
      }
      System.out.println(rowDivider);
      
   }

   
}
