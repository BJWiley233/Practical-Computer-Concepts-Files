import java.io.Serializable;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Comparator;
import com.chuckkann.datastructures.Bag;
import com.chuckkann.datastructures.bag.ArrayBag;

final public class Message implements Comparable<Message>, Serializable{
	
	private static final long serialVersionUID = 1L;
	private static final ZoneId utc = ZoneId.of( "UTC" );
	private ZonedDateTime time;
    private String message;
   
	private static final Bag<Message> myMessages = new ArrayBag<Message>();
	private static final Comparator<Message> alwaysTrue = new TrueComparator<Message>();	
	
	//*******************************************
	//* This is the factory pattern code.
	//*******************************************
	public static Message getMessage(String s) {
		Message m = null;
		if ((m = myMessages.remove(m, alwaysTrue)) != null) {
			m.setValues(ZonedDateTime.now(utc), s);
			System.out.println("reusing object");
			return m;
		}
		else {
			System.out.println("getting new object");
			return new Message(s);
		}
	}
	
	public static void returnMessage(Message message) {
		myMessages.add(message);
	}
	
	private static class TrueComparator<T> implements Comparator<T> {
		@Override
		public int compare(T o1, T o2) {
			// TODO Auto-generated method stub
			return 0;
		}		
	}
	//*******************************************
	//* Ending factory code.
	//*******************************************	
	
	// Note that Message is private
	private Message(String message) {
		this.time = ZonedDateTime.now(utc);
		this.message = message;
	}
	
	public void setValues(ZonedDateTime time, String message) {
		this.time = time;
		this.message = message;	
	}
	
	public String toString() {
		return (time + " " + message);
	}
	
    @Override
    public int compareTo(Message messages) { 
	    return(time.compareTo(messages.time));
    }	

	public static void main(String[] args) {
        Message m1 = Message.getMessage("test1");
        Message m2 = Message.getMessage("test2");
        Message.returnMessage(m2);
        Message m3 = Message.getMessage("test3");
        m3 = Message.getMessage("test4");
	}
}