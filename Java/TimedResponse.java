import javax.swing.JOptionPane;
import java.time.*;
import java.time.temporal.ChronoUnit;
import java.math.BigDecimal;
import java.util.Date;

public class TimedResponse
{
   public static void main(String[] args)
   {
      //LocalDateTime time1, time2;
      int seconds1, seconds2;
      double difference;
      
      //time1 = LocalDateTime.now();
      Date time1 = new Date();
      //seconds1 = time1.getSecond();
      
      JOptionPane.showConfirmDialog(null, "is stealing ever justified?", null, JOptionPane.YES_NO_CANCEL_OPTION);
      
      //time2 = LocalDateTime.now();
      Date time2 = new Date();
      //seconds2 = time2.getSecond();
      
      //difference = seconds2 - seconds1;
      //difference = time2 - time1;
      
      /*JOptionPane.showMessageDialog(null, "End seconds: " + seconds2 +
                                    "\nStart seconds: " + seconds1 +
                                    "\nIt took " + difference + " seconds for you to answer");*/
      //difference = ChronoUnit.MILLIS.between(time1, time2);
      //BigDecimal num = new BigDecimal(difference/1000);
      /*JOptionPane.showMessageDialog(null, String.format("End time: " + time2 +
                                    "\nStart time: " + time1 +
                                    "\nIt took " + "%.3f" + " seconds for you to answer", num));*/
      double seconds = (double)(time2.getTime()-time1.getTime()) / 1000;
      System.out.printf("%.3f", seconds);
   }
}