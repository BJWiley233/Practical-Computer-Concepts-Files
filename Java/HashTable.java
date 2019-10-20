import java.util.Iterator;
import java.util.LinkedList;
import java.util.ListIterator;

public class HashTable<Key extends Comparable<Key>, E> {
   
   private static int DEFAULT_SIZE = 120;
   private static int DEFAULT_BUCKETS = 1;
   private static int DEFAULT_MODULO = 120;
   private static String DEFAULT_SCHEME = "Chaining";
   
   private int n; // the n
   private int m; // the m
   private int numBuckets;
   private int modulo;
   private String scheme;
   //private Key[] keys;
   //private V[] values;  //TODO I THINK WE ADD THE VALUE IN THE PRIVATE KEY CLASS
   
   public HashTable() {
         this(DEFAULT_SIZE, DEFAULT_BUCKETS, DEFAULT_MODULO, DEFAULT_SCHEME);
   }
   
   @SuppressWarnings("unchecked")
   public HashTable(int size, int buckets, int modulo, String scheme) {
      n = 0;
      m = size;
      this.numBuckets = buckets;
      this.modulo = modulo;
      this.scheme = scheme;
      //keys = (Key[]) new Comparable[size];
      if (scheme.compareTo("Chaining") == 0);
         @SuppressWarnings("unchecked") 
         LinkedList<Key>[][] keys = new LinkedList[size][numBuckets];
         //keys = (LinkedList) new Comparable[size]; 
         for (int i = 0; i < m; ++i) {
            for (int j = 0; j < numBuckets; ++j)
               keys[i][j] = new LinkedList<Key>();
         }
            
      //values = (V[]) new Comparable[size]; //TODO I THINK WE ADD THE VALUE IN THE PRIVATE KEY CLASS
      
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
   
   public Iterator<Key> iterator() {
      return (Iterator<Key>) new HashTableIterator();
   }
   
   public int hash(Key key) {
      //TODO
      return (int) key.value % modulo;
   }
   
   public void insert(Key key) {
      int i = hash(key);
      
   }
   
   public E search(Key key) {
      //TODO
      int i = hash(key);
      return (E) key.value;
   }
   
   /*
   public V get(Key key) {
      //TODO
      int i = 0;
      return values[i];
   }
   */
   public boolean delete(Key key) {
      //TODO
      return false;
   }
   
   private static class Key<E extends Comparable> implements Comparable<Key<E>> {

      private E value;
      private String deleted = null;
      
      public Key(E value) {
         this.value = value;
      }
      
      public void setValue(E value) {
         this.value = value;
      }
      
      public E getValue() {
         return value;
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
      public int compareTo(Key<E> k) {
         
         return this.value.compareTo(k.value);
      }
      
   }
   
   private class HashTableIterator implements ListIterator<Key> {

      @Override
      public boolean hasNext() {
         // TODO Auto-generated method stub
         return false;
      }

      @Override
      public Key next() {
         // TODO Auto-generated method stub
         return null;
      }

      @Override
      public boolean hasPrevious() {
         // TODO Auto-generated method stub
         return false;
      }

      @Override
      public Key previous() {
         // TODO Auto-generated method stub
         return null;
      }

      @Override
      public int nextIndex() {
         // TODO Auto-generated method stub
         return 0;
      }

      @Override
      public int previousIndex() {
         // TODO Auto-generated method stub
         return 0;
      }

      @Override
      public void remove() {
         // TODO Auto-generated method stub
         
      }

      @Override
      public void set(Key e) {
         // TODO Auto-generated method stub
         
      }

      @Override
      public void add(Key e) {
         // TODO Auto-generated method stub
         
      }
      
   }
   
}
