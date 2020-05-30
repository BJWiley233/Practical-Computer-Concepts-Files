/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

import java.util.Comparator;
import java.util.Map;

/**
 * Implements a Key and Value interface using Map.Entry, <u>NOT</u> to be 
 * confused with the HashMap class from Java.  This class implements an 
 * interface in which I wrote my own methods and my own private comparator 
 * classes.
 * @author bjwil
 * @see {@code README file in zip folder}
 * @version 0.1
 * @since 2019-11-02
 *
 * @param <K> Key the key being entered
 * @param <V> Value the value being entered
 * @see {@link Map.Entry}
 */
public class KeyValue<K extends Comparable<K>, V extends Comparable<V>> implements Map.Entry<K, V>{
   
   private static int DEFAULT_NEXT_POINTER = -1;
   private K key;
   private V value;
   private boolean deleted;
   private int nextPointer;
   public static DescKeyComparator sortKeyDesc = new DescKeyComparator();
   public static AscKeyComparator sortKeyAsc = new AscKeyComparator();
   public static DescCountsComparator sortCountDesc = 
         new DescCountsComparator(); //count # of kmers
   public static AscCountsComparator sortCountAsc = 
         new AscCountsComparator(); //count # of kmers
   public static DescValueComparator sortValueDesc = new DescValueComparator();
   
   public KeyValue(K key, V value, boolean deleted) {
      this(key, value, deleted, DEFAULT_NEXT_POINTER);
   }
   
   /**
    * Constructor for the Key, Value, whether it is deleted if we wished to
    * test the delete method in the class {@link HashTableProbing}.  Include
    * the nextPointer to link to next slot for growing list of same initial 
    * hash slot. Lists will coalesce.
    * @param key
    * @param value
    * @param deleted
    * @param nextPointer
    * @see {@link HashTableProbing#delete(Comparable)}, 
    * {@link HashTableInsideChaining#insert(Comparable, Comparable)}
    */
   public KeyValue(K key, V value, boolean deleted, int nextPointer) {
      this.key = key;
      this.value = value;
      this.deleted = deleted;
      this.nextPointer = nextPointer; // for chaining inside the table
   }
   
   @Override
   public String toString() {
      return ("Key: " + key + ", Value: " + value);
   }
   
   @Override
   public K getKey() {
      return this.key;
   }
   
   /**
    * Makes the key and value null before deleting.  Probably don't need this.
    */
   public void deleteKey() {
      this.key = null;
      this.value = null;
   }
   

   @Override
   public V getValue() {
      return this.value;
   }

   @Override
   public V setValue(V value) {
      this.value = value;
      return this.value;
   }  

   /**
    * Sets the key in the slot to be marked as deleted
    */
   public void setDeleted() {
      this.deleted = true;
   }
   
   /** 
    * Used to check if a key was deleted during the insert and if so the slot
    * can be used.  
    * @return true if was deleted or false if not
    * @see {@link HashTableProbing#delete(Comparable)}, 
    * {@link HashTableInsideChaining#insert(Comparable, Comparable)} 
    */
   public boolean wasDeleted() {
      if (deleted)
         return true;

      return false;
   }
   
   /**
    * Method to return the nextPointer in case of collision for coalesced hashing
    * @return index which slot is pointing to
    */
   public int getNextPointer() {
      return this.nextPointer;
   }

   /**
    * Sets the last Key in the chain of collisions to point to the new last
    * Key in chain
    * @param next
    */
   public void setNextPointer(int next) {
      this.nextPointer = next;
   }  
   
   /**
    * Private comparator to sort the Map.Entry based on keys from greatest
    * to least
    * @author bjwil
    *
    */
   @SuppressWarnings("rawtypes")
   private static class DescKeyComparator implements Comparator<KeyValue> {
      //@Override
      @SuppressWarnings("unchecked")
      public int compare(KeyValue kv1, KeyValue kv2) {
         return kv2.key.compareTo(kv1.key);
      } 
   }
   
   /**
    * Private comparator to sort the Map.Entry based on keys from least
    * to greatest. This is the default sort method.
    * @author bjwil
    *
    */
   @SuppressWarnings("rawtypes")
   private static class AscKeyComparator implements Comparator<KeyValue> {
      //@Override
      @SuppressWarnings("unchecked")
      public int compare(KeyValue kv1, KeyValue kv2) {
         return kv1.key.compareTo(kv2.key);
      } 
   }
   
   /**
    * Private comparator to sort the Map.Entry based on whether the values
    * are counts from greatest to least.
    * @author bjwil
    * @see {@link HashTableProbing#flattenSort}
    * 
    */
   @SuppressWarnings("rawtypes")
   private static class DescCountsComparator implements Comparator<KeyValue> {
      public int compare(KeyValue kv1, KeyValue kv2) {
         return ((Counter)kv2.value).getCount() - (((Counter)kv1.value).getCount());
      } 
   }
   
   /**
    * Private comparator to sort the Map.Entry based on whether the values
    * are counts from least to greatest.
    * @author bjwil
    * @see {@link HashTableProbing#flattenSort}
    * 
    */
   @SuppressWarnings("rawtypes")
   private static class AscCountsComparator implements Comparator<KeyValue> {
      public int compare(KeyValue kv1, KeyValue kv2) {
         return ((Counter)kv1.value).getCount() - (((Counter)kv2.value).getCount());
      } 
   }
   
   /**
    * Private comparator to sort the Map.Entry based on values from greatest
    * to least
    * @author bjwil
    *
    */
   @SuppressWarnings("rawtypes")
   private static class DescValueComparator implements Comparator<KeyValue> {
      @SuppressWarnings("unchecked")
      public int compare(KeyValue kv1, KeyValue kv2) {
         return kv2.value.compareTo(kv1.value);
      } 
   }

  
}
