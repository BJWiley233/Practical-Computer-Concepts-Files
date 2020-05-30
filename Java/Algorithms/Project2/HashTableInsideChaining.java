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
 * Main class to handle the chaining schemes 3, 6, & 11.  This is an implementation
 * of coalesced hashing which keeps a pointer to the next element if collision 
 * occurs at an index returned by the hash function.  It uses a stack to put the
 * entries at the first available index from the bottom of the table up if a collision
 * should occur.  Then will set the next pointer as an attribute for the last element
 * in the chain to the index where the collision has been stored.  Therefore
 * we do not use an index for the probing.
 * @author bjwil
 *
 * @param <K> generic for any key type.  I used Integers and Strings for Kmers
 * @param <V> generic for any value type. I used a Counter class
 * @see {@link Counter}
 */
public class HashTableInsideChaining<K extends Comparable<K>, V extends Comparable<V>> {
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_MODULO = 120;
   private static int DEFAULT_BUCKETS = 1;
   private static boolean DEFAULT_DIVISION = true;

   private int n = 0; // the n
   private int m; // the m
   private int modulo;
   private int numBuckets;  // not going to use
   private int collisions = 0;
   private int tableRows;
   double A = 0.61803398875;
   
   private int duplicatesCounter = 0;
   private int elementsNotAddedCounter = 0;
   private Stack<Integer> stackTrace;
   private boolean divisionHashing;
   private KeyValue<K, V>[][] keys;
   public List<K> keysNotAdded = new ArrayList<K>();
   
   // Default constructor
   public HashTableInsideChaining() {
      this(DEFAULT_SIZE, DEFAULT_MODULO, DEFAULT_BUCKETS, DEFAULT_DIVISION);
   }
   
   // Constructor if you just wanted to enter modulo and buckets
   public HashTableInsideChaining(int modulo, int buckets) {
      this(DEFAULT_SIZE, modulo, buckets, DEFAULT_DIVISION);
   }
   
   // Constructor to create the 3 schemes for chaining
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
      /* 
       * this Stack will keep track of available positions we pop from the top
       * of the stack which is really the bottom of the hash table upwards
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
    * Returns the number of elements not added to the hash table because the 
    * table is full or the hash value is outside the bounds of table, i.e. 
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
    * Main hash function to use division hashing
    * @param key the key from the key, value pair to hash
    * @return an integer result from the hash function
    */
   public int hash(K key) {
      return (Integer) key % modulo;
   }
   
   /**
    * Multiplicative hashing as own scheme.  Do not need to make cyclic as
    * our collision strategy for coalesced hashing pops open slots from the 
    * bottom of the table up, i.e. the cellar
    * @param key the key from the key, value pair to hash
    * @return an integer result from the hash function
    */
   public int ownHashScheme(K key) {
      return  (int) (m * ((Integer)key*A - Math.floor((Integer)key*A)));
   }
   
   /**
    * The probe method is called from insert as a mediator for two things. 1)
    * so that we can check whether we should use division hashing or our own
    * multiplicative hashing scheme and 2) if it not an instance of an Integer
    * then to obtain the {@link Object#hashCode()} as an Integer representation
    * before passing to either division or multiplicative hashing. 
    * @param key the key from the key, value pair to hash
    * @return <b>i</b> the index returned from the hash function
    */
   @SuppressWarnings("unchecked")
   public int probe(K key) {
      int i;
      if (divisionHashing) {
         if(!(key instanceof Integer)) {
            i = hash((K)(Integer)(key.hashCode() & 0x7fffffff)); 
         }
         else {
            i = hash(key);
         }
      }
      else {
         if(!(key instanceof Integer)) {
            i = ownHashScheme((K)(Integer)(key.hashCode() & 0x7fffffff)); 
         }
         else {
            
            i = ownHashScheme(key);
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
    * Only did insert for Coalesced chaining because delete can cause data
    * corruption unless we rehash.  Follows the format for coalesced hashing.
    * If no collision just add in respective hash location else pop from bottom 
    * of the table, the cellar for last free space.  We really just pop off top 
    * of our Stack.
    * @param key
    * @param value
    * @return
    */
   public int insert(K key, V value) {
      if (n >= m) {
         keysNotAdded.add(key);
         elementsNotAddedCounter++;
         System.err.println("Hash table overflow");
         return -1;
      }
      int i = -1;
      int l = 0;  // for buckets if we wished to do more buckets
      int h_k = 0;
      
      // get initial hash h(k)
      h_k = probe(key);
      
      // Set i to initial hash for cleaner array indexing and to maintain
      // original hash value
      i = h_k;

      try {
      // We check until a slot was free/null or was marketed as deleted. If it was 
      // entered and then deleted, the slot would be not null but we want to use
      // it if it was marked deleted so we use it and exit loop
         while (keys[i][l] != null && !(keys[i][l].wasDeleted())) {

            // check if original hash is duplicate
            if (checkDup(key, value, keys[i][l]))
               return -1;
            /*
             * else check if any previous collisions for duplicate starting from 
             * bottom of table up, {@see #containsKey} method if dup was found
             * then we exit the insert method.  The check dup method will take 
             * care of the duplicates counter
             */
            else {
               if(containsKey(key, value))
                  return -1;
            }
            
            // don't need to check other buckets, only 1 for chaining
            collisions++;
            // input in last open spot in table represented by the top of the stack
            // since the Last element in of the stack is bottom up for Coalesced Hashing
            i = stackTrace.pop();
         }
         
         /*
          * check if was collision and add next pointer to last element of chain 
          * by traversing the chaining list starting from original hash location
          */
         KeyValue<K, V> newKeyValue;
         if (i != h_k) {
            newKeyValue = new KeyValue<K, V>(key, value, false, -1);
            int temp = h_k;
            while(keys[temp][l].getNextPointer() != -1) {
               temp = keys[temp][l].getNextPointer();
            }
            keys[temp][l].setNextPointer(i);
         }
         // if not collision just add with a null -1 pointer
         else {
            newKeyValue = new KeyValue<K, V>(key, value, false, -1);
         }
         keys[i][l] = newKeyValue;
         n++;
         // remove from stack is not a collision to keep the trace
         stackTrace.removeElement(i);
         
      } catch (ArrayIndexOutOfBoundsException e) {
         System.err.println("Error" + e + " " + key);
         elementsNotAddedCounter++;
         keysNotAdded.add(key);
         return -1;
      }
      
      return 1;
   }

   /**
    * Cursor method to check if during insertion of a key there is a collision
    * then traverse the table from the bottom up where the collisions are stored
    * @param key
    * @param value
    * @return
    */
   public boolean containsKey(K key, V value) {
      int i = keys.length - 1;  // index
      int l = 0; // bucket index, only 1 bucket for chaining
      /*
       * cursor check dups from bottom if collision during insert
       */
      while(keys[i][l] != null && !key.equals(keys[i][l].getKey())) {
         i--;
         
      }
      /*
       * if there was a dup caught in cursor run the checkDup to update count
       * or overwrite value
       */
      if (checkDup(key, value, keys[i][l]))
         return true;
      else
         return false;   
   }
   
   /**
    * Print method to print rows of 5.  Only difference from probing schemes
    * is that this will also print the key's respective next pointer.
    * @param cellSize width of cell which contains the keys
    * @param rows number of rows to print, 24 for the project
    * @param columns number of columns to print, 5 for the project
    * @see {@link KeyValue#getNextPointer()}
    */
   public void printPretty(int cellSize, int rows, int columns) {
      try {
         int indexSize = 10;
         int tableWidth = indexSize + 1 + columns + columns*cellSize;
         String rowDivider = "-".repeat(tableWidth);
         System.out.println("Here is your table:");
         String headerIndex = "Index";
         String headerColumn = "Key:Next";
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
               // keep cell blank if no key is stored
               if (keys[j][k] == null || keys[j][k].getKey() == null) {
                  System.out.printf("|%" + cellSize+"s", "");
               }
               // else print key and next pointer
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
