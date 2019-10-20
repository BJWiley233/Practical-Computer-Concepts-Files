import java.util.Comparator;
import java.util.Map;


public class KeyValue<K extends Comparable<K>, V extends Comparable<V>> implements Map.Entry<K, V>{
   
   private static int DEFAULT_NEXT_POINTER = -1;
   private K key;
   private V value;
   private boolean deleted;
   private int nextPointer;
   public static DescKeyComparator sortKeyDesc = new DescKeyComparator();
   public static AscKeyComparator sortKeyAsc = new AscKeyComparator();
   public static DescendingCountsComparator sortCountDesc = 
         new DescendingCountsComparator(); //count # of kmers
   public static AscendingCountsComparator sortCountAsc = 
         new AscendingCountsComparator(); //count # of kmers
   public static ValueComparator sortValue = new ValueComparator();
   
   public KeyValue(K key, V value, boolean deleted) {
      this(key, value, deleted, DEFAULT_NEXT_POINTER);
   }
   public KeyValue(K key, V value, boolean deleted, int nextPointer) {
      this.key = key;
      this.value = value;
      this.deleted = deleted;
      this.nextPointer = nextPointer;
      
   }
   
   @Override
   public String toString() {
      return ("Key: " + key + ", Value: " + value);
   }
   
   
   @SuppressWarnings("rawtypes")
   private static class DescKeyComparator implements Comparator<KeyValue> {
      //@Override
      @SuppressWarnings("unchecked")
      public int compare(KeyValue kv1, KeyValue kv2) {
         // TODO Auto-generated method stub
         return kv2.key.compareTo(kv1.key);
      } 
   }
   
   @SuppressWarnings("rawtypes")
   private static class AscKeyComparator implements Comparator<KeyValue> {
      //@Override
      @SuppressWarnings("unchecked")
      public int compare(KeyValue kv1, KeyValue kv2) {
         // TODO Auto-generated method stub
         return kv1.key.compareTo(kv2.key);
      } 
   }
   
   @SuppressWarnings("rawtypes")
   private static class DescendingCountsComparator implements Comparator<KeyValue> {
      public int compare(KeyValue kv1, KeyValue kv2) {
         return ((Counter)kv2.value).getCount() - (((Counter)kv1.value).getCount());
      } 
   }
   
   @SuppressWarnings("rawtypes")
   private static class AscendingCountsComparator implements Comparator<KeyValue> {
      public int compare(KeyValue kv1, KeyValue kv2) {
         return ((Counter)kv1.value).getCount() - (((Counter)kv2.value).getCount());
      } 
   }
   
   
   @SuppressWarnings("rawtypes")
   private static class ValueComparator implements Comparator<KeyValue> {
      @SuppressWarnings("unchecked")
      public int compare(KeyValue kv1, KeyValue kv2) {
         return kv2.value.compareTo(kv1.value);
      } 
   }

   @Override
   public K getKey() {
      return this.key;
   }
   
   public void deleteKey() {
      this.key = null;
      this.value = null;
   }
   

   @Override
   public V getValue() {
      // TODO Auto-generated method stub
      return this.value;
   }

   @Override
   public V setValue(V value) {
      this.value = value;
      return this.value;
   }  

   public void setDeleted() {
      this.deleted = true;
   }
   
   public boolean wasDeleted() {
      if (deleted)
         return true;

      return false;
   }
   

   public int getNextPointer() {
      // TODO Auto-generated method stub
      return this.nextPointer;
   }


   public void setNextPointer(int next) {
      this.nextPointer = next;
   }  
}
