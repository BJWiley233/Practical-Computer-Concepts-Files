import java.nio.file.*;
import java.io.*;
import static java.nio.file.StandardOpenOption.*;

public class FileOut
{
   public static void main(String[] args)
   {
      Path file = Paths.get("Grades.txt");
      String s = "ABCDFG";
      byte[] data = s.getBytes();
      OutputStream output = null;
      try
      {
         output = new BufferedOutputStream(Files.newOutputStream(file, WRITE)); //don't need CREATE, is there by default if no arguments
         output.write(data);
         output.flush();
         output.close();
      }
      catch (Exception e)
      {
         System.out.println(e);
      }
   }
}