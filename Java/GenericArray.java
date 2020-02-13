import java.util.Iterator;

class GenericArray<E> implements Iterable<E> {
    private E[] elements;
    
   @SuppressWarnings("unchecked") 
    public GenericArray(int size) {
    	    this.elements = (E[]) new Object[size];
    }
    
    public void set(int pos, E p){
    	elements[pos]=p;
    }
    
    public E get(int pos){
    	return elements[pos];
    }
    
    public int length() {
    	return elements.length;
    }
    
    public Iterator<E> iterator() {
    	return new GenericIterator<E>();
    }
    
    private class GenericIterator<E1> implements Iterator<E1> {

    	int item;
    	public GenericIterator() {
    		item = 0;
    	}
    	
		@Override
		public boolean hasNext() {
			if ((item + 1) > elements.length) {
				return false;
			}
			return true;
		}

		@SuppressWarnings("unchecked")
		@Override
		public E1 next() {
			item++;
			return (E1)elements[item - 1];
		}   	
    }
    
    public static void main(String args[]) {
    	GenericArray<String> ga= new GenericArray<String>(5);
    	ga.set(0,  "Abc");
    	ga.set(2,  "Def");
    	
    	for (String s: ga) {
    		System.out.println(s);
    	}
    }
}

