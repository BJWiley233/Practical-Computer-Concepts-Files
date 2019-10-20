import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;


public class HashTableChaining2<E extends Comparable<E>> implements 
   Iterable<LinkedList<Key<E>>> {
   
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_BUCKETS = 1;
   private static int DEFAULT_MODULO = 120;
   private static String DEFAULT_SCHEME = "Chaining";
   
   private int n = 0; // the n
   private int m; // the m
   private int numBuckets;
   private int modulo;
   private String scheme;
   @SuppressWarnings("unchecked") 
   private List<LinkedList<Key<E>>> keys;

   
   public HashTableChaining2() {
         this(DEFAULT_SIZE, DEFAULT_BUCKETS, DEFAULT_MODULO, DEFAULT_SCHEME);
   }
   
   @SuppressWarnings("unchecked")
   public HashTableChaining2(int size, int buckets, int modulo, String scheme) {
      n = 0;
      m = size;
      this.numBuckets = buckets;
      this.modulo = modulo;
      this.scheme = scheme;
      keys = new ArrayList<LinkedList<Key<E>>>();
      for (int i = 0; i < m; ++i) {
            keys.add(new LinkedList<Key<E>>());
      }

      
   }
   
   public int size() {
      return n;
   }
   
   public int bucketSize() {
      return numBuckets;
   }
   
   public int numSlots() {
      return m;
   }
   
   public LinkedList<Key<E>> get(int slotIndex) {
      return keys.get(slotIndex);
   }
   
   @SuppressWarnings("unchecked")
   public Iterator<LinkedList<Key<E>>> iterator() {
      return (Iterator<LinkedList<Key<E>>>) new HashTableIterator();
   }
   
   private class HashTableIterator implements Iterator<LinkedList<Key<E>>> {
      int currentSlot;
      
      public HashTableIterator(){
         currentSlot = -1;
      }
      
      @Override
      public boolean hasNext() {
         if ((currentSlot + 1) >= m)
            return false;
         return true;
      }

      @Override
      public LinkedList<Key<E>> next() {
         currentSlot = currentSlot + 1;
         return keys.get(currentSlot); 
      }
   }
   
   public int hash(E keyValue) {
      //TODO
      return (int) keyValue % modulo;
   }
   
   public void insert(E keyValue) {
      Key<E> newKey = new Key<E>(keyValue, null);
      int i;
      if(keyValue instanceof String) {
         i = keyValue.hashCode() % m;  
      }
      else {
         i = hash(newKey.value);
      }

      keys.get(i).add(0, newKey);
      ++n;
 
   }
   
   public E search(E searchValue) {
      E retVal = null;
      int i;
      if(searchValue instanceof String) {
         i = searchValue.hashCode() % m;  
      }
      else {
         i = hash(searchValue);
      }
      for (int j = 0; j < keys.get(i).size(); ++ j) {
         if (keys.get(i).get(j).getValue().equals(searchValue)) {
            retVal = keys.get(i).get(j).getValue();
         }
      }
      return retVal;
   }
   

   

   public boolean delete(E keyToDelete) {
      //TODO
      return false;
   }
   
   private static class Key<E extends Comparable> implements Comparable {
      private E value;
      private String deleted = null;
      
      public Key(E value, String deleted) {
         this.value = value;
         this.deleted = deleted;
         
      }
      
      @SuppressWarnings("unused")
      public void setValue(E value) {
         this.value = value;
      }
      
      public E getValue() {
         return this.value;
      }
      
      public void setDeleted(String s) {
         this.deleted = s;
      }
      
      public boolean wasDeleted() {
         if (deleted.compareTo("Deleted") == 0)
            return true;
         
         return false;
      }

      @Override
      public int compareTo(Object o) {
         // TODO Auto-generated method stub
         return 0;
      }
      
   }

}
