/*
 *  Copyright 2019, The Johns Hopkins University.  All rights reserved.
 *      This file may be copied and distributed freely for educational
 *      purposes only.  For commercial use, contact The Johns Hopkins
 *      University Whiting School of Engineering.
 */

/**
 * Counter class to use for counts of the keys.  Useful to be able to sort
 * on the number of a Kmer or Kmers in a sequence of a gene or genome. 
 * Basically mimics the function of Python's
 * <pre>
 * <a href="https://docs.python.org/2/library/collections.html#collections.Counter">Collections.Counter</a>
 * </pre>
 * Implements {@link Comparable} so it can be sorted in Key, Value pair.  This 
 * is needed because hash table classes and KeyValue class generic types are 
 * upper bound as they extend Comparable.  In order to sort using a Comparator
 * we need to make the types being stored Comparable.
 * <p>
 * @author bjwil
 *
 */
public class Counter implements Comparable<Counter>  {
   
   private int count;
   
   public Counter() {
      this(1);
   }
   
   public Counter(int initCount) {
      this.count = initCount;
   }
   
   public int getCount() {
      return count;
   }
   
   @Override
   public String toString() {
      return(Integer.toString(count));
   }
   
   public void increment() {
      count++;
   }
   
   public void setCount(int newCount) {
      count = newCount;
   }
   
   @Override
   public int compareTo(Counter o) {
      // TODO Auto-generated method stub
      return 0;
   }
   
}
