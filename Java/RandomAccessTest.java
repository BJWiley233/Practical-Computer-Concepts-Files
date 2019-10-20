import java.nio.file.*;
import java.io.*;
import java.nio.channels.FileChannel;
import java.nio.ByteBuffer;
import static java.nio.file.StandardOpenOption.*;

public class RandomAccessTest
{
   public static void main(String[] args)
   {
      Path file = Paths.get("Numbers.txt");
      String s = "XYZ";
      byte[] data = s.getBytes();
      ByteBuffer out = ByteBuffer.wrap(data);
      FileChannel fc = null;
      try
      {
         fc = (FileChannel)Files.newByteChannel(file, CREATE, READ, WRITE);  // need a Numbers.txt file with 01234567890123456789012345678901234567890
         fc.position(0);
         while (out.hasRemaining())
            fc.write(out);
         out.rewind();
         fc.position(22);
         while (out.hasRemaining())
            fc.write(out);
         out.rewind();
         fc.position(12);
         while (out.hasRemaining())
            fc.write(out);
         fc.close();
      }
      catch (Exception e)
      {
         System.out.println(e);
      }
   }
}
         