import java.nio.file.*;
import java.io.*;
import java.nio.ByteBuffer;
import static java.nio.file.StandardOpenOption.*;

public class CreateEmptyEmployeesFile
{
   public static void main(String[] args) throws Exception
   {
      Path file = Paths.get("RandomEmployees.txt");
      String s = "000,       ,00.00" + System.getProperty("line.separator");
      byte[] data = s.getBytes();
      ByteBuffer buffer = ByteBuffer.wrap(data); // need wrap method
      final int N_REC = 1000;
      try
      {
         OutputStream output = new BufferedOutputStream(Files.newOutputStream(file, CREATE));
         BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(output));
         for (int count = 0; count < N_REC; ++count)
            writer.write(s, 0, s.length());
         writer.close();
      }
      catch (Exception e)
      {
         System.out.println(e);
      }
   }
}