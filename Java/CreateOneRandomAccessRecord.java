import java.nio.file.*;
import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import static java.nio.file.StandardOpenOption.*;

public class CreateOneRandomAccessRecord
{
   public static void main(String[] args) throws Exception
   {
      Path file = Paths.get("RandomEmployees.txt");
      Path errorName = Paths.get("CreateOneRandomeAccessRecord.class");
      String s = "002,Newmann,12.25" + System.getProperty("line.separator");
      byte[] data = s.getBytes();
      ByteBuffer buffer = ByteBuffer.wrap(data); // need wrap method
      final int REC_SIZE = s.length();
      FileChannel fc = null;
      try
      {
         fc = (FileChannel)Files.newByteChannel(file, READ, WRITE);
         fc.position(2 * REC_SIZE);
         fc.write(buffer);
         fc.close();
         Files.delete(errorName);
      }
      catch (Exception e)
      {
         System.out.println(e);
      }
   }
}