
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
