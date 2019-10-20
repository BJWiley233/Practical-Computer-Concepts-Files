import java.nio.file.*;

public class InputOutputDemo
{
   public static void main(String[] args)
   {
      FileSystem fs = FileSystems.getDefault();
      Path path = fs.getPath("C:\\Users\\bjwil\\Documents\\Data.txt");
      System.out.println(path.getFileName());
   }
}