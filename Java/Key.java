
public class Key<E>{
   
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



}
