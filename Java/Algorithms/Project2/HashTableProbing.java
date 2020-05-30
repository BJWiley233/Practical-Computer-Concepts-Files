/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

/**
 * Main class for create a hash table for the probing schemes.  Defaults
 * are listed at top of class.  Contains insert method and delete method but 
 * delete was only tested for 1 bucket and never called so it doesn't affect
 * user grading tables.  Has methods to return statistics of collisions, 
 * duplicates, elements not added, etc.  Also include two printing method to
 * beautify the printing output for 1 bucket {@link #printPretty(int, int, int)} 
 * and 3 bucket {@link #printPretty3Buckets(int)} hashing respectively. Also
 * includes method {@link #flattenSort(String, String, boolean, int)} to return 
 * a flattened list that is sorted by key, value or counts and max items to return.
 * Lastly includes a method to check if entry is a duplicate to increase the
 * counter which was class I used for the value for the keys for the project.
 * @author bjwil
 *
 * @param <K> generic for any key type.  I used Integers and Strings for Kmers
 * @param <V> generic for any value type. I used a Counter class
 * @see {@link Counter}
 */
public class HashTableProbing<K extends Comparable<K>, V extends Comparable<V>> {
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_MODULO = 120;
   private static int DEFAULT_BUCKETS = 1;
   private static int DEFAULT_TRAVERSALS = 400;
   private static int DEFAULT_C1 = 1;
   private static int DEFAULT_C2 = 0;
   private static boolean DEFAULT_DIVISION = true;
   
   private int n = 0; // the n
   private int m; // the m
   private int modulo;
   private int numBuckets;  // not going to use
   private int collisions = 0;
   /**
    * Coefficient to be passed to be used for linear and quadratic probing for
    * the linear component
    */
   private double c1;
   /**
    * Coefficient to be passed to be used for linear and quadratic probing for
    * the quadratic component
    */
   private double c2;
   private int tableRows;
   private int traversals;
   double A = 0.61803398875;  // Suggested by Knuth
   
   private int duplicatesCounter = 0;
   private int elementsNotAddedCounter = 0;
   private Stack<Integer> stackTrace;
   private boolean divisionHashing;
   private KeyValue<K, V>[][] keys;
   public List<K> keysNotAdded = new ArrayList<K>();
   
   // Default constructor
   public HashTableProbing() {
      this(DEFAULT_SIZE, DEFAULT_MODULO, DEFAULT_BUCKETS, 
             DEFAULT_C1, DEFAULT_C2, DEFAULT_DIVISION, DEFAULT_TRAVERSALS);
   }
   
   // Constructor if you just wanted to enter modulo, buckets, and probing constants
   public HashTableProbing(int modulo, int buckets,
         double c1, double c2) {
      this(DEFAULT_SIZE, modulo, buckets, c1, c2, DEFAULT_DIVISION, DEFAULT_TRAVERSALS);
   }
   
   // Constructor used to create the 8 schemes for probing
   public HashTableProbing(int size, int modulo, int buckets,
         double c1, double c2, boolean divisionHashing) {
      this(size, modulo, buckets, c1, c2, divisionHashing, DEFAULT_TRAVERSALS);
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
      this.traversals = traversals;
      keys = (KeyValue<K, V>[][]) new KeyValue[this.tableRows][buckets];

      /* 
       * this Stack will keep track of available positions but we don't use it
       * like we do in Coalesced hashing, rather we pop any values in which
       * probing gives us an available spot.  Initialize it with indexes.
       * There will be 3 of every index 0-39 for 3 buckets
       */
      stackTrace = new Stack<Integer>();
      for (int i = 0; i < tableRows; ++i) {
         for (int j = 0; j < numBuckets; ++j)
            stackTrace.push(i);
      }
   }
   
   /**
    * Returns the number of elements hashed into the table
    * @return <b>n</b> number of elements in table
    */
   public int numElements() {
      return n;
   }
   
   /**
    * Returns the table size that was allocated to the hash table
    * @return <b>m</b> table size
    */
   public int size() {
      return m;
   }
   
   /**
    * Returns the number of duplicates that were valid entries in the table
    * @return <b>duplicatesCounter</b> number of duplicates
    */
   public int duplicates() {
      return duplicatesCounter;
   }
   
   /**
    * Returns the number of free spaces left in the table
    * @return <b>stackTrace</b> number of free spaces
    */
   public int stackSize() {
      return stackTrace.size();
   }
   
   /**
    * Returns which indices are free in the table, maybe be more than
    * one of same index for multiple bucket hashing
    */
   public void getFreeSpaces() {
      for (int i : stackTrace) 
         System.out.print(i + " ");
      System.out.println();
   }
   
   /**
    * Returns the number of collisions.  Counts primary and secondary collisions
    * @return <b>collisions</b> number of collisions
    */
   public int numCollisions() {
      return collisions;
   }
   
   /**
    * Returns the number of elements not added to the hash table, either because
    * of max traversals, probe returns to the original hash value, the table is
    * full, or the hash value is outside the bounds of table, i.e. 
    * ArrayIndexOutOfBoundsException
    * @return <b>elementsNotAddedCounter</b> number of elements
    */
   public int numElementsNotAdded() {
      return elementsNotAddedCounter;
   }
   
   /**
    * Will return the keys that were not added to the table
    * @return <b>keysNotAdded</b> ArrayList containing keys not added
    * @see #numElementsNotAdded
    */
   public List<K> getElemsNotAdded() {
      return keysNotAdded;
   }
   
   /**
    * Returns a copy of the hash table
    * @return <b>keys</b> Array containing the Key, Value entries in the
    * hash table 
    */
   public KeyValue<K, V>[][] getHashTable() {
      return keys;
   }
   
   /**
    * Main hash function that gets called by {@link #probe(Comparable, int)}.
    * Takes the key and index from the probe method which is called from
    * the main {@link #insert(Comparable, Comparable)} method.  Uses {@link #c1}
    * and {@link #c2} values that were passed to construct the schemes in the 
    * hash table instantiation
    * @param key the key from the key, value pair to hash
    * @param index an index to pass to hash function for linear and 
    * quadratic probing
    * @return an integer result from the hash function
    */
   public int hash(K key, int index) {
      return (int) (((Integer)key + c1*index + c2*Math.pow(index, 2)) % modulo);
   }
   
   /**
    * Uses multiplication method with the value A = 0.61803398875 from Knuth and
    * then uses modulo on table size to make cyclic to prevent out of table bounds
    * indices
    * @param key the key from the key, value pair to hash
    * @param index index to pass to hash function for linear and 
    * quadratic probing
    * @return an integer result from the hash function
    */
   public int ownHashScheme(K key, int index) {
      return  (int)(m * ((Integer)key*A - Math.floor((Integer)key*A)) + c1*index +
            c2*Math.pow(index, 2)) % m;
   }
   
   /**
    * The probe method is called from insert as a mediator for two things. 1)
    * so that we can check whether we should use division hashing or our own
    * multiplicative hashing scheme and 2) if it not an instance of an Integer
    * then to obtain the {@link Object#hashCode()} as an Integer representation
    * before passing to either division or multiplicative hashing. 
    * @param key the key from the key, value pair to hash
    * @param index index to pass to hash function for linear and 
    * quadratic probing
    * @return <b>i</b> the index returned from the hash function
    */
   @SuppressWarnings("unchecked")
   public int probe(K key, int index) {
      int i;
      if (divisionHashing) {
         if(!(key instanceof Integer)) {
            i = hash((K)(Integer)(key.hashCode() & 0x7fffffff), index); 
         }
         else {
            i = hash(key, index);
         }
      }
      else {
         if(!(key instanceof Integer)) {
            i = ownHashScheme((K)(Integer)(key.hashCode() & 0x7fffffff), index); 
         }
         else {
            
            i = ownHashScheme(key, index);
         }
      }
      
       return i;
   }
   
   
   /**
    * Checks if key is a duplicate during the insertion method, but only if
    * there is a collision in the space because if not, then it cannot be a 
    * duplicate.  If it returns true to the insert method then insert will break.
    * If is a duplicate will either increase the counter if the value is an
    * instance of the {@link Counter} class or will overwrite the value if not
    * a Counter class
    * @param key the key being inserted
    * @param value the value being inserted
    * @param kv the key which exists 
    * @return <b>true</b> if duplicate else <b>false</b>
    */
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
   
   /**
    * Main insert method.  Obtains obtains hash value to be inserted at in the 
    * hash table.  If there is a collision it will probe until it finds a spot
    * or reaches an end point from either max traversals, probe returns to the 
    * original hash value, the table is full, or the hash value is outside 
    * the bounds of table.  Will check for duplicates along the way as well
    * as add the item to {@link #keysNotAdded} list
    * @param key
    * @param value the value being inserted
    * @return positive 1 if entry is add else negative 1 if entry is not added
    * @see #numElementsNotAdded()
    */
   @SuppressWarnings("unchecked")
   public int insert(K key, V value) {
      if (n >= m) {
         System.err.println("Hash table overflow");
         keysNotAdded.add(key);
         elementsNotAddedCounter++;
         return -1;
      }
      
      int i = -1; // will use for indexing the table
      int l = 0;  // for buckets, could have use b :)
      int index = 1; // will use for traversing
      int h_k = 0; // will use for saving initial hash value

      // get initial hash h(k)
      h_k = probe(key, 0);
      
      // Set i to initial hash for cleaner array indexing and to maintain
      // original hash value
      i = h_k;
      
      try {
         /*
          * Traverse until we are out of buckets for all slots in the table.
          * We continue to traverse if there is a holder in the slot that is not
          * null and the setDeleted flag is not checked.  Stops at max
          * traversals.  If slot was set as deleted we can use it!
          */
         while (keys[i][l] != null && !(keys[i][l].wasDeleted())
               && index < traversals) {
            
            /*
             * check if duplicate in first bucket, method updates count, 
             * exit insert method
             */
            if (checkDup(key, value, keys[i][l])) {
               return -1;
            }
            
            collisions++;  // increase collision count
            
            /*
             * If the modulus-1 < number of elements < total table slots, i.e.
             * for mod 113 fill in remaining 7 spots.  This is for additional input
             * with greater than 113 entries.
             * 
             */
            if (n >= modulo*numBuckets) {
               i = stackTrace.pop();
               KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
               keys[i][l] = newKeyValue;
               n++;
               return 1;
            }
            
            // check remaining buckets, never entered for 1 bucket schemes
            for (l = 1; l < numBuckets; ++l) {
               //check if duplicate in other buckets also
               if (checkDup(key, value, keys[i][l])) {
                  return -1;
               }
               // if any bucket is open add it!
               if (keys[i][l] == null || keys[i][l].wasDeleted()) {
                  KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
                  keys[i][l] = newKeyValue;
                  n++;
                  stackTrace.removeElement(i);
                  return 1;
               }
            }
            l = 0;  // reset bucket index back to 0
            
            i = probe((K)(Integer)h_k, index);
            
            // stop if you reach original hash because this will just start over with probing
            if(i == h_k) {
               elementsNotAddedCounter++;
               keysNotAdded.add(key);
               System.err.println("Reached original hash value for: " + key + ". Not added.");
               return -1;
            }
            index++;
         }
         
         // don't continue to pass original traversal, key won't be stored
         if (index == DEFAULT_TRAVERSALS) {
            elementsNotAddedCounter++;
            keysNotAdded.add(key);
            System.err.println("Max traversals for key: " + key + ". Not added.");
            return -1;
         }
         
         // Add new key, value pair
         KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
         keys[i][l] = newKeyValue;
         n++;
         stackTrace.removeElement(i);
      }
      catch (ArrayIndexOutOfBoundsException e) {
         System.out.println("Error" + e + " " + key);
         elementsNotAddedCounter++;
         keysNotAdded.add(key);
         return -1;
      }
      return 1;
   }
   
   /**
    * Didn't need to do this for the project but wanted to learn it anyway, this 
    * would only search first bucket to delete.
    * @param key
    * @return positive 1 if entry is deleted else negative 1 not deleted
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
         System.err.println("Haven't implemented delete for own hashing scheme");
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
   
   /**
    * Print method to print rows of 5 for the schemes with 1 bucket, which
    * is every scheme except 7 and 8
    * @param cellSize width of cell which contains the keys
    * @param rows number of rows to print, 24 for the project
    * @param columns number of columns to print, 5 for the project
    */
   public void printPretty(int cellSize, int rows, int columns) {
      int indexSize = 10;
      int tableWidth = indexSize + 1 + columns + columns*cellSize;
      String rowDivider = "-".repeat(tableWidth);
      System.out.println("Here is your table:");
      String headerIndex = "Index";
      String headerColumn = "Key";
      System.out.println(rowDivider);
      System.out.printf("|%" + (indexSize-1)+"s", headerIndex);
      
      for (int i = 0; i < columns; ++i) {
         System.out.printf("|%" + (cellSize)+"s", headerColumn);
      }
      System.out.println("|");
      
      for (int i = 0; i < rows*columns; i = i + columns) {
         System.out.println(rowDivider);
         System.out.printf("|%3s - %-3s", i, i+columns-1);
         for (int j = i; j < i+columns; ++j) {
            if (keys[j][0] == null) {
               System.out.printf("|%" + cellSize+"s", "");
            }
            else if (keys[j][0].wasDeleted()) {
               System.err.printf("|%" + cellSize+"s", "deleted");
            }
            else {
               System.out.printf("|%" + cellSize+"s", keys[j][0].getKey());
            }
            if (j == (i+columns - 1))
               System.out.println("|");
         }
      }
      System.out.println(rowDivider);
   }
   
   /**
    * Print method to print rows of 3 for the schemes with 3 buckets, schemes 7 
    * and 8
    * @param cellSize width of cell which contains the keys
    */
   public void printPretty3Buckets(int cellSize) {
      int indexSize = 6;
      int tableWidth = indexSize + 1 + numBuckets + numBuckets*cellSize;
      String rowDivider = "-".repeat(tableWidth);
      System.out.println("Here is your table:");
      String headerIndex = "Index";
      String headerColumn = "Key";
      System.out.println(rowDivider);
      System.out.printf("|%" + (indexSize)+"s", headerIndex);
      
      for (int i = 0; i < numBuckets; ++i) {
         System.out.printf("|%" + (cellSize)+"s", headerColumn);
      }
      System.out.println("|");
      
      for (int i = 0; i < tableRows; ++i) {
         System.out.println(rowDivider);
         
         System.out.printf("|%" +indexSize+"s", i);
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
   
   /**
    * Put hash table into a flat list to be sorted by K,V comparators either 
    * descending or ascending.  Only tested for Fasta hash table in the 
    * additional testing.
    * @param by k/key or v/value
    * @param dir direction either "desc"/"d" for descending or will sort ascending
    * @param counts boolean to sort by count if true
    * @param amount return 
    * @return
    */
   public List<KeyValue<K, V>> flattenSort(String by, String dir, boolean counts, int amount) {
      // Put into a list that can be sorted
      List<KeyValue<K, V>> sortByList = new ArrayList<KeyValue<K, V>>(n);
      for (int i = 0; i < m; ++i) {
         for (int j = 0; j < numBuckets; ++j) {
            if (keys[i][j] != null) {
               sortByList.add(keys[i][j]);  
            }
         }
      }
      by = by.toUpperCase();
      dir = dir.toUpperCase();
      
      if (by.compareTo("KEY") == 0 || by.compareTo("K") == 0) {
         if (dir.compareTo("DESC") == 0 || dir.compareTo("D") == 0) {
            sortByList.sort(KeyValue.sortKeyDesc);
         }
         else {
            sortByList.sort(KeyValue.sortKeyAsc);
         }
      
      // check if counts is true sort by counts
      }
      else if (by.compareTo("VALUE") == 0 || by.compareTo("V") == 0) {
         if (counts) {
            if (dir.compareTo("DESC") == 0 || dir.compareTo("D") == 0) {
               sortByList.sort(KeyValue.sortCountDesc);
            }
            else {
               sortByList.sort(KeyValue.sortCountAsc);
            }
         }
         // else sort by value descending or ascending
         else {
            if (dir.compareTo("DESC") == 0 || dir.compareTo("D") == 0) {
               sortByList.sort(KeyValue.sortValueDesc);
            }
            else {
               //TODO Create Ascending Value Comparator
            }
         }
      }
      
      if (amount >= sortByList.size())
         amount = sortByList.size() - 1;
      
      return sortByList.subList(0, amount);
   }

   
}



