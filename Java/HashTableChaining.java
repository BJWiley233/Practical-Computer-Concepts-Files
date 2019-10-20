
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Stack;



public class HashTableChaining<K extends Comparable<K>, V extends Comparable<V>> {
   
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_MODULO = 120;
   private static int DEFAULT_BUCKETS = 1;  // Just setting to 1 will not change for chaining
   
   
   private int n = 0; // the n
   private int m; // the m
   private int modulo;
   private int numBuckets;  // not going to use
   int collisions = 0;
   /*
    * Not going to make a 2 dimensional array for number of buckets for
    * the chaining schemes because the buckets are all 1.  This would be 
    * pointless and need for iterating the second dimension of the array
    * which is just 1.
    */
   private LinkedList<KeyValue<K, V>>[] keys;
   private int duplicatesCounter = 0;
   private Stack<Integer> stackTrace;
   private boolean divisionHashing;
   
   public HashTableChaining() {
         this(DEFAULT_SIZE, DEFAULT_MODULO, DEFAULT_BUCKETS, true);
   }
   
   public HashTableChaining(int modulo, boolean divisionHashing) {
      this(DEFAULT_SIZE, modulo, DEFAULT_BUCKETS, divisionHashing);
   }
   
   @SuppressWarnings("unchecked")
   public HashTableChaining(int size, int modulo, int buckets, boolean divisionHashing) {
      n = 0;
      m = size;
      this.modulo = modulo;
      this.numBuckets = buckets;
      this.divisionHashing = divisionHashing;
      keys = new LinkedList[size];
      stackTrace = new Stack<Integer>();
      for (int i = 0; i < m; ++i) {
         stackTrace.push(null);
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
   public int numCollisions() {
      return collisions;
   }
   
   public int hash(K key) {
      return (int) key % modulo;
   }
   
   public int probe(K key) {
      int i;
      if(!(key instanceof Integer)) {
         i = (key.hashCode() & 0x7fffffff) % m; 
      }
      else {
         i = hash(key);
      }
      return i;
   }
   
   public int ownHashScheme() {
      return -1;
   }
   
   @SuppressWarnings("unchecked")
   public void insert(K key, V value) {
      int i = -1;
      if (divisionHashing)
         i = probe(key);
      else {
         
      }
      boolean duplicate = false;
      if (keys[i] == null) {
         keys[i] = new LinkedList<KeyValue<K, V>>();
         stackTrace.pop();
         KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
         keys[i].add(0, newKeyValue);
         ++n;
      }
      else {
         ++collisions;
         for (int j = 0; j < keys[i].size(); ++j) {
            if (keys[i].get(j).getKey().equals(key)) {
               duplicate = true;
               System.out.print("Key " + key + " matches existing key " + 
                     keys[i].get(j).getKey() + ". ");
               if (keys[i].get(j).getValue() instanceof Counter) {
                  System.out.println("Increasing Value Count.");
                  Counter newCount = (Counter) keys[i].get(j).getValue();
                  newCount.increment();
                  keys[i].get(j).setValue((V) newCount); 
               }
               else {
                  System.out.println("Overwriting value.");
                  keys[i].get(j).setValue(value);
               }
               duplicatesCounter++;
               return;
            }
         }
         // add to front of list if not duplicate but collision
         if (!duplicate) {
            KeyValue<K, V> newKeyValue = new KeyValue<K, V>(key, value, false);
            keys[i].add(0, newKeyValue);
            ++n;
         }
      }
   }
       
   public boolean containsKey(K key) {
      int i = -1;
      if (divisionHashing)
         i = probe(key);
      else {
         
      }
      for (int j = 0; j < keys[i].size(); ++j) {
         if (keys[i].get(j).getKey().compareTo(key) == 0) {
            return true;
         }   
      }
      
      return false;
   }


   public KeyValue<K, V> search(K key) {
      KeyValue<K, V> retVal = null;
      String notFound = "Key " + key + " was not found.";
      int i = -1;
      if (divisionHashing)
         i = probe(key);
      else {
         
      }
      if (keys[i] == null); // do nothing return value is still null
      else {
         for (int j = 0; j < keys[i].size(); ++ j) {
            if (keys[i].get(j).getKey().equals(key)) {
               retVal = keys[i].get(j);
            }
         }
      }
      if (retVal == null) {
         System.out.println(notFound);
      }
      else {
         System.out.println("Found Key " + retVal.getKey() + " in slot " + i);
      }
      
      return retVal;
   }
   
   public LinkedList<KeyValue<K, V>> getSlot(int slotIndex) {
      return keys[slotIndex];
   }
   
   public void iterateFilledSlots(int slotStart) {
      for (int i = slotStart; i < m; ++i) {
         if (keys[i] != null) {
            if (keys[i].size() >= 1) {
               System.out.println("Slot " + i + ":");
               for (KeyValue<K, V> kv: keys[i]) {
                  if (kv.getValue() instanceof Counter) {
                     System.out.println("  Key "+ kv.getKey() +
                           ", Value " + ((Counter) kv.getValue()).getCount());
                  }
                  else {
                     System.out.println("  Key "+ kv.getKey() +
                           ", Value " + kv.getValue());
                  }
               }
            }
         }
      }
   }
   
   @SuppressWarnings("unchecked")
   public <E> E[][] helperArray() {
      int maxChain = 0;
      for (int i = 0; i < m; ++i) {
         if (keys[i] != null) {
            if (keys[i].size() > maxChain)
               maxChain = keys[i].size();
         }
      }

      E[][] data = (E[][]) new Object [m][maxChain];
      for (int i = 0; i < m; ++i) {
         if (keys[i] == null) {
            for (int j = 0; j < maxChain; ++j)
            data[i][0] = null;
         }
         else {
            for (int j = 0; j < keys[i].size(); ++j) {
               data[i][j] = (E) keys[i].get(j).getKey();
            }
            for (int k = keys[i].size(); k < maxChain; ++k) {
               data[i][k] = null;
            }
         }
      }
      return data;
   }
   
   @SuppressWarnings("unchecked")
   public <E> void writeToCSV(String file, E[][] data) throws IOException {
      
      try {
         BufferedWriter br = new BufferedWriter(new FileWriter(file));
         StringBuilder sb = new StringBuilder();
         for (int i = 0; i < m; ++i) {
            for (int j = 0; j < data[0].length; ++j) {
               if (data[i][j] == null) {
                  sb.append(",");
               }
               else {
                  sb.append(data[i][j] + ",");
               }
            }
            sb.append("\n");
         }
         br.write(sb.toString());
         br.close();
      }
      catch (IOException e) {
         System.err.println("Error" + e);
      }
   }
   
   /*
    * 
    */
   
   public <E> void printPretty(E[][] data, int cellSize) {
      int rows = data.length;
      int columns = data[0].length + 1;
      int indexSize = 4;
      int tableWidth = indexSize + columns + (columns-1) * cellSize;
      String rowDivider = "-".repeat(tableWidth);
      System.out.println("Here is your table:");
      for (int i = 0; i < rows; ++i) {
         System.out.println(rowDivider);
         System.out.printf("|%" + indexSize+"s", i);
         for (int j = 0; j < (columns - 1); ++j) {
            if (data[i][j] == null) {
               System.out.printf("|%" + cellSize+"s", "");
            }
            else {
               System.out.printf("|%" + cellSize+"s", data[i][j]);
            }
            if (j == (columns - 2))
               System.out.println("|");
         }
      }
      System.out.println(rowDivider);
      
   }
   
   public List<KeyValue<K, V>> flattenSort(String by, String dir, boolean counts, int amount) {
      List<KeyValue<K, V>> sortByList = new ArrayList<KeyValue<K, V>>(n);
      for (int i = 0; i < m; ++i) {
         if (keys[i] != null) {
            for (int j = 0; j < keys[i].size(); ++j) {
               sortByList.add(keys[i].get(j));
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
         else {
            if (dir.compareTo("DESC") == 0 || dir.compareTo("D") == 0) {
             //TODO Create Descending Value Comparator
            }
            else {
               sortByList.sort(KeyValue.sortValue);
            }
            
         }
      }
      return sortByList.subList(0, amount);
      
   }
   
   /*
   private class KeyValue<K extends Comparable<K>, V extends Comparable<V>>
      implements Map.Entry<K, V>{
      
      private K key;
      private V value;
      private String deleted = null;
      private static KeyComparator sortKey = new KeyComparator();
      private static DescendingCountsComparator sortCountDesc = 
            new DescendingCountsComparator(); //count # of kmers
      
      public KeyValue(K key, V value, String deleted) {
         this.key = key;
         this.value = value;
         this.deleted = deleted;
         
      }
      
      private static class KeyComparator implements Comparator<KeyValue<K, V>> {
         public int compare(KeyValue<K, V> kv1, KeyValue<K, V> kv2) {
            return kv1.key.compareTo(kv2.key);
         } 
      }
      
      private static class DescendingCountsComparator implements Comparator<KeyValue<K, V>> {
         public int compare(KeyValue<K, V> kv1, KeyValue<K, V> kv2) {
            return kv2.value.compareTo(kv1.value);
         } 
      }

      @Override
      public K getKey() {
         return this.key;
      }

      @Override
      public V getValue() {
         // TODO Auto-generated method stub
         return this.value;
      }

      @Override
      public V setValue(V value) {
         this.value = value;
         return null;
      }  

      public void setDeleted(String s) {
         this.deleted = s;
      }
      
      public boolean wasDeleted() {
         if (deleted.compareTo("Deleted") == 0)
            return true;
         
         return false;
      }
   
     
   }
   */

   
   
   
  
}


